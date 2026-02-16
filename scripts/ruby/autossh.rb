#!/usr/bin/env ruby

# The servers are configured with PermitRootLogin = NO.
# So that you first login as regular user and then su to root.
###############################################################################
#
# Place this bash function in ~/.bashrc and source ~/.bashrc
# It extracts 'servername, username and password from a rails app called pim.
#
# function autossh() {
#   cd ~/path/to/pim && ~/path/to/autossh.rb `rails ssh:login["$1"]`
# }
#
# Change the `pim` to the pim rails app.
# Change the path `autossh.rb` to this script.
#
# usage in bash terminal: autossh servername
#
################################################################################

require "expect"
require "pty"
require "io/console"

username = ENV["USER"]

servername, userpass, rootpass = ARGV

# Check if we have all three arguments
prompts = %w[Servername Userpassword Rootpassword]
args = [servername, userpass, rootpass]

args.each_with_index do |arg, i|
  if arg.nil? || arg.empty?
    print "#{prompts[i]}: "
    args[i] = $stdin.gets.chomp
  end
end

servername, userpass, rootpass = args

puts "Servername #{servername}"

# Set the window title
print "\033]0;#{servername}\007"

# Spawn the ssh process
reader, writer, pid = PTY.spawn("ssh #{username}@#{servername}")

sleep(1)

# Handle host key verification and password prompt
reader.expect(/(\(yes\/no\)\?\s*$|assword:\s*$)/, 10) do |match|
  if match[0] =~ /yes\/no/
    writer.puts("yes")
    reader.expect(/assword:\s*$/, 10) do
      writer.puts(userpass)
    end
  else
    writer.puts(userpass)
  end
end

sleep(1)

# Switch to root
writer.puts("su -")
reader.expect(/assword:\s*$/, 10) do
  writer.puts(rootpass)
end

sleep(1)

# Propagate terminal size to the PTY so that vim and other programs
# handle resizing correctly.
set_winsize = -> {
  rows, cols = $stdout.winsize
  reader.winsize = [rows, cols]
}

# Set initial size and forward SIGWINCH on every resize
set_winsize.call
Signal.trap("WINCH") { set_winsize.call }

# Hand over control: relay between user's terminal and the SSH session
# Put terminal in raw mode for proper interactive use
$stdin.raw do
  loop do
    readable, = IO.select([$stdin, reader], nil, nil)
    readable.each do |io|
      if io == $stdin
        input = $stdin.read_nonblock(4096)
        writer.write(input)
      else
        output = reader.read_nonblock(4096)
        $stdout.write(output)
      end
    end
  end
rescue Errno::EIO, EOFError
  # PTY process ended
end

Process.wait(pid)

#!/usr/bin/env ruby

# The servers are configured with PermitRootLogin = NO.
# So that you first login as regular user and then su to root.
###############################################################################
#
# Place this bash function in ~/.bashrc and source ~/.bashrc
# It extracts 'servername, username and password from a rails app called pim.
#
# function autossh() {
#   cd ~/path/to/pim && ~/path/to/autossh.rb `rails ssh:login["$1"]` && cd -
# }
#
# Change the `pim` to the pim rails app.
# Change the path `autossh.rb` to this script.
#
# usage in bash terminal: autossh servername
#
################################################################################

#!/usr/bin/env ruby

require "expect"
require "pty"
require "io/console"

username = ENV["USER"]

# Read login information from stdin if available, otherwise fall back to ARGV.
if !$stdin.tty?
  line = STDIN.gets&.chomp
  abort("No login information received.") if line.nil? || line.empty?

  servername, userpass, rootpass = line.split(/\s+/, 3)
else
  servername, userpass, rootpass = ARGV
end

# Prompt for any missing values.
prompts = %w[Servername Userpassword Rootpassword]
args = [servername, userpass, rootpass]

args.each_with_index do |arg, i|
  if arg.nil? || arg.empty?
    print "#{prompts[i]}: "
    args[i] = STDIN.gets.chomp
  end
end

servername, userpass, rootpass = args

puts "Servername #{servername}"

# Set the window title.
print "\033]0;#{servername}\007"

# Spawn the ssh process.
reader, writer, pid = PTY.spawn("ssh #{username}@#{servername}")

sleep(1)

# Handle host key verification and password prompt.
reader.expect(/(\(yes\/no\)\?\s*$|assword:\s*$)/, 10) do |match|
  $stdout.write(match[0])

  if match[0].include?("yes/no")
    writer.puts("yes")

    reader.expect(/assword:\s*$/, 10) do |m|
      $stdout.write(m[0])
      writer.puts(userpass)
    end
  else
    writer.puts(userpass)
  end
end

sleep(1)

# Display any output before switching to root.
begin
  loop do
    output = reader.read_nonblock(4096)
    $stdout.write(output)
  end
rescue IO::WaitReadable, Errno::EIO, EOFError
end

# Switch to root.
writer.puts("su -")

reader.expect(/assword:\s*$/, 10) do |match|
  $stdout.write(match[0])
  writer.puts(rootpass)
end

sleep(1)

# Keep the PTY size synchronized with the terminal.
set_winsize = lambda do
  rows, cols = $stdout.winsize
  reader.winsize = [rows, cols]
end

set_winsize.call
Signal.trap("WINCH") { set_winsize.call }

# Relay input/output.
STDIN.raw do
  loop do
    readable, = IO.select([STDIN, reader])

    readable.each do |io|
      if io == STDIN
        writer.write(STDIN.read_nonblock(4096))
      else
        $stdout.write(reader.read_nonblock(4096))
      end
    end
  end
rescue Errno::EIO, EOFError
end

Process.wait(pid)

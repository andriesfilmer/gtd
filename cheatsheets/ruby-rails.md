# Ruby & Rails

## Ruby Install

    apt install ruby ruby-dev
    apt install bundler # or ruby-bundler?
    apt install libyaml-dev # Needed for gem psych
    apt install default-libmysqlclient-dev # Needed for gem mysql2
    apt install mariadb-client
    apt install nodejs
    apt install build-essential


## Git

    git clone https://github.com/some-repository
    cd some-repository
    sudo gem update

## Bundler

    sudo bundle install
    sudo bundle update --bundler
    sudo bundle update

Find where the gems are stored.

    gem enviroment
    bundle env

## Rails

Minimal install

    rails new app-with-trilogy --database=trilogy --api --minimal --skip-test --skip-system-test --skip-javascript

Precompile assets

    RAILS_ENV=production rails assets:precompile

## Puma

    adduser puma
    chown -R puma:www-data /path/to/workdir

Default Ruby Web Server

* [Puma systemd](https://github.com/puma/puma/blob/master/docs/systemd.md)

## Rubocop

    gem install rubocop

rubocop.yml

    * <https://docs.rubocop.org/rubocop/cops.html>
    * <https://www.rubydoc.info/gems/rubocop/RuboCop/Cop/>


## Mail testing

Non delevery to real mailaddresses:

    lib/development_mail_interceptor.rb, config/initializers/setup_mail.rb => development_mail_interceptor

* [SMTP for development](http://everydayrails.com/2011/05/26/rails-smtp-development.html)
* [Testing series rspec controllers](http://everydayrails.com/2012/04/07/testing-series-rspec-controllers.html)

## Mailcatcher

For development

    gem install mailcatcher

* [mailcatcher](http://mailcatcher.me/)

## Rails console

[View output as ascii tables and trees](https://github.com/cldwalker/hirb/tree/master#readme)

    Hirb.enable

The y method is a handy way to get some pretty YAML output.

    y Model.all

## Delayed Jobs

Run last job on the console:

    Delayed::Worker.new.run(Delayed::Job.last)

## sqlite to mysql

Simply add to your Gemfile:

    gem 'yaml_db'

All rake tasks will then be available to you. Usage

    rake db:data:dump   ->   Dump contents of Rails database to db/data.yml
    rake db:data:load   ->   Load contents of db/data.yml into the database

* [github.com/ludicast/yaml_db](https://github.com/ludicast/yaml_db)


## Ruby on MacBook

Homebrew installs the stuff you need that Apple (or your Linux system) didn’t.

    brew -h
    brew install bundler # Example

* <https://brew.sh/>

Do Not Use the MacOS System Ruby <https://mac.install.guide/faq/do-not-use-mac-system-ruby/>

   ruby -v    # ruby 2.6.10p210
   exec zsh
   asdf install ruby 3.2.3
   ruby -v    # ruby 3.2.3
   gem install rails
   cd dev && rails new weblog

* <https://gorails.com/setup/macos/14-sonoma>

## Resources

* [Ruby](http://www.ruby-lang.org/en/) language
* [Ruby on Rails Guides](http://guides.rubyonrails.org/)
* [Active Support Core Extensions](https://guides.rubyonrails.org/active_support_core_extensions.html) | Extensions, utilities, and other transversal stuff
* [Upgrading Rails](https://guides.rubyonrails.org/upgrading_ruby_on_rails.html)
* [Configuring Rails applications](https://guides.rubyonrails.org/configuring.html) | Versioned Default Values
* [API - Welcome to Rails](http://api.rubyonrails.org)
* [Help and documentation for the Ruby programming language](http://www.ruby-doc.org)
* [bundle](http://gembundler.com/)
* [The Ruby community's gem hosting service](http://rubygems.org)
* [RubyGems Guides](http://guides.rubygems.org)
* [Ruby Tutorial - tutorialspoint.com](http://www.tutorialspoint.com/ruby/index.htm)

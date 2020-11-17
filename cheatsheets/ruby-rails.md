# Ruby & Rails

## Ruby Install

    apt install ruby ruby-dev
    apt install nodejs
    apt install ruby-bundler
    apt install mariadb-client
    apt install default-libmysqlclient-dev # Needed for gem mysql2

## Git

    git clone https://github.com/some-repository
    sudo gem update

## Bundler

    sudo bundle install
    sudo bundle update --bundler
    sudo bundle update

## Rails

    RAILS_ENV=production rails assets:precompile

## Puma

Default Ruby Web Server

* [Puma systemd](https://github.com/puma/puma/blob/master/docs/systemd.md)

## Mail testing

Non delevery to real mailaddresses:

    lib/development_mail_interceptor.rb, config/initializers/setup_mail.rb => development_mail_interceptor

* [SMTP for development](http://everydayrails.com/2011/05/26/rails-smtp-development.html)
* [Testing series rspec controllers](http://everydayrails.com/2012/04/07/testing-series-rspec-controllers.html)

## Mailcatcher
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

## Sqlite

Use the following to get a CSV file, which I can import into almost everything

    sqlite>.mode csv
    sqlite>.header on
    sqlite>.out file.csv
    sqlite>select * from people;

To import from an SQL file use the following:

    sqlite> .read <filename>

To import from a CSV file you will need to specify the file type and destination table:

    sqlite> .mode csv <table>
    sqlite> .import <filename> <table>

If you want to reinsert into a different SQLite database then:

    sqlite>.mode insert
    sqlite>.out file.sql
    sqlite>select * from file.sql

* [Sqlite tutorial](http://souptonuts.sourceforge.net/readme_sqlite_tutorial.html)

### sqlite to mysql

Simply add to your Gemfile:
    gem 'yaml_db'

All rake tasks will then be available to you. Usage

    rake db:data:dump   ->   Dump contents of Rails database to db/data.yml
    rake db:data:load   ->   Load contents of db/data.yml into the database

* [github.com/ludicast/yaml_db](https://github.com/ludicast/yaml_db)


## Resources
* [ruby](http://www.ruby-lang.org/en/) language
* [rails](http://rubyonrails.org/) framework
* [API - Welcome to Rails](http://api.rubyonrails.org)
* [Help and documentation for the Ruby programming language](http://www.ruby-doc.org)
* [bundle](http://gembundler.com/)
* [The Ruby community's gem hosting service](http://rubygems.org)
* [RubyGems Guides](http://guides.rubygems.org)
* [Ruby Tutorial - tutorialspoint.com](http://www.tutorialspoint.com/ruby/index.htm)

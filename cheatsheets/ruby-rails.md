
## Ruby Install
    sudo apt-get install ruby2.5 ruby2.5-dev


## Rails install

    sudo gem install rails

Run rails without env.

    bundle exec rails

### Extra installs

    sudo apt-get install libsqlite3-dev # sqlite
    sudo apt-get install libmysqlclient-dev # mysql2

## Test and production envoiroments

    rails db -e test
    rails db -e production

    rake db:migrate RAILS_ENV=test
    rake db:migrate RAILS_ENV=staging

## Mail testing

Non delevery to real mailaddresses:

    lib/development_mail_interceptor.rb, config/initializers/setup_mail.rb => development_mail_interceptor

* [SMTP for development](http://everydayrails.com/2011/05/26/rails-smtp-development.html)
* [Testing series rspec controllers](http://everydayrails.com/2012/04/07/testing-series-rspec-controllers.html)

## Mailcatcher
    gem install mailcatcher

* [mailcatcher](http://mailcatcher.me/)

## Passenger

    apt-get install libapache2-mod-passenger

* [Digitalocean - How To Install Rails, Apache, and MySQL on Ubuntu with Passenger](https://www.digitalocean.com/community/articles/how-to-install-rails-apache-and-mysql-on-ubuntu-with-passenger)
* [scoutapp.com - Production Rails Tuning with Passenger: PassengerMaxProcesses ](http://blog.scoutapp.com/articles/2009/12/08/production-rails-tuning-with-passenger-passengermaxprocesses)

## Puma server

Have todo some testing with Puma.
* [blog.wiemann.name/rails-server)](http://blog.wiemann.name/rails-server)

## Working with javascript

* [edgeguides.rubyonrails.org - Working with javascript in rails](http://edgeguides.rubyonrails.org/working_with_javascript_in_rails.html)
* [railsapps.github.io - Rails-javascript-include-external](http://railsapps.github.io/rails-javascript-include-external.html)

## Rails console
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

## Database sqlite to mysql

Simply add to your Gemfile:
    gem 'yaml_db'

All rake tasks will then be available to you. Usage

    rake db:data:dump   ->   Dump contents of Rails database to db/data.yml
    rake db:data:load   ->   Load contents of db/data.yml into the database

* [github.com/ludicast/yaml_db](https://github.com/ludicast/yaml_db)


## Foundation
    gem 'zurb-foundation'
    gem 'foundation-icons-sass-rails'
    gem 'foundation-will_paginate'

* [Foundation Cheat-sheet](https://princessdesign.net/foundation-cheat-sheet/)
* [Rails Apps - Rails Foundation](http://railsapps.github.io/rails-foundation.html)
* [Understanding M17n (Multilingualization) and encoding](http://graysoftinc.com/character-encodings/understanding-m17n-multilingualization)


## Tools
* [ruby](http://www.ruby-lang.org/en/) language
* [rails](http://rubyonrails.org/) framework
* [gem](http://guides.rubygems.org/what-is-a-gem/) package manager
** [bundle](http://gembundler.com/)

## Resources

* [Help and documentation for the Ruby programming language](http://www.ruby-doc.org)
* [Ruby on Rails](http://rubyonrails.org)
* [Ruby on Rails Guides](http://guides.rubyonrails.org)
* [The Ruby community's gem hosting service](http://rubygems.org)
* [RubyGems Guides](http://guides.rubygems.org)
* [API - Welcome to Rails](http://api.rubyonrails.org)
* [Ruby Tutorial - tutorialspoint.com](http://www.tutorialspoint.com/ruby/index.htm)
* [Ruby Rails tutorial.org](http://ruby.railstutorial.org/)


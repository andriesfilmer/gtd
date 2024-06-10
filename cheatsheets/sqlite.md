# Sqlite

## Install

    bundle install sqlite3-ruby

## common commands

    sqlite> .quit
    sqlite> .help
    sqlite> .databases
    sqlite> .tables


Show schema of all tables

    sqlite> .schema
    sqlite> .schema PRODUCTS


# Export - Import

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

## mysql2sqlite

   <https://github.com/andriesfilmer/gtd/tree/master/scripts/awk/mysql2sqlite.awk>
   Original <https://github.com/dumblob/mysql2sqlite/>

## Resources

* [Sqlite tutorial](http://souptonuts.sourceforge.net/readme_sqlite_tutorial.html)

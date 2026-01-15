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

# .sqliterc

````
#.explain on
#.excel
.headers on
.changes on
#.timer on
#
#.mode column
#.mode line
#.mode box
.mode table
````

See settings with `.show`

# Statistics

Run statistics regular

    PRAMA optimize;

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

## Usefull query's

Different from mysql
````
SELECT id,user_id,allDay,title,start,end,tz FROM events WHERE user_id = 1 AND julianday(end) - julianday(start) > 1;
UPDATE events SET end = date(end) || ' 22:59:00' WHERE AllDay = 1 AND time(end) = '23:00:00';
UPDATE events SET end = datetime(end, '-1 day') WHERE AllDay = 1;
UPDATE events SET end = datetime(end, '-1 hour', '-1 minute') WHERE time(end) = '00:00:00';

````
## Resources

* [Sqlite cli](https://sqlite.org/cli.html)
* [Sqlite docs](https://www.sqlite.org/docs.html)
* [Litestream](https://litestream.io/) Fully-replicated sqlite database with no pain and little cost.

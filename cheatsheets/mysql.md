- [MariaDb](#mariadb)
- [Usage](#usage)
  * [Grant privileges](#grant-privileges)
  * [Revoke privileges](#revoke-privileges)
  * [Drop and revoke](#drop-and-revoke)
  * [Change password user](#change-password-user)
  * [To create a FULLTEXT index](#to-create-a-fulltext-index)
  * [Reset auto increment value](#reset-auto-increment-value)
  * [Table give new id's](#table-give-new-ids)
  * [Remove dubble rows](#remove-dubble-rows)
  * [JSON](#json)
  * [CSV to Table](#csv-to-table)
  * [Table to CSV](#table-to-csv)
  * [Convert utf8 to utf8mb4](#convert-utf8-to-utf8mb4)
- [Configuration](#configuration)
  * [Example my.cnf](#example-mycnf)
- [Varables](#varables)
- [Preformance](#preformance)
- [Tips](#tips)
  * [Table status](#table-status)
  * [Search history](#search-history)
- [Resources](#resources)

<!-- END TOC -->

# MariaDb

    sudo apt install mariadb-server
    sudo mysql_secure_installation # in production
    sudo mariadb

# Usage

## Grant privileges

    SELECT password('secret_pass');
    GRANT USAGE ON *.* TO testuser@localhost IDENTIFIED BY PASSWORD '*B4D3172CC9FCDC297A3E95948AABE93C2D0BD44B';
    GRANT ALL PRIVILEGES ON testdb.* TO testuser@localhost;

Request grants:

    SHOW GRANTS FOR dbuser@localhost;


## Revoke privileges

    REVOKE ALL PRIVILEGES ON testdb.* FROM testuser@'localhost';

## Drop and revoke

    DROP user testuser@localhost;

If user can't make databases

    REVOKE CREATE ON *.* FROM testuser@localhost;

## Change password user

    update user set password=PASSWORD("NEW-PASSWORD-HERE") where User='tom'

## To create a FULLTEXT index

    CREATE FULLTEXT INDEX fulltext_index ON table_name (column_1,column_2,column_3);

## Reset auto increment value

    ALTER TABLE tablename AUTO_INCREMENT=1;

## Table give new id's

    SET @var_name = 0;
    UPDATE Tablename SET ID = (@var_name := @var_name +1);
    ALTER TABLE Tablename AUTO_INCREMENT = @var_name;

## Remove dubble rows

    CREATE TEMPORARY TABLE mail_temp AS SELECT * FROM `mail`
    GROUP BY `mail_id`,`mail_user_id`,`mail_type`
    ORDER BY `mail_date` DESC;
    DELETE FROM `mail`;
    INSERT INTO `mail` SELECT * FROM `mail_temp`;
    DROP TABLE mail_temp;


## JSON

    MariaDB [database]> select * from products;
    +----+--------+-------+-------+---------------------------------+-------------+
    | id | name   | price | stock | attr                            | attr_colour |
    +----+--------+-------+-------+---------------------------------+-------------+
    |  1 | Jeans  | 10.50 |   165 | NULL                            | NULL        |
    |  2 | Shirt  | 10.50 |    78 | {"size": 42, "colour": "white"} | white       |
    |  3 | Blouse | 17.00 |    15 | {"colour": "red"}               | red         |
    +----+--------+-------+-------+---------------------------------+-------------+
    MariaDB [database]> select *,JSON_VALUE(attr, '$.colour') as colour from products where JSON_EXTRACT(attr, "$.colour") = 'red';
    +----+--------+-------+-------+-------------------+-------------+--------+
    | id | name   | price | stock | attr              | attr_colour | colour |
    +----+--------+-------+-------+-------------------+-------------+--------+
    |  3 | Blouse | 17.00 |    15 | {"colour": "red"} | red         | red    |
    +----+--------+-------+-------+-------------------+-------------+--------+

## CSV to Table

    LOAD DATA LOCAL INFILE '/home/user/import.csv' INTO TABLE `import`
    FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY '\' LINES TERMINATED BY '';

Other example with multiple lines in column 'notes'.

    LOAD DATA INFILE '/path/to/yourfile.csv' INTO TABLE your_table_name
    FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY ''
    IGNORE 1 ROWS
    (title, description, tags, url, @notes, updated_at, created_at) SET notes = REPLACE(@notes, '
', '');

You may also have to call mysql with the --local-infile option.

## Table to CSV

    SELECT REPLACE(CONCAT(first_name,' ',IFNULL(infix,''),' ',last_name),'  ',' '),email FROM people
    INTO OUTFILE 'inzetrooster/admins.csv' FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '';

## Convert utf8 to utf8mb4

This is needed for using smiley icons like 😊

    # For each database:
    ALTER DATABASE database_name CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;
    # For each table:
    ALTER TABLE table_name CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
    # For each column:
    ALTER TABLE table_name CHANGE column_name column_name VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

**Don’t blindly copy-paste this! The exact statement depends on the column type, maximum length, and other properties.
 The above line is just an example for a `VARCHAR` column.**

Check you configuration

    SHOW VARIABLES WHERE Variable_name LIKE 'character_set_%' OR Variable_name LIKE 'collation%';

* [Mathias Bynes - mysql-utf8mb4](https://mathiasbynens.be/notes/mysql-utf8mb4)
* [How to store emoji in rails app with mysql](http://blog.arkency.com/2015/05/how-to-store-emoji-in-a-rails-app-with-a-mysql-database/)

# Configuration

## Example my.cnf

In development

````
[client]
#default-character-set = latin1
default-character-set = utf8mb4
user=root
password=mypassword

[mysql]
default-character-set = utf8mb4

[mysqld]
#character-set-client-handshake = FALSE
#character-set-server = latin1
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci

# Add start skip-grant-tables if password lost.
# And restart MySQL service.
#
#skip-grant-tables


On server (production)

````

Main Configuration Files:

* Global defaults: /etc/my.cnf or /etc/mysql/my.cnf
* Additional configuration files: /etc/my.cnf.d/ or /etc/mysql/conf.d/

`vi /etc/mysql/mariadb.conf.d/z-custom-mariadb.cnf`


````
[mariadb]
innodb_buffer_pool_size = 1G  # default 128M
query_cache_size = 32M        # default 1M
max_connections = 500         # default 151

#join_buffer_size = 2M        # default 262144 -> 0.26M
#tmp_table_size = 128M        # default 16777216 -> 1.6M
#max_heap_table_size = 128M   # default 16777216 -> 1.6M

# Review Slow Queries
slow_query_log = 1
slow_query_log_file = /var/log/mysql/mysql-slow.log
long_query_time = 3
````

# Varables

Command-line: Run the following command to see which configuration files MariaDB is using:

    mysqld --verbose --help
    mysql --execute 'SHOW VARIABLES;' > ~/mysql-vars.txt

View system variables in mysql client

    SHOW PROCESSLIST;

* [MariaDb System variables](https://mariadb.com/kb/en/server-system-variables/)

# Preformance

    SHOW ENGINE InnoDB STATUS;

    SELECT @@innodb_buffer_pool_size;
    SELECT @@innodb_buffer_pool_chunk_size;
    SELECT @@query_cache_size;

Look how these values change over a minute

    SHOW STATUS LIKE 'Innodb_buffer_pool_pages_free';
    SHOW STATUS LIKE 'innodb_buffer_pool_wait_free';
    SHOW STATUS LIKE 'Innodb_buffer_pool_pages_flushed';
    SHOW STATUS LIKE 'innodb_buffer_pool_reads';
    SHOW STATUS LIKE 'innodb_buffer_pool_read_requests';

`innodb_buffer_pool_size` / `innodb_buffer_pool_chunk_size` should not exceed 1000 in order to avoid performance issues.

`innodb_buffer_pool_pages_free` should not be zero or close to zero. We should always have free pages available.

`innodb_buffer_pool_wait_free` should not happen. It indicates that a user thread is waiting because it found no free pages to write into.

`innodb_buffer_pool_pages_flushed` should be low, or we are flushing too many pages to free pages. Compare it with the number of read pages.

`innodb_buffer_pool_reads` must be about 1% innodb_buffer_pool_read_requests.

`innodb_buffer_pool_reads / `innodb_buffer_pool_read_requests` should be low, or the buffer pool is not preventing enough disk reads.


* [InnoDB Buffer Pool](https://mariadb.com/kb/en/innodb-buffer-pool/)
* [innodb_buffer_pool_size / innodb_buffer_pool_chunk_size](https://mariadb.com/kb/en/setting-innodb-buffer-pool-size-dynamically/)

# Tips

## Table status

    SHOW TABLE STATUS;

## Search history

In the mysql-client command

    ctr-r

or

    sed "s/\ / /g" < .mysql_history | grep 'search sql'

# Resources

* [MariaDb Knowloge Base](https://mariadb.com/kb/)
* [Mysql docs](http://dev.mysql.com/doc/).

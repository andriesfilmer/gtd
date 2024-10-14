# MariaDb

    sudo apt install mariadb-server
    sudo mysql_secure_installation # in production
    sudo mariadb

# Mysql

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

## Example my.cnf

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

````

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

    MariaDB [andries]> select * from products;
    +----+--------+-------+-------+---------------------------------+-------------+
    | id | name   | price | stock | attr                            | attr_colour |
    +----+--------+-------+-------+---------------------------------+-------------+
    |  1 | Jeans  | 10.50 |   165 | NULL                            | NULL        |
    |  2 | Shirt  | 10.50 |    78 | {"size": 42, "colour": "white"} | white       |
    |  3 | Blouse | 17.00 |    15 | {"colour": "red"}               | red         |
    +----+--------+-------+-------+---------------------------------+-------------+
    MariaDB [andries]> select *,JSON_VALUE(attr, '$.colour') as colour from products where JSON_EXTRACT(attr, "$.colour") = 'red';
    +----+--------+-------+-------+-------------------+-------------+--------+
    | id | name   | price | stock | attr              | attr_colour | colour |
    +----+--------+-------+-------+-------------------+-------------+--------+
    |  3 | Blouse | 17.00 |    15 | {"colour": "red"} | red         | red    |
    +----+--------+-------+-------+-------------------+-------------+--------+

## Een CSV file in een tabel zetten

    LOAD DATA LOCAL INFILE '/home/user/import.csv' INTO TABLE `import`
    FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY '\' LINES TERMINATED BY '';

Other example with multiple lines in column 'notes'.

    LOAD DATA INFILE '/path/to/yourfile.csv' INTO TABLE your_table_name
    FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '
'
    IGNORE 1 ROWS
    (title, description, tags, url, @notes, updated_at, created_at) SET notes = REPLACE(@notes, '\n', '');

You may also have to call mysql with the --local-infile option.

## Table to CSV

    SELECT REPLACE(CONCAT(first_name,' ',IFNULL(infix,''),' ',last_name),'  ',' '),email FROM people
    INTO OUTFILE 'inzetrooster/admins.csv' FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '
';

## Score example

    SELECT *, (100 - (LOCATE(LOWER('$keyword'), LOWER(content))/LENGTH(LOWER(content))) *100) AS score,
    LOCATE(LOWER('$keyword'), LOWER(content)) AS loc
    FROM page_lang
    WHERE LOWER(ppl_content) LIKE LOWER('%$keyword%')
    AND LOCATE(LOWER('$keyword'), LOWER(content)) != 0
    AND online = 'y'
    AND lang = 'language'
    ORDER BY score DESC
    LIMIT 0,20;

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

## Convert Antelope to Barracuda

    SHOW VARIABLES LIKE "innodb_file_format";

    SET global innodb_file_format=Barracuda;
    SET global innodb_large_prefix=on;
    SET GLOBAL innodb_file_format = "Barracuda";
    SET GLOBAL innodb_file_format_max = "Barracuda";
    SET GLOBAL innodb_file_per_table = "ON";
    SET GLOBAL innodb_strict_mode = "ON";
    USE INFORMATION_SCHEMA;
    SELECT CONCAT("ALTER TABLE `", TABLE_SCHEMA,"`.`", TABLE_NAME, "` ROW_FORMAT=DYNAMIC;") AS MySQLCMD FROM TABLES WHERE ENGINE='innodb' AND ROW_FORMAT != 'DYNAMIC' AND ROW_FORMAT !='COMPRESSED';

# Tips

## Search history

In the mysql-client command

    ctr-r

or

    sed "s/\ / /g" < .mysql_history | grep 'search sql'

# Resources

* [Mysql docs](http://dev.mysql.com/doc/).
* [How To Use Mytop to Monitor MySQL Performance](https://www.digitalocean.com/community/tutorials/how-to-use-mytop-to-monitor-mysql-performance)

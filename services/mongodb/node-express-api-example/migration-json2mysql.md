## Export mongodb

    mongoexport --db pim --collection contacts --csv --fieldFile contact-fields.txt > api/tmp/contacts.csv
    mongoexport --db pim --collection events --csv --fieldFile event-fields.txt > api/tmp/events.csv
    mongoexport --db pim --collection posts --csv --fieldFile post-fields.txt > api/tmp/posts.csv
    mongoexport --db pim --collection bookmarks --csv --fieldFile bookmark-fields.txt > api/tmp/bookmarks.csv

## Import MariaDb/Mysql

Mariadb from version 10.2 has JSON_VALID function.
If you use a older version remove the lines with 'JSON_VALID'

Use '--local-infile' with startup mysql-client for LOAD DATA.

    USE pim;

# Users table.

    DROP TABLE IF EXISTS `user`;
    CREATE TABLE `user` (
       `id` smallint(6) NOT NULL AUTO_INCREMENT,
       `email` varchar(255) DEFAULT NULL,
       `name` varchar(100) DEFAULT NULL,
       `password` varchar(20) DEFAULT NULL,
       `active` boolean default 1,
       PRIMARY KEY (`id`)
    );

    # Create a user to login.
    INSERT INTO user (name,email,password) values ('Andries Filmer','andries@filmer.nl','secretPW1');
    INSERT INTO user (name,email,password) values ('Alex Filmer','alex@filmer.nl','secretPW1');
    INSERT INTO user (name,email,password) values ('Olaf Roselaar','liflaf@xs4all.nl','secretPW1');
    INSERT INTO user (name,email,password) values ('Marco vd Staaij','liflaf@xs4all.nl','secretPW1');


## Events table

    DROP TABLE IF EXISTS `events`;
    CREATE TABLE `events` (
      `mongo_id` varchar(100) NULL,
      `user_id` varchar(100) NOT NULL DEFAULT 0,
      `title` varchar(100) NOT NULL,
      `description` text,
      `start` varchar(100) NOT NULL,
      `end` varchar(100) NOT NULL,
      `startTime` varchar(255) DEFAULT NULL,
      `name` varchar(255) DEFAULT NULL,
      `className` varchar(1024) DEFAULT 'appointment',
      `allDay` varchar(100) DEFAULT NULL,
      `tz` varchar(100) DEFAULT NULL,
      `created` varchar(100) DEFAULT NULL,
      `updated` varchar(100) DEFAULT NULL,
      KEY (`user_id`)
    ) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;

    LOAD DATA LOCAL INFILE '/home/andries/dev/pim2/api/tmp/events.csv'
    INTO TABLE `events` CHARACTER SET utf8mb4
    FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY '\\' LINES TERMINATED BY '\n'
    IGNORE 1 LINES ;

    ALTER TABLE events ADD id INT PRIMARY KEY AUTO_INCREMENT first;

    UPDATE events set mongo_id = SUBSTR(mongo_id,10,24);
    UPDATE events set created = SUBSTR(created,1,14);
    UPDATE events set updated=created where updated like '%numberlong%';
    #UPDATE events set created = SELECT STR_TO_DATE(created,'%Y-%m-%dT%TZ');
    UPDATE events set created = REGEXP_REPLACE(created,'T',' ');
    UPDATE events set created = REGEXP_REPLACE(created,'.{5}$','');
    UPDATE events set updated = REGEXP_REPLACE(updated,'T',' ');
    UPDATE events set updated = REGEXP_REPLACE(updated,'.{5}$','');
    UPDATE events set start = REGEXP_REPLACE(start,'T',' ');
    UPDATE events set start = REGEXP_REPLACE(start,'.{5}$','');
    UPDATE events set end=start WHERE end like '%numberlong%';
    UPDATE events set end = REGEXP_REPLACE(end,'T',' ');
    UPDATE events set end = REGEXP_REPLACE(end,'.{5}$','');
    UPDATE events set allDay = 1 WHERE allDay = 'true';
    UPDATE events set allDay = 0 WHERE allDay = 'false';

    DELETE FROM events WHERE user_id='54c7bdfa507c42a604ce707e';
    DELETE FROM events WHERE user_id='5555b01a9f6fca7a04bb75a3';
    DELETE FROM events WHERE user_id='56659a6c4b5ebfb804823327';


    ALTER TABLE events CHANGE created created DATETIME DEFAULT CURRENT_TIMESTAMP;
    ALTER TABLE events CHANGE updated updated DATETIME DEFAULT CURRENT_TIMESTAMP;
    ALTER TABLE events CHANGE start start DATETIME;
    ALTER TABLE events CHANGE end end DATETIME;
    ALTER TABLE events CHANGE allDay allDay BOOLEAN DEFAULT 1;

    UPDATE events SET user_id='1' WHERE user_id='54c604baa6dedf6721cf609a';
    UPDATE events SET user_id='2' WHERE user_id='56e18dd635f8a31456da8839';
    UPDATE events SET user_id='3' WHERE user_id='568f9f2eac2e8b804105bfaa';
    UPDATE events SET user_id='3' WHERE user_id='54d8f3c4f9759c96034d11fa';
    ALTER TABLE events CHANGE user_id user_id INT NOT NULL DEFAULT 0;

    EXPLAIN events;
    SELECT id,user_id,title,start,end,startTime,name,className,allDay,tz,created,updated FROM  events LIMIT 100,30;


## Contacts table

    DROP TABLE IF EXISTS `contacts`;
    CREATE TABLE `contacts` (
      `mongo_id` varchar(100) NULL,
      `user_id` varchar(100) NOT NULL,
      `contact_id` varchar(100) DEFAULT NULL,
      `phones` varchar(1024) DEFAULT '[]',
      `emails` varchar(1024) DEFAULT '[]',
      `addresses` varchar(1024) DEFAULT '[]',
      `companies` varchar(1024) DEFAULT '[]',
      `websites` varchar(1024) DEFAULT '[]',
      `name` varchar(100) NOT NULL,
      `birthdate` varchar(100) DEFAULT NULL,
      `notes` text DEFAULT NULL,
      `phones_fax` varchar(50) DEFAULT NULL,
      `starred` varchar(10) DEFAULT 0,
      `photo` varchar(100) DEFAULT NULL,
      `read` varchar(100) DEFAULT NULL,
      `last_read` varchar(100) DEFAULT NULL,
      `created` varchar(100) DEFAULT NULL,
      `updated` varchar(100) DEFAULT NULL,
      #CHECK (phones IS NULL OR JSON_VALID(phones)),
      #CHECK (emails IS NULL OR JSON_VALID(emails)),
      #CHECK (addresses IS NULL OR JSON_VALID(addresses)),
      #CHECK (companies IS NULL OR JSON_VALID(companies)),
      #CHECK (websites IS NULL OR JSON_VALID(websites)),
      KEY (`user_id`)
    ) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;

    LOAD DATA LOCAL INFILE '/home/andries/dev/pim2/api/tmp/contacts.csv'
    INTO TABLE `contacts` CHARACTER SET UTF8MB4
    FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY '\\' LINES TERMINATED BY '\n'
    IGNORE 1 LINES ;

    ALTER TABLE contacts ADD id INT PRIMARY KEY AUTO_INCREMENT first;

    UPDATE contacts set mongo_id = SUBSTR(mongo_id,10,24);
    #UPDATE contacts set phones = SUBSTR(phones,3,CHAR_LENGTH(phones)-4);
    #UPDATE contacts set phones = REGEXP_REPLACE(phones,'(\\[|\\ ])','');
    #UPDATE contacts set emails = SUBSTR(emails,3,CHAR_LENGTH(emails)-4);
    #UPDATE contacts set addresses = SUBSTR(addresses,3,CHAR_LENGTH(addresses)-4);
    #UPDATE contacts set companies = SUBSTR(companies,3,CHAR_LENGTH(companies)-4);
    #UPDATE contacts set websites = SUBSTR(websites,3,CHAR_LENGTH(websites)-4);
    UPDATE contacts set companies = '[]' WHERE companies ='';
    UPDATE contacts set birthdate='' where birthdate LIKE '%numberlong%';
    UPDATE contacts set birthdate= NULL where birthdate = '';
    UPDATE contacts set birthdate = REGEXP_REPLACE(birthdate,'T',' ');
    UPDATE contacts set birthdate = REGEXP_REPLACE(birthdate,'.{5}$','');

    UPDATE contacts contacts set created = SUBSTR(created,1,14);
    UPDATE contacts set updated = REGEXP_REPLACE(updated,'T',' ');
    UPDATE contacts set updated = REGEXP_REPLACE(updated,'.{5}$','');
    UPDATE contacts set last_read = REGEXP_REPLACE(last_read,'T',' ');
    UPDATE contacts set last_read = REGEXP_REPLACE(last_read,'.{5}$','');
    UPDATE contacts SET last_read = '2000-01-01 00:00:00' WHERE last_read='';
    UPDATE contacts set starred = 1 WHERE starred = 'true';
    UPDATE contacts set starred = 0 WHERE starred = 'false';
    UPDATE contacts set starred = 0 WHERE starred = '';

    ALTER TABLE contacts ADD CONSTRAINT json_valid_phones CHECK (phones IS NULL OR JSON_VALID(phones));
    ALTER TABLE contacts ADD CONSTRAINT json_valid_emails CHECK (emails IS NULL OR JSON_VALID(emails));
    ALTER TABLE contacts ADD CONSTRAINT json_valid_companies CHECK (companies IS NULL OR JSON_VALID(companies));
    ALTER TABLE contacts ADD CONSTRAINT json_valid_addresses CHECK (addresses IS NULL OR JSON_VALID(addresses));
    ALTER TABLE contacts ADD CONSTRAINT json_valid_websites CHECK (companies IS NULL OR JSON_VALID(websites));

    ALTER TABLE contacts CHANGE created created DATETIME DEFAULT CURRENT_TIMESTAMP;
    ALTER TABLE contacts CHANGE updated updated DATETIME DEFAULT CURRENT_TIMESTAMP;
    ALTER TABLE contacts CHANGE birthdate birthdate DATE;
    ALTER TABLE contacts CHANGE starred starred BOOLEAN DEFAUL 0;

    ALTER TABLE contacts CHANGE `read` times_read varchar(100);
    UPDATE contacts SET times_read = '0' WHERE times_read='' OR times_read IS NULL;
    ALTER TABLE contacts CHANGE times_read times_read int DEFAULT 0;
    ALTER TABLE contacts CHANGE last_read last_read DATETIME;

    UPDATE contacts SET user_id='1' WHERE user_id='54c604baa6dedf6721cf609a';
    UPDATE contacts SET photo=REGEXP_REPLACE(photo,'54c604boaa6dedf6721cf609a','1') WHERE user_id='1';
    UPDATE contacts SET user_id='2' WHERE user_id='56e18dd635f8a31456da8839';
    UPDATE contacts SET photo=REGEXP_REPLACE(photo,'56e18dd635f8a31456da8839','2') WHERE user_id='2';
    UPDATE contacts SET user_id='3' WHERE user_id='568f9f2eac2e8b804105bfaa';
    UPDATE contacts SET photo=REGEXP_REPLACE(photo,'568f9f2eac2e8b804105bfaa','3') WHERE user_id='3';
    UPDATE contacts SET user_id='4' WHERE user_id='54d8f3c4f9759c96034d11fa';
    UPDATE contacts SET photo=REGEXP_REPLACE(photo,'54d8f3c4f9759c96034d11fa','4') WHERE user_id='4';

    DELETE FROM contacts WHERE user_id='5639a7532b989e6626b8e73e';
    ALTER TABLE contacts CHANGE user_id user_id INT NOT NULL DEFAULT 0;

    EXPLAIN contacts;
    #SELECT id,mongo_id,user_id,contact_id,name,created,updated, last_read, times_read from contacts limit 10;
    SELECT id,user_id,contact_id,name,birthdate,phones_fax,starred,photo,times_read,last_read,created,updated FROM contacts LIMIT 400,10;


## Posts table

    DROP TABLE IF EXISTS `posts`;
    CREATE TABLE `posts` (
      `mongo_id` varchar(100) NULL,
      `user_id` varchar(100) NOT NULL,
      `title` varchar(100) NOT NULL,
      `description` varchar(1024) NULL,
      `content` text,
      `type` varchar(255) DEFAULT 'todo',
      `tags` varchar(1024) DEFAULT NULL,
      `lang` varchar(255) DEFAULT NULL,
      `public` varchar(100) DEFAULT NULL,
      `read` varchar(100) DEFAULT NULL,
      `created` varchar(100) DEFAULT NULL,
      `updated` varchar(100) DEFAULT NULL,
      KEY (`user_id`)
    ) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;

    LOAD DATA LOCAL INFILE '/home/andries/dev/pim2/api/tmp/posts.csv'
    INTO TABLE `posts` CHARACTER SET UTF8MB4
    FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY '\\' LINES TERMINATED BY '\n'
    IGNORE 1 LINES ;

    ALTER TABLE posts ADD id INT PRIMARY KEY AUTO_INCREMENT first;

    UPDATE posts set mongo_id = SUBSTR(mongo_id,10,24);
    UPDATE posts set created = SUBSTR(created,1,10);
    UPDATE posts set updated = REGEXP_REPLACE(updated,'T',' ');
    UPDATE posts set updated = REGEXP_REPLACE(updated,'.{5}$','');

    ALTER TABLE posts CHANGE created created DATETIME DEFAULT CURRENT_TIMESTAMP;
    ALTER TABLE posts CHANGE updated updated DATETIME DEFAULT NULL;

    ALTER TABLE posts CHANGE `read` times_read varchar(100);
    UPDATE posts SET times_read = '0' WHERE times_read='' OR times_read IS NULL;
    ALTER TABLE posts CHANGE times_read times_read int DEFAULT 0;
    ALTER TABLE posts ADD last_read DATETIME DEFAULT CURRENT_TIMESTAMP;

    UPDATE posts posts set created = SUBSTR(created,1,14);
    UPDATE posts set updated = REGEXP_REPLACE(updated,'T',' ');
    UPDATE posts set updated = REGEXP_REPLACE(updated,'.{5}$','');

    UPDATE posts SET user_id='1' WHERE user_id='54c604baa6dedf6721cf609a';
    UPDATE posts SET user_id='2' WHERE user_id='56e18dd635f8a31456da8839';
    UPDATE posts SET user_id='3' WHERE user_id='568f9f2eac2e8b804105bfaa';
    DELETE FROM posts WHERE user_id='54d8f3c4f9759c96034d11fa';
    ALTER TABLE posts CHANGE user_id user_id INT NOT NULL DEFAULT 0;

    EXPLAIN posts;
    SELECT id,mongo_id,user_id,title,created,updated, times_read from posts limit 10;

## Postversions

    DROP TABLE IF EXISTS `postversions`;
    CREATE TABLE `postversions` (
      `id` int NOT NULL AUTO_INCREMENT,
      `org_id` int NOT NULL,
      `user_id` int NOT NULL,
      `title` varchar(100) NOT NULL,
      `description` varchar(1024) NULL,
      `content` text,
      `type` varchar(255) DEFAULT NULL,
      `tags` varchar(1024) DEFAULT '[]',
      `created` DATETIME DEFAULT CURRENT_TIMESTAMP,
      KEY (`id`),
      KEY (`org_id`)
    ) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;

## Bookmarks table

    DROP TABLE IF EXISTS `bookmarks`;
    CREATE TABLE `bookmarks` (
      `mongo_id` varchar(100) NULL,
      `user_id` varchar(100) NOT NULL,
      `title` varchar(100) NOT NULL,
      `url` varchar(255) DEFAULT NULL,
      `content` text,
      `category` varchar(1024) DEFAULT NULL,
      `tags` varchar(255) DEFAULT NULL,
      `times_read` int DEFAULT 0,
      `last_read` DATETIME DEFAULT CURRENT_TIMESTAMP,
      `created` DATETIME DEFAULT CURRENT_TIMESTAMP,
      `updated` DATETIME DEFAULT CURRENT_TIMESTAMP,
      KEY (`user_id`)
    ) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;

    LOAD DATA LOCAL INFILE '/home/andries/dev/pim2/api/tmp/bookmarks.csv'
    INTO TABLE `bookmarks` CHARACTER SET UTF8MB4
    FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY '\\' LINES TERMINATED BY '\n'
    IGNORE 1 LINES ;

    ALTER TABLE bookmarks ADD id INT PRIMARY KEY AUTO_INCREMENT first;

    UPDATE bookmarks set mongo_id = SUBSTR(mongo_id,10,24);
    UPDATE bookmarks set created = SUBSTR(created,1,10);
    UPDATE bookmarks set updated = REGEXP_REPLACE(updated,'T',' ');
    UPDATE bookmarks set updated = REGEXP_REPLACE(updated,'.{5}$','');

    ALTER TABLE bookmarks CHANGE created created DATETIME DEFAULT CURRENT_TIMESTAMP;
    ALTER TABLE bookmarks CHANGE updated updated DATETIME ON UPDATE CURRENT_TIMESTAMP;

    UPDATE bookmarks SET user_id='1' WHERE user_id='54c604baa6dedf6721cf609a';
    UPDATE bookmarks SET user_id='2' WHERE user_id='56e18dd635f8a31456da8839';
    UPDATE bookmarks SET user_id='3' WHERE user_id='568f9f2eac2e8b804105bfaa';
    ALTER TABLE bookmarks CHANGE user_id user_id INT NOT NULL DEFAULT 0;

    EXPLAIN bookmarks;
    SELECT id,mongo_id,user_id,title,created,updated from bookmarks limit 10;




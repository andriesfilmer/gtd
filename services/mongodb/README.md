## First configuration on production

*Turn on/off security.  Off is currently the default*

    auth = true

*Disable the HTTP interface (Defaults to port 28017)*

    nohttpinterface = true


## Add authentication

While out of the box, MongoDb has no authentication, you can create the equivalent of a root/superuser
from mysql by using the "any" roles to a specific user to the admin database.

    db.createUser( { user: "root", pwd: "<password>", roles: [ "root","backup","restore"] } )
    db.createUser( { user: "<username>", pwd: "<password>", roles: [ "readWrite","dbAdmin"] } )

For `mongodump` and `mongorestore` .mongorc.js does not work! So you need the password on the commandline.

    db.grantRolesToUser("<someuser>", [ { role: "read", db: "<somedb>" },{ role: "write", db: "<somedb>" }])
    db.revokeRolesFromUser("<someuser>", [ { role: "<somerole>", db: "<somedb>" }])

## mongorc.js

    db = connect("<hostname>:<port>/<database name>");
    db.getSiblingDB("admin").auth("root", "<password>");

## Tips for mongo shell

Find with nice output.

    db.collection.find().pretty()

Delete database

    use someDbName;
    db.dropDatabase();

Delete a collection.

    db.<collectionName>.drop();

## Find, Insert and Update examples

    db.collection.find({_id: ObjectId("54ef5696448bd5e1efc49578")}).pretty()
    db.collection.find({ $query: {}, $orderby: { created : -1 } }).pretty()
    db.collection.find({user_id: { $in : ["54c4dee99c87fffa24dcdda90"]}})
    db.collection.find({},{title:1}).pretty() // Return only title field (_id is mandatory)

    db.collection.insert( { id: "57", title: "Be happy" } )

    db.collection.update({},{$set: {user_id: '543d15898b3e81a448ef2875'}}, {multi: true})
    db.collection.update({'className':'Afspraak'},{$set:{'className':'appointment'}},{multi: true})
    db.collection.update({ _id: ObjectId("54b1056612813c7367dd3c2b") }, { $unset : { end: 1} });

    db.collection.find().forEach(function(event) { event.start=new Date(event.start); db.collection.save(event); })

    db.events.aggregate({ $group : {_id : "$status", total : { $sum : 1 } } }); // Group by 'status' with totals.

## mysql2json
If you need to migrate from mysql to mongodb use Gem bundle.

    gem install mysql2xxxx

Export mysql:

    mysql2json -u username -p -d andries -h mariadb.filmer.nl --execute="select * from db" > db.json

Import json:

    mongoimport -c posts -d someDbName --file db.json --type json  --jsonArray

### Example converting calendar events
    # mongo
    > use pim
    > db.events.drop()
    > exit
    # mysql2json -u andries -p -d andries -h localhost --execute="select subject as title, concat(startDate,' ', startTime) as start,\
         concat(endDate,' ', endTime) as end, description, status, created, updated, type as className,\
         actions_id, startTime, naw_id, name, bound from actions" > events.json
    # mongoimport -u pim -p mongopassword -c events -d pim --file events.json --type json  --jsonArray
    # mongo
    > db.events.update({},{$set: {user_id: '343d12898b3e81a448rf2625'}}, {multi: true})
    > db.events.update({},{$set: {allDay: false}}, {multi: true})
    > db.events.find().forEach(function(event) { event.start=new Date(event.start); db.events.save(event); })
    > db.events.find().forEach(function(event) { event.end=new Date(event.end); db.events.save(event); })
    > db.events.find().forEach(function(event) { event.created=new Date(event.created); db.events.save(event); })
    > db.events.find().forEach(function(event) { event.updated=new Date(event.updated); db.events.save(event); })
    > db.events.find({ $query: {startTime: '00:00:00'}}).forEach(function(event) { event.allDay=true; db.events.save(event); })

## mongodump
Create a `dump` directorie in the current directorie.

    mongodump -c posts -d someDbName -u someUser -p <password>

## mongorestore
`mongodump` creates a directorie `dump` which we can use to restore.

    mongorestore dump --drop

> `--drop` option overwrites the collections!

## Resources

* [Tutorialspoint MongoDB](http://www.tutorialspoint.com/mongodb/)
* [Strongloop](http://strongloop.com/strongblog/node-js-api-offline-sync-replication/)
* [Loopback](http://loopback.io/)
* [Sync CouchDb with PounchDb](http://pouchdb.com)
* [BreezeJs](http://www.getbreezenow.com/)
* [JayData](http://jaydata.org/)
* [Twitter clone example with Breeze](https://github.com/dai-shi/social-cms-backend)
* [MongoErrors middleware](https://github.com/jhenriquez/mongoose-mongodb-errors)

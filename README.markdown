Why another document database?
==============================

To be honest, because I can. I wanted to improve my programming skills in several different aspects and a database seems like a *REALLY* good opportunity in doing so.

Creating a database requires learning more about HTTP (the db is RESTful), Security, Performance, data structure algorithms and of course the languages involved (Ruby for the DB, Python for the first client).

Delorean is a message-driven document database from the future. Let's explain this one bit at a time.

Message-Driven?
===============

Delorean is message-driven in the way it persists the data you send its way. Instead of storing the actual information you sent, Delorean stores the message you sent. This way it can replay all actions all users every did.

Why in god's name would I want that? Because this way we can return to any given point in time. Say you want the database restored to exactly 18:00 of yesterday. This is REALLY simple with Delorean. Just ask the database to process messages up to that time (this feature is not yet implemented, but the messaging infrastructure is).

This also means that your data is always in-memory. This has benefits and drawbacks. The obvious drawback is that storing all the data in memory might not be viable in *MANY* scenarios. The major benefit is speed. Since all the data is in-memory and indexed, it's really fast to perform any operations on it (again subject to size of data).

Document Database
=================

Delorean only supports JSON documents. Even though the client libraries probably abstract the JSON portion (transforming it to dictionaries, hashes, objects or something else), that's what Delorean stores.

The point here is that Delorean uses the JSON Format for storing documents.

From the future?
================

Delorean comes from the future (hence the [name](http://pt.wikipedia.org/wiki/Ficheiro:Back_to_the_future_timemachine.JPG)) because it enables users to restore it to a given point in time.

This enables scenarios that were harder, like "rolling back" the database after a code roll-back. You deployed your application, did a bunch of operations in the database and things went wrong.

So you want to got back in time to the second before the deploy. The code part is easy, just deploy the previous tag (you are tagging, right?). The database part is harder, but not with Delorean. Just restart the database specifying that the latest message to process should have date lesser than 1 second before the deployment took place. Just ask Delorean to go to the past.

Installing and Using
====================

TBW

Database clients
================

I'll try to get smart people to help me doing clients for the database in several different languages. For now we feature:

* Python - [Mcfly](http://github.com/heynemann/mcfly)

Roadmap
=======

* Supporting views - Views are materialized joins of documents
* Querying
* Tighter Authentication
* Sharding

Feedback
========

If you want to give feedback, suggestions or ask for features, just us github issues for it.

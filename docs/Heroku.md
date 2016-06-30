# Heroku

## What is it?

Heroku is a Platform-as-a-Service provider for web applications.  In contrast to something like Digital Ocean which gives you an Ubuntu VM and relies on you to configure everything (eg: Install & Setup Rails, PostgreSQL, Apache or Nginx, a deployment system, etc) - Heroku wraps all that up.

Heroku acts as a Git remote that the web application is pushed to.  After being pushed, Heroku instantiates the web application on a Ruby "slug".  A slug is a low storage capacity (300 MB) VM with limited life.  In other words, a user is not guaranteed to get the same VM between requests.  This enforces good development practices such as not storing any session information on the server itself, or using the local filesystem for anything other than temp files during the scope of a single request.

By conforming to these requirements, applications can scale up easily.  Additional VMs can be allocated to the web application, and users can be routed to any VM without worrying about the load balancing algorithm since it is irrelevant which VM a web request goes to.

## Setup

If you haven't been granted access to our Heroku application, ask someone else on the team to grant you access.

After access is granted, you will need to install the Heroku toolbelt.  This is a collection of command line utilities which let you interact with Heroku to do things like viewing logs.

To install the Heroku toolbelt, go to https://devcenter.heroku.com/articles/getting-started-with-ruby#set-up and follow the instructions.  IE: run ```heroku login```

## Creating a new remote

You need to add Heroku as a remote to your existing clone of our Git repo.

```
heroku git:remote -a canvasnewton
```

You can get more information from this article, but the above commands should be enough to get you started: https://devcenter.heroku.com/articles/git

## Viewing logs

When you go to http://www.audicy.us, the log file on the server will be updated.  This is similar to when you run ```rails server``` locally and you see the various database operations, printfs, etc.

To view Heroku logs, you should run

```
heroku logs --tail
```

This will display realtime logs of what's happening on the server.  This will help debug any issues in production.

While you cannot do realtime debugging via byebug in production, you can freely print variables to the log.  This would require a new deployment which is fine before we release.

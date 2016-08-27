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

## Using Staging

Typically, you will push new versions of the title to staging.  This is a private instance of the application that's running on Heroku.  So we can test the application running in the Ruby production environment, and using PostgreSQL on Heroku - without having to change what external users are seeing.

Once you have followed the steps above, there are some additional steps you'll need to take to take to get setup.

### Creating a new Git remote
To push to production, you use something like ```git push heroku master```, where in this command, ```heroku``` refers to the git remote you are pushing the code to.

For staging, you will be pushing to a new remote, so you need to add this.  You do that with the following command:

```
git remote add staging https://git.heroku.com/audicystaging.git
```

### Pushing to staging
You can push any branch you want to staging.  It could be master, the staging branch, or your personal development branch.  To push master, you would use the following command:

```
git push staging master
```

If you want to push your own branch to staging, you would use the following command:

```
git push staging <branchname>:master
```

Where ```<branchname>``` is the branch you want to push.

### Heroku commands on staging
Above, we discussed how to add the new git remote.  But to run Heroku commands such as ```heroku logs``` or ```heroku run rake db:migrate```, you need to be able to specify which environment (production or staging) you are running the command on.

You will need to specify the environment when running any heroku commands now.  Eg:

```
heroku logs --app audicystaging --tail
```

You would not have had to specify ```--app``` previously

If you wish, you can specify a default environment (production or staging) using something like:

```
git config heroku.remote staging
```

This would set staging as the default environment to use.

## Using the proper branch for deployment

Typically you would work your working branch to the staging environment.  So if there was a branch called ```rishi-coolfeature```.  My development process would be:

1. Develop in this branch.
2. Verify that tests pass.
3. Push to staging using ```git push staging rishi-coolfeature:master```
4. Check your changes at https://audicystaging.herokuapp.com/
5. If everything works, send out pull request
6. If pull request is approved, merge into master

So this is no different than the usual development process.  But you need to push to the production environment for users to see the changes.

### Step 6 - Decide on a deployment branch, or create a new one
Decide which branch corresponds to the current release of the product.  This would be something like ```FriendsFamily-1.0```, etc.  The current branch will be the latest version number of the current milestone.

If appropriate, create a new branch, eg: ```git checkout -b FriendsFamily-1.1```.  Typically this would be either either branched from master, or the previous version of the current milestone's branch (eg: ```FriendsFamily-1.0```)

You can ```merge``` your changes into this branch, ```rebase```, or ```cherry-pick```, it depends what's appropriate for your situation.


### Step 7 - Test the deployment branch offline
Once the branch is ready, you are now ready to test it.

First verify that the automated tests work, ie: ```rake test```

### Step 8 - Test the deployment branch on staging in the Heroku environment
Then upgrade to staging, using ```git push staging FriendsFamily-1.0:master``` and verify that whatever new features have been added, work correctly.

### Step 9 - Deploy to production
Finally, you can deploy to production.  There's no special thing that needs to be done, just deploy using the special command.

```git push heroku FriendsFamily-1.0:master```

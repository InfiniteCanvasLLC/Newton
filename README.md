# Newton
## The social music recommendation system

If you can see this, you have been invited to this private repo.  Please do not invite anyone else to this repo without checking with the team first.  While every effort has been made to keep sensitive information out of the codebase, there is still the potential for API secrets and so forth, to exist in old commits.

### Installation
You must first install Rails.  Follow the instructions at [http://installrails.com/](http://installrails.com/) to install a local copy

### Get the source
Clone this repo.  And then run ```bundle install --without production``` to install the Ruby Gems (libraries) and the various dependencies.

### Setup environment variables
You need to specify the Facebook App ID and Secret, the app pulls these from environment variables.  You can either set these in your bash_profile ($open ~/.bash_profile), or use [Figaro](https://github.com/laserlemon/figaro).

If you want to use Figaro, run ```bundle exec figaro install```, this will create a ```config/application.yml``` file and you can put the environment variables in there.  This command automatically adds application.yml to your Git ignores, the whole point is to avoid checking in sensitive data to version control after all!

The environment variables you need to define are ```FACEBOOK_KEY``` and ```FACEBOOK_SECRET```, these are used in ```config/initializers/omniauth.rb```

**NOTE:** These only apply when running in development mode.  In production mode, the environment variables are pulled from the Heroku configuration.

### Setting up Spotify Support

#### Call Gene if any issues come up, or if you need SPOTIFY_ID/SECRET
1. Define environment variables inside bash profile: SPOTIFY_ID and SPOTIFY_SECRET
2. Create a LinkTo for Spotify Login
 1. Goto http://localhost:3000/link_tos
 2. Create new link to:
      Title: Spotify Login, Description: Log into Spotify, URL: /auth/spotify, Icon Style: fa-spotify, Panel Style: panel-green
3. Create a Action that references the new LinkTo
   a) Goto http://localhost:3000/user_actions/new
   b) Assign action to yourself, and set action type to 1 (1 is a LinkTo)

### Setting up the Mailer
Same as for the env variables for Facebook and Spotify. You need to export GMAIL_USERNAME and GMAIL_PASSWORD. You should have received an email with the current (temporary) Gmail account info.

### Setup your local database
You need to create the appropriate database tables in your local copy of the Newton app.  Run the following campaign:

```bundle exec rake db:migrate```

### Run the web server
If you want to develop locally (recommended), you should use the built in web server provided with Rails.  In the root directory of the app, simply run ```rails server``` and then connect to it from your web browser by navigating to ```localhost:3000```

### Production environment
Please the [Heroku](docs/Heroku.md) article for information on how the Producton (and Staging) environments work

### Other Setup
You will need to make yourself an administrator if you want to use the administrator page, and perform actions like create new questions, view user feedback, etc.  To that, see the [docs/Administrator](docs/Administrator.md) article

### Questions

See the [Questions](docs/Questions.md) article

### Link Tos

See the [LinkTos](docs/LinkTos.md) article

### Actions

See the [Actions](docs/Actions.md) article

### Parties

See the [Parties](docs/Parties.md) article

### Events

See the [Events](docs/Events.md) article

### Testing

Before you send a pull request and/or merge to master.  Please run the automated test suite to verify that all tests pass.

See the [Testing](docs/Testing.md) article for more details.

### Updating your database

When you do do a git pull and get a new database migration file that modifies the database schema, you will need to do a ```rake db:migrate``` to update your local database.  Otherwise you will likely get runtime errors when using the website.

#### Debugging your database

Throughout the course of development, viewing and editing the database directly can prove to be helpful for debugging.

See [Database Debugging](docs/DatabaseDebugging.md) for some more info

### Custom Rake Tasks

We have a few rake tasks for various housekeeping tasks.  These can be found in ```lib/tasks```

To run a rake task on Heroku to update the production database, the syntax is very similar.  You would do ```heroku run rake foo``` instead of ```rake foo```

** Be extremely careful before updating production after we release.  The database would need to be backed up before we run a rake task that updates the database **

#### Adding some basic linktos needed by the system

Anytime we drop a database, or update it in some way that deletes linktos, we need to re-generate those linktos that the service needes
to communicate to the user.

*Syntax*
```
rake populate_db:create_linktos
```

#### Fixing party owners in the database

It is possible for parties to have no owner, if the party was created some time ago.  Similarly if a user is deleted, the party can have an invalid owner.  This rake task will assign a valid owner to those parties.

*Syntax*
```
rake db_fix:assign_party_owners <user_id>
```

*user_id:* The user id of a user that should be made the owner of any parties that have a nil party owner.  Will also be made the owner of any parties with an invalid party owner (eg: a deleted or non-existent user)

#### Delete stale user actions

This task will delete user actions that are not assigned to a valid user (typically a deleted user).

*Syntax*
```
rake db_fix:clean_user_actions
```

### Accounts
The following are the accounts create for support of the Newton service:
- Facebook app (credentials and basic user info) --> Rishi
- Spotify app (music info) --> Gene
- Gmails (customer outreach) --> Serge

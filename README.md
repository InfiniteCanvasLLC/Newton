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

#### Automated Tests
Before you send a pull request and/or merge to master.  Please run the automated test suite to verify that all tests pass.

See the [Testing](docs/Testing.md) article for more details.

#### Test Mail
There could be some cases, where you need to test mailing a party for example.  But when testing locally, you will only have your own personal Facebook account, along with the test accounts.  Usually Facebook test accounts have crazy addresses like "fb_324263253245@fbtest.com" or something that don't correspond to an e-mail address you'll have access to.

So if you wanted to try e-mailing a test user, you have no way of knowing if the e-mail was sent or what the situation is, unless you manually add one of your own e-mail addresses to the Facebook test account.  That can be pretty annoying.

You can use https://mailcatcher.me/ instead.  This sets up a temporary mail server on your own machine, and monitors outgoing e-mails - so you can see what would be delivered in production.

To set up mailcatcher, first trying following the steps listed on the website above.  If they don't work, and you get an error saying 'method_missing'... then you're running into a mailcatcher bug and can work around it via the following.

```gem pristine --all``` try this first to see if it corrects your error.  This will cleanup your installed gems.

If that doesn't work, do these steps:

```
gem uninstall mailcatcher

rvm default@mailcatcher --create do gem install mailcatcher
rvm wrapper default@mailcatcher --no-prefix mailcatcher catchmail

mailcatcher
```

More info on this thread: https://github.com/sj26/mailcatcher/issues/267

After you have installed and started mailcatcher, you will need to modify the SMTP server in your development.rb file to not use Gmail, but to use your local server.  So change your outgoing SMTP address to 127.0.0.1 and port to 1025.  Eg:

```rb
config.action_mailer.smtp_settings = {
  address: "127.0.0.1",
  port: 1025,
  domain: "audicy.us",
  authentification: "plain",
  enable_starttls_auto: true,
}
```


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

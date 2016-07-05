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
The production version of the app is hosted at [http://canvasnewton.herokuapp.com](http://canvasnewton.herokuapp.com).  Heroku is a Platform-as-a-Service (PaaS) offering which makes it *very easy* to deploy and host dynamic web apps.  The appropriate git remote is added for Heroku (origin is GitHub).  Then you simply push to the Heroku, and Heroku automatically configures Rails, the gems, assets, database, etc.

If you want to deploy to Heroku, that is certainly fine.  Please ask Rishi to add you as a collaborator to the account.

For more information on Heroku, please go to the [Heroku](docs/Heroku.md) article

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

Before you send out a pull request, please make sure that all tests pass.  If there are any errors, then please fix them or ask for help.

#### Setting up test environment
You need a Facebook user to run some of the tests.  You can either use your personal Facebook account or create a test user at https://developers.facebook.com/apps/1687121291541543/roles/test-users/

Please do not re-use an existing one, since another developer might be using those.  Create a new one, and set the password to whatever you want.

Once that's done, add two new environment variables:
1. ```FB_TESTUSER_USERNAME``` should be the e-mail address for your Facebook Test account
2. ```FB_TESTUSER_PASSWORD``` should be the password for that account

#### Running tests
Within your project directory, run ```rake test```.  This will run all tests.  If the tests complete successfully, you'll see something like:


```
Run options: --seed 48477

# Running:

......................................

Finished in 2.484632s, 15.2940 runs/s, 28.5757 assertions/s.

38 runs, 71 assertions, 0 failures, 0 errors, 0 skips
```


### Updating your database

When you do do a git pull and get a new database migration file that modifies the database schema, you will need to do a ```rake db:migrate``` to update your local database.  Otherwise you will likely get runtime errors when using the website.

#### Debugging your database

You can download a database browser from http://sqlitebrowser.org/ and view your db/development.sqlite3 file.

You can also take a look at the state of your database by opening the rails console and issuing commands.  Eg:

```
rails console

2.2.1 :001 > user = User.find(1)
  User Load (0.4ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = ? LIMIT 1  [["id", 1]]
 => #<User id: 1, provider: "facebook", uid: "10154129229729939", name: "Rishi Gupta", email: "rishig@mac.com", created_at: "2016-04-18 05:07:17", updated_at: "2016-04-18 05:07:17">

2.2.1 :012 > UserAction.where("user_id=2")
  UserAction Load (1.6ms)  SELECT "user_actions".* FROM "user_actions" WHERE (user_id=2)
 => #<ActiveRecord::Relation [#<UserAction id: 13, user_id: 2, action_type: 0, action_id: 3, created_at: "2016-05-07 08:57:59", updated_at: "2016-05-07 08:57:59">]>

2.2.1 :014 > pp Question.all
  Question Load (0.3ms)  SELECT "questions".* FROM "questions"
[#<Question:0x007f80f4386f18
  id: 1,
  text: "Do you listen to vinyl?",
  question_type: 1,
  metadata_one: "",
  metadata_two: "",
  metadata_three: "",
  metadata_four: "",
  created_at: Mon, 18 Apr 2016 06:56:29 UTC +00:00,
  updated_at: Sun, 24 Apr 2016 09:16:50 UTC +00:00>,
 #<Question:0x007f80f4386d88
  id: 2,
  text: "What is your favorite ice cream flavor?",
  question_type: 0,
  metadata_one: "Salted Caramel",
  metadata_two: "Pistachio",
  metadata_three: "Mango",
  metadata_four: "Malted Chocolate",
  created_at: Mon, 18 Apr 2016 06:58:41 UTC +00:00,
  updated_at: Mon, 18 Apr 2016 06:58:41 UTC +00:00>,
 #<Question:0x007f80f4386ba8
  id: 3,
  text: "Rate Lady Gaga's previous album",
  question_type: 2,
  metadata_one: "",
  metadata_two: "",
  metadata_three: "",
  metadata_four: "",
  created_at: Sun, 24 Apr 2016 08:16:07 UTC +00:00,
  updated_at: Sun, 24 Apr 2016 09:17:45 UTC +00:00>,
 #<Question:0x007f80f4386a40
  id: 4,
  text: "What is your favorite TV show?",
  question_type: 0,
  metadata_one: "Family Guy",
  metadata_two: "American Dad",
  metadata_three: "Simpsons",
  metadata_four: "South Park",
  created_at: Fri, 06 May 2016 09:48:37 UTC +00:00,
  updated_at: Fri, 06 May 2016 09:48:37 UTC +00:00>,
 #<Question:0x007f80f4386838
  id: 5,
  text: "How much does the Weeknd suck?",
  question_type: 0,
  metadata_one: "A lot",
  metadata_two: "A massive amount",
  metadata_three: "A planet sized amount",
  metadata_four: "More than Windows 3.1",
  created_at: Sat, 07 May 2016 06:49:44 UTC +00:00,
  updated_at: Sat, 07 May 2016 06:49:44 UTC +00:00>]
 => #<ActiveRecord::Relation [#<Question id: 1, text: "Do you listen to vinyl?", question_type: 1, metadata_one: "", metadata_two: "", metadata_three: "", metadata_four: "", created_at: "2016-04-18 06:56:29", updated_at: "2016-04-24 09:16:50">, #<Question id: 2, text: "What is your favorite ice cream flavor?", question_type: 0, metadata_one: "Salted Caramel", metadata_two: "Pistachio", metadata_three: "Mango", metadata_four: "Malted Chocolate", created_at: "2016-04-18 06:58:41", updated_at: "2016-04-18 06:58:41">, #<Question id: 3, text: "Rate Lady Gaga's previous album", question_type: 2, metadata_one: "", metadata_two: "", metadata_three: "", metadata_four: "", created_at: "2016-04-24 08:16:07", updated_at: "2016-04-24 09:17:45">, #<Question id: 4, text: "What is your favorite TV show?", question_type: 0, metadata_one: "Family Guy", metadata_two: "American Dad", metadata_three: "Simpsons", metadata_four: "South Park", created_at: "2016-05-06 09:48:37", updated_at: "2016-05-06 09:48:37">, #<Question id: 5, text: "How much does the Weeknd suck?", question_type: 0, metadata_one: "A lot", metadata_two: "A massive amount", metadata_three: "A planet sized amount", metadata_four: "More than Windows 3.1", created_at: "2016-05-07 06:49:44", updated_at: "2016-05-07 06:49:44">]>
2.2.1 :015 >


```

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

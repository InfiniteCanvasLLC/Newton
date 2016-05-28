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

### Setup your local database
You need to create the appropriate database tables in your local copy of the Newton app.  Run the following campaign:

```bundle exec rake db:migrate```

### Run the web server
If you want to develop locally (recommended), you should use the built in web server provided with Rails.  In the root directory of the app, simply run ```rails server``` and then connect to it from your web browser by navigating to ```localhost:3000```

### Production environment
The production version of the app is hosted at [http://canvasnewton.herokuapp.com](http://canvasnewton.herokuapp.com).  Heroku is a Platform-as-a-Service (PaaS) offering which makes it *very easy* to deploy and host dynamic web apps.  The appropriate git remote is added for Heroku (origin is GitHub).  Then you simply push to the Heroku, and Heroku automatically configures Rails, the gems, assets, database, etc.

If you want to deploy to Heroku, that is certainly fine.  Please ask Rishi to add you as a collaborator to the account.

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


### Conclusion
This is still very early in development, please ask questions on the #newton channel on Slack.

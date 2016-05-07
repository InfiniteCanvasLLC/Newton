# Newton
## The social music recommendation system

If you can see this, you have been invited to this private repo.  Please do not invite anyone else to this repo without checking with the team first.  While every effort has been made to keep sensitive information out of the codebase, there is still the potential for API secrets and so forth, to exist in old commits.

### Installation
You must first install Rails.  Follow the instructions at [http://installrails.com/](http://installrails.com/) to install a local copy

### Get the source
Clone this repo.  And then run ```bundle install --without production``` to install the Ruby Gems (libraries) and the various dependencies.

### Setup environment variables
You need to specify the Facebook App ID and Secret, the app pulls these from environment variables.  You can either set these in your bash_profile, or use [Figaro](https://github.com/laserlemon/figaro).

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

### Actions

See the [Actions](docs/Actions.md) article

### Parties

See the [Parties](docs/Parties.md) article


You can also take a look at the state of your database by doing

```
rails console

> Question.all
```


### Conclusion
This is still very early in development, there isn't much to say.  Please ask on the #newton channel with any questions or concerns.

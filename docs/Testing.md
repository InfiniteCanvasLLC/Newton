# Testing

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

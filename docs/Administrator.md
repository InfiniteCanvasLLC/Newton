# Administrator Privileges

Users have a permissions field.  Currently the only valid values are

| Permission | Description |
|------------|-------------|
| 0          | A regular user who signs up for the site.  No ability to view parties they are not a member of, create new questions, etc |
| 1          | Super user.  Can view all users, feedback, create new questions, edit and delete any construct.  Etc |

The rest of this article will describe how to make a user in the database, an administrator.  You can also remove all privileges of an administrator.

**Note: You need to login with Facebook at least once before doing this**

#### 1. Find your User ID
You can do the following to list all users and find the ID that corresponds to you.

First enter the rails console
```
rails console
```

Then list all users
```
pp User.all
```

Find the user corresponding to the one you want to make an administrator, and note the ID.  In this example, it would be "5".


```
2.2.1 :001 > pp User.all
  User Load (1.4ms)  SELECT "users".* FROM "users"
[#<User:0x007fc3d53002c8
  id: 5,
  provider: "facebook",
  uid: "10154129229729939",
  name: "Rishi Gupta",
...

```

#### 2. Run the rake task to make that user the administrator

```
rake fix_db:set_admin 5
```

Where the last argument is the user id to make an administrator

You can also go in the opposite direction and make a user a regular user and remove their administrator privileges

```
rake fix_db:set_nonadmin 5
```

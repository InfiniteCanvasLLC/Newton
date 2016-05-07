# Parties

A party contains many users.  A user can also belong to many parties.  This is called a "Has and Belong To Many" relationship (HABTM) and is slightly more complex in any database system.  The pieces are:

1. A Users table which stores the list of users as well as their attributes.  But no information about party membership is in this table since a user can be part of infinite parties.
2. A Parties table which stores the list of parties as well as their attributes.  But no information about user membership is in this table since a party can contain infinite users.
3. A User_Parties table which is called a join table.  This stores association between a user and parties.  Using this table, all parties that a user is part of can be obtained.  All users that a party contains can also be contained.

### Schema

#### PartiesUsers table

| Column Name | Description |
|-------------|-------------|
| id          | Unique identifier of this Party_User pair |
| user_id     | The user id of this association |
| party_id    | The party id of this association |

So a record containing

| user_id | party_id |
|---------|----------|
| 7       | 3        |

This means that the user with id=7 is a member of the party with id=3

So one can find all members of the party with id=3 by finding all members of this table where party_id=3.  Or conversely one can find the parties the user with id=7 is part of, by finding all members of this table where user_id=7.

#### Joining parties

Right now it is only possible for an administrator (which for now is everyone) to assign a user to a party.  This is done by going to (http://localhost:3000/users) and editing a particular user.

You can also go to http://localhost:3000/administrator

From that page, groups can be joined or left as desired.

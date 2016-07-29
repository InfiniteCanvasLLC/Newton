# Database Debugging

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

# Questions

Questions are stored in the ```Questions``` table.  The corresponding model is question.rb, and corresponding controller is questions_controller.rb - as per the standard Rails conventions.

The ```Questions``` table is global, these are all the questions in the system, they are not necessary assigned to anyone.

To assign a question to someone, an ```Action``` referring to the given ```Question``` must be assigned to the user.  See the [Actions](Actions.md) article for more detail.

### Schema

The Questions table has the following structure

| Column Name | Description |
| -------------- | ----------- |
| id   | Unique identifier of the question |
| text | The text shown to the user in the question |
| question_type | An enumeration corresponding to question type.  The enumeration is not presently defined anywhere is is implicit.  Values are: <ul><li>0 - Multiple Choice <li>1 - Yes / No, <li>2 - Rating, <li>3 - Text (where the user types in a response)</ul>
| metadata_one, metadata_two, metadata_three, metadata_four | Anything associated with the question, depends on the question type.  The intent is that these would represent answers for the multiple choice questions

The routes are the usual Rails routes for CRUD operations.  The following are the relevant URLs

| Command | URL | Operation |
|-----|-----------|-----|
| GET | http://localhost:3000/questions | List all questions |
| GET | http://localhost:3000/questions/new | Form for creating a new question |
| POST | http://localhost:3000/questions | Create a new question |
| GET | http://localhost:3000/questions/:id | Display a given question |
| GET | http://localhost:3000/questions/:id/edit | Edit a question |
| PUT | http://localhost:3000/questions/:id | Update a question |
| DELETE | http://localhost:3000/questions/:id | Delete a question |

The only URL you really have to visit is http://localhost:3000/questions to administer questions.  You can also go to http://localhost:3000/administrator

Any questions or CRUD operations you've performed should reflect in your database.

# Answers

When a user answers a question, those are stored in the ```QuestionAnswers``` table.

### Schema

The table has the following structure

| Column Name | Description |
|-------------|-------------|
| id          | Unique identifier of the answer |
| question_id | The ID of the question that this answer corresponds to |
| user_id     | The ID of the user who answered this question |
| answer_integer | The integer value of the answer.  This could be nil if the answer is a text based one |
| answer_text | The text value of the answer.  This could be nil if the answer is a numerical one |

#### Examples

1. To find all answers from user_id=7, filter the table where user_id=7
2. To find all answers for question_id=3, filter the table where question_id=3

### Input Form

There are a few pieces that get the input form working:

#### Question container

The questions are contained within a ```<div>``` with ```id = question_{action_id}```

**Important** - action_id is not the same as question_id.  The ```UserActions``` table stores all actions that are assigned to users.  The action_id is the ID of the action assigned to this user.  So if the Question with ID=2 is assigned to the user with ID=4, there would be an entry in the ```UserActions``` table with

| ID | User ID | Action Type | Action ID |
|----|---------|-------------|-----------|
| 714| 4       | 0           | 2         |

So in this case, the div would have ```id=question_714```.  This doesn't mean question 714, this means action 714.

The reason we do this, is so that once the user answers a question, we can find the question on the page to hide.  We don't hide the question immediately, we wait for a response of success from the server before hiding the question - so from the JavaScript we have no way of knowing which element to hide without some way to identify it.

#### Form

This is what captures the user input.  This sends a POST request to the ```enter_answer``` action in the NewAccountController.  A POST route has been added to ```routes.rb``` to expose this.  We are setting ```remote: true``` in the form, which tells Rails to submit this form via Ajax.

The form itself has an attribute called ```action_id```, this is set to the same value as the outer div.  So in the above example, this would be ```action_id=714```.  The reason this is done is so we can get the action_id from the JavaScript Ajax response handler.

This value is also passed as a hidden form value, so that the ```enter_answer``` method can access this to create the full ```QuestionAnswer``` record.  We need the ```action_id``` so we can remove the UserAction from the user, as well as figure out which Question this UserAction corresponds to.

#### Ajax Response handler

The ```ajax:success``` event is sent by Rails after a successful response via an Ajax form.  We listen for this event at the bottom, and once received, we hide the question.  This eliminates the need for the user to have to reload the page.  Although if they choose to reload, there will be no change.

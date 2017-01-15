# Entry Quiz
By going to the /entry_quiz route, it's possible to have the user complete a short quiz.  Upon completing the quiz, the user is prompted to sign-in via Facebook.  Once sign-in is completed the user is given a hardcoded recommendation based on their quiz answeres.

## How it works
1. The quiz is entirely defined in the front-end in `entry_quiz.js`.  It's implemented using [knockoutjs.com](http://knockoutjs.com/)
2. Once the quiz is completed, a result is stored in the session.  We do this by calling an endpoint defined in Rails.  Nothing is actually stored on the server, we just rely on the response telling us to set the session.
3. Once the user signs in, we check for the presence of quiz results in the session.  If present, generate a hardcoded recommendation.
4. The hardcoded recommendations are stored in the quiz_recommendations table, this is populated through the rake task `create_quiz_recommendations`

## Setup
To setup the Rails app to use the entry quiz, all that is required is

1. `rake db:migrate` to generate the quiz_recommendations table
2. `rake populate_db:create_quiz_recommendations` to create the records in this table

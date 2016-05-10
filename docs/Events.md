# Events

Events are stored in the ```Events``` table.  The corresponding model is event.rb, and corresponding controller is event_controller.rb - as per the standard Rails conventions.

The ```Events``` table is global, these are all the events in the system, they are not necessary assigned to any party.

### Schema

The Events table has the following structure

| Column Name | Description |
| -------------- | ----------- |
| description   | A description visible to the user of what the event is about |
| event_type | The type of event (concert, rave, etc...) |
| start | UTF datetime object for when the event takes place |
| metadata | Anything that might be relevant to the event|

The routes are the usual Rails routes for CRUD operations.  The following are the relevant URLs

| Command | URL | Operation |
|-----|-----------|-----|
| GET | http://localhost:3000/events | List and manage all events |

You can also go to http://localhost:3000/administrator

###Note

The flow is as follows:
    - Admin manually create a event in the database.
    - After **careful** consideration Admins (later the recommendation engine) establish that party X might be interested.
    - An action item is submitted to each user in party X regarding the event
        - The action will probably contain information about the event.
        - The action MIGHT contain links to performances, articles, about the artist and a ticket system for
        purchase.
        ('MIGHT' because, part of the preliminary recomandation work is establishing which artist/event the party might
        be intereted. This involves sending links to Youtube performances, Spotify playlists, Facebook posts, Tweets,
        etc... in order to gauge interest).
    - The admin then assigns the event to the party (although all members might not be inclined to attend).
    - All users when under party X will see the event in their calendar

Note:
    We haven't exactly established the flow for recomandation acceptence or rejection for the user. But a temporary idea might be to
    decorate the event in the calendar a certain way (different color) based on whether the user is going. Having the event linger there
    is a constent reminder to each user that their party should go to that event. For psychological reasons it might be important to keep it
    in the calendar as long as one or more party member agreed to go.
    Finally it is in tune with the social theme. I may not go to this event, but some people in my party are going...


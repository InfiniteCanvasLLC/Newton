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


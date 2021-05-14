# LiveView Chat App
LiveView Chat App with TailwindCSS and POW Auth Boilerplate 

![alt text](https://i.imgur.com/TbnTsGL.gif)

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Before going to the liveview chat app, first you need to:

  * Register atleast 2 users 
  * Sign in one of your user to incognito or other browser (to check liveview functionality) 
  * Go to: http://localhost:4000/chat

Right now I automatically created chat conversations based on the number of users, 
so you can quickly check its functionality

Features:
- Authentication using POW Auth
- Integrate TailwindCSS Framework
- Realtime Messaging (LiveView, PubSub)
- Unread messages counter (automatically reads all messages when the conversation was open)
- Latest message preview (beside unread messages counter)
- Search conversation feature
- Messages grouped by date sent

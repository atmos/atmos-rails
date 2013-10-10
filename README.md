# webhook endpoint generator

![](http://25.media.tumblr.com/ffc3802d129e5f580d207d9cf725fc52/tumblr_mrltxbddK51szim6vo1_1280.jpg)

## What you get:

* rspec
* resque
* github oauth
* pry and friends
* heroku support via procfile

## Usage

    $ rails new your_awesome_app -m https://raw.github.com/atmos/webhook_endpoint_generator/master/generator.rb

If you're pushing to heroku you'll need to enable 3 environmental variables for resque-web support. It authenticates via GitHub OAuth.

    $ heroku config:add GITHUB_CLIENT_ID=<id>
    $ heroku config:add GITHUB_CLIENT_SECRET=<secret>
    $ heroku config:add GITHUB_TEAM_ID=<id of team>

The team is a constraint that I personally use. If you want a different set of auth check the routes.rb and loosen it up to an organization or something similar.

## Credits

I stole most of this from [@therealadam](https://github.com/therealadam).

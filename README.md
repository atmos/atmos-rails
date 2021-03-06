# webhook endpoint generator

![](http://25.media.tumblr.com/ffc3802d129e5f580d207d9cf725fc52/tumblr_mrltxbddK51szim6vo1_1280.jpg)

## What you get:

* rspec
* resque
* pry and friends
* warden-github-rails
* heroku support via procfile

## Usage

    $ rails new your_awesome_app -m https://raw.github.com/atmos/atmos-rails/master/generator.rb

You'll need to add a redis addon, I've been using openredis.

    ~/your_awesome_app(master*)$ heroku create your_awesome_app
    Creating your_awesome_app... done, stack is cedar
    http://your_awesome_app.herokuapp.com/ | git@heroku.com:your_awesome_app.git
    Git remote heroku added
    ~/your_awesome_app(master*)$ heroku addons:add openredis:micro
    Adding openredis:micro on your_awesome_app... done, v3 ($10/mo)
    Use `heroku addons:docs openredis` to view documentation.

If you want resque-web you'll need to enable 3 environmental variables for GitHub OAuth support.

    $ heroku config:add GITHUB_CLIENT_ID=<id>
    $ heroku config:add GITHUB_CLIENT_SECRET=<secret>
    $ heroku config:add GITHUB_TEAM_ID=<id of team>

The team is a constraint that I personally use. If you want a different set of auth check the routes.rb and loosen it up to an organization or something similar.

## Credits

I stole most of this from [@therealadam](https://github.com/therealadam).

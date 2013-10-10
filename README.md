# atmos lovely app generator

I stole this from @therealadam. I have no idea what I'm doing.

![](http://25.media.tumblr.com/ffc3802d129e5f580d207d9cf725fc52/tumblr_mrltxbddK51szim6vo1_1280.jpg)

What you get:

* rspec
* pry and friends (via jazzhands), rack-mini-profiler, better_errors, foreman
* A lovely error message if something went sideways (note: will be obscured by
  `rails new` running `bundle` _after_ the template runs)

## Usage

    $ rails new your_awesome_app -m https://github.com/atmos/rails_sucks/generator.rb

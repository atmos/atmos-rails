# atmos lovely app generator

I stole this from @therealadam. I have no idea what I'm doing.

![](http://www.angelfoodcomic.com/wp-content/uploads/I-have-no-idea-what-I-am-doing.jpg)

What you get:

* rspec
* pry and friends (via jazzhands), rack-mini-profiler, better_errors, foreman
* A lovely error message if something went sideways (note: will be obscured by
  `rails new` running `bundle` _after_ the template runs)

## Usage

    $ rails new your_awesome_app -m https://github.com/atmos/rails_sucks/generator.rb

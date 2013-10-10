# atmos' Rails app template
# =============================
#
# Generate an application, just like atmos likes them.

# Testing dependencies
# ------------

gem_group :development, :test do
  gem 'pry'
  gem 'sqlite3'
  gem 'rspec-rails'
end
run "rm -rf test" # Is there a way to set the -T option on the new command?

# Development dependencies
# ------------

gem_group :development do
  gem 'foreman'
  gem 'meta_request'
  gem 'better_errors'
  gem 'binding_of_caller'
end

gem_group :staging, :production do
  gem 'pg'
end
# Application dependencies
# ------------------------
gem 'resque'
gem 'unicorn'
gem 'yajl-ruby'
gem 'warden-github-rails'

# Front-end dependencies
# ----------------------

# Baseline configuration
# ----------------------

rakefile "resque.rake" do
  %Q{
    require 'resque/tasks'

    namespace :resque do
      task :setup => [:environment] do
      end
    end
  }
end

initializer "libraries.rb" do
<<-EOF
# General requires you have for various things
require 'resque/server'
EOF
end

initializer "warden-github.rb" do
<<-EOF
require 'warden/github/rails'

Warden::GitHub::Rails.setup do |config|
  config.add_scope :user,  :client_id     => ENV['GITHUB_CLIENT_ID'],
                           :client_secret => ENV['GITHUB_CLIENT_SECRET'],
                           :scope         => 'user'

  config.add_team :employees, ENV['GITHUB_TEAM_ID'] || '135235'

  config.default_scope = :user
end
EOF
end

initializer "resque.rb" do
<<-EOF
module #{app_const_base}
  REDIS_PREFIX = "#{app_const_base.underscore.downcase.dasherize}:\#{Rails.env}"

  def self.redis
    @redis ||= if ENV["OPENREDIS_URL"]
                 uri = URI.parse(ENV["OPENREDIS_URL"])
                 Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
               elsif ENV["BOXEN_REDIS_URL"]
                 uri = URI.parse(ENV["BOXEN_REDIS_URL"])
                 Redis.new(:host => uri.host, :port => uri.port)
               else
                 Redis.new
               end
    Resque.redis = Redis::Namespace.new("\#{REDIS_PREFIX}:resque", :redis => @redis)
    @redis
  end

  def self.redis_reconnect!
    @redis = nil
    redis
  end
end

# initialize early to ensure proper resque prefixes
#{app_const_base}.redis
EOF
end

# Default routes, authenticate resque web and setup a callback url
route <<-EOF
get  "/" => redirect("https://github.com")

github_authenticate(:team => :employees) do
  mount Resque::Server.new, :at => "/resque"
end

post "/callbacks" => "callbacks#create"
EOF

# Vendor front-end bits
# ---------------------

# Fiddly things
# -------------
run "rm README.rdoc"
run %Q{echo "" > README.md}
run %Q{echo "# A new GitHub app!" > README.md}

run %Q{echo "web: bundle exec unicorn -p $PORT" >> Procfile}
run %Q{echo "worker: QUEUE="*" bundle exec rake resque:work" >> Procfile}

run %Q{sed -i .bak "/^gem 'sqlite3'$/d" Gemfile}
run %Q{sed -i .bak "/^# Use sqlite3 as the database for Active Record$/d" Gemfile}

run %Q{rm Gemfile.bak*}

run %Q{cp config/environments/production.rb config/environments/staging.rb}

environment 'config.force_ssl = true', env: 'staging'
environment 'config.force_ssl = true', env: 'production'

# Bootstrapping
# -------------
run "bundle install"
generate 'rspec:install'

# setup DB
git :init
git add: "."
git commit: %Q{ -m 'Big Bang :boom:' }

run "bundle cache"
git add: "vendor/cache"
git commit: %Q{ -m 'vendor gems to vendor/cache' }


# TODO the default app generator runs bundle after this, killing all the lovely
# commentary from the last two commands, fix that!


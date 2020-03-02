source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '= 5.1.3'
gem 'responders'
# gem 'devise'
# More info at https://github.com/lostisland/faraday . Make client in /lib folder,
# put reference in application_controller and define a @ variable to use everywhere
gem 'faraday'

# Use Postgres as the database for Active Record
gem 'pg', '~> 0.20'

# After running 'bundle install', run 'bundle exec figaro install'
gem 'figaro'

# Use Puma as the app server
gem 'puma', '~> 3.7'

# RuboCop is a Ruby static code analyzer. Out of the box it will enforce
# many of the guidelines outlined in the community Ruby Style Guide.
gem 'rubocop', '~> 0.49.1', require: false

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

gem 'active_model_serializers'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'


gem 'sidekiq'
gem 'capistrano-sidekiq'

gem 'cloudwatchlogger'

# For handling XL operations
gem 'rubyXL'
gem 'spreadsheet'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS),
# making cross-origin AJAX possible
gem 'rack-cors', :require => 'rack/cors'

gem 'jwt'

gem 'rb-readline' 

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution
  # and get a debugger console
  gem 'byebug'
  # Factory Girl allows you create objects that you need in your tests
  # which can include default values.
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'rspec-rails', '~> 3.6'
end

group :development do
  # The Listen gem listens to file modifications and notifies you about the changes
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running
  # in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Web Console is a debugging tool. Calling console in a controller will result in a console in the context of the controller action:
  gem 'web-console' 
  # Use Capistrano for deployment
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano-rvm'
  gem 'capistrano3-puma'
end
group :test do
  gem 'database_cleaner', '~> 1.5'
  # Faker is useful in generating random data for your test.
  gem 'faker', '~> 1.6.1'
  gem 'shoulda-matchers', '~> 3.0', require: false
end
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

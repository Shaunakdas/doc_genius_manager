# dump the development db
rake db:dump

# dump the production db
RAILS_ENV=production rake db:dump

# dump the production db & restore it to the development db
RAILS_ENV=production rake db:dump
rake db:restore
# README
This repository contains code for the API for Deal Engile. This API will manage all the business logic and all the backend subjects related to Deal Engine Challenge.

## Set up the application
To install and run the project, follow the next steps

- Install Git Flow
https://danielkummer.github.io/git-flow-cheatsheet/

- Install asdf
https://asdf-vm.com/guide/getting-started.html

- Add dependencies for project
`asdf plugin add ruby`

- Install dependencies for project
`asdf install`

- Edit your Postgres credentials if you dont know your password
`ALTER USER your_user_name WITH PASSWORD 'new_password';`

- Install Redis on your local Machine

- Install libpq-dev for PG Gem on Ubuntu
`sudo apt install libpq-dev`

- Install Gems
`bundle install`

- Create db
`rails db:create`

- Migrate db
`rails db:migrate`

## Run the application
From your console run the following command
- `rails s`

* **Start Sidekiq**:
In a separate terminal window, start the Sidekiq process to handle all asynchronous jobs (like sending emails or processing data):
- `bundle exec sidekiq`

## Run test Suite

* **Run All Tests**: Execute all tests with the following command:
- `bundle exec rspec`

* **Run a Specific Test File**: To run a single test file, specify its path:
- `bundle exec rspec spec/models/my_model_spec.rb`

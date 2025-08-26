# README
This repository contains code for the API for invo system. This API will manage all the business logic and all the backend subjects related to invo.

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

- Edit your Postres credentials if you dont know your password
`ALTER USER your_user_name WITH PASSWORD 'new_password';`

- Install bundler 2.5.5
`gem install bundler -v 2.5.5`

- Install libpq-dev for PG Gem
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

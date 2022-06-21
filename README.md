# Easyship Developer Challenge
## Guidelines

- **Repository**: Create a private repository in Github and share it with us
- **Bugs**: Fix bugs you find and feel free to suggest changes to make the codes cleaner
- **Git Workflow**: For each task, create a new feature branch. Base first branch off `master`, and any of the rest off its previous one
- **Review**: Open a PR and request reviews once the latest task you work on is completed. We prefer review-first workflow to make sure coding direction is correct before moving on to next task(s)
- **Test**: To ensure code changes adhere to the desired functionality, please write tests using RSpec

## Tasks

- [Junior](junior_tasks.md)
- [Mid / Senior](mid_senior_tasks.md)

## How to run
- Set up application
```shell
bundle install
bundle exec rake db:migrate
```
- Install elasticsearch
```shell
brew tap elastic/tap
brew install elastic/tap/elasticsearch-full
```
- Run server
```shell
brew services start elasticsearch-full
rails s
```

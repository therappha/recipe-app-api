# Course Notes

How to run linting inside docker container

For Development p refer vscode extension, but to run manually for tests and validation:

```sh
	docker-compose run --rm app sh -c "flake8"
```

How to run unit tests inside docker container

```sh
	docker-compose run --rm app sh -c "python manage.py test"
```


All commands from django-admin or manage.py will be run inside the app container like this:

```sh
	docker-compose run --rm app sh -c "python manage.py <command>"
```
or for django-admin

```sh
	docker-compose run --rm app sh -c "django-admin <command>"
```


# How to setup github actions for testing

1. Create a .github/workflows/config_name.yml file, the name of the config does not matter as long as it ends with .yml
2. Set a trigger for the action, like push or pull_request
3. Add steps for running testing and linting


for actions check for https://github.com/marketplace?type=actions



File Upload Testing

Caching

Signals

Custom Managers e Querysets

Middleware

Background Taks

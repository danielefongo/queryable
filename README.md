# Queryable

## Run the tests
```
docker-compose run --rm --service-ports queryable mix deps.get
docker-compose run --rm --service-ports queryable mix test
```

## Run in interactive mode
```
docker-compose run --rm --service-ports queryable mix ecto.init && iex -S mix
```
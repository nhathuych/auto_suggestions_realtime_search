# auto_suggestions_realtime_search

## Create project
```
rails new auto_suggestions_realtime_search -d postgresql --css tailwind
```

## Setup database
```
rails db:seed
```

## Run docker
```
docker compose up
```

## Run (to debug easily)
```
rails s
```
```
bin/rails tailwindcss:watch
```

## Run with the foreman gem
```
bin/dev
```

## Debugging
rails c
```
Book.first.__elasticsearch__.as_indexed_json
```
Result
```
{"title"=>"A Confederacy of Dunces",
 "description"=>"Plant a memory, plant a tree, do it today for tomorrow.",
 "author"=>{"name"=>"Vernita Denesik Sr."}}
```

## Kibana
Visit these urls
```
http://localhost:5601/app/kibana#/dev_tools/console?_g=()
http://localhost:5601/app/management/data/index_management/indices
```
Query
```
GET /books/_search?size=1000
```

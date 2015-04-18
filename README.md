# Azure DocumentDB Ruby SDK

Lacking an official ruby SDK I'm going to start building one from my use case perspective.  Please help contribute and grow this project.  This project is in ALPHA state.

# Example usage

```
> require 'documentdb'
>
> url_endpoint = ... # your url address
> master_key = ... # your master_key
>
> context = Azure::DocumentDB::Context.new url_endpoint, master_keys
> database = Azure::DocumentDB::Database.new context, RestClient
>
> database.list
=> {"_rid"=>"", "Databases"=>[], "_count"=>0}
>
> database.create "NewDatabase"
=> {"id"=>"DatabaseExample", "_rid"=>"fn4ZAA==", "_ts"=>1429304742, "_self"=>"dbs/fn4ZAA==/", "_etag"=>""00000100-0000-0000-0000-553175a60000"", "_colls"=>"colls/", "_users"=>"users/"}
```

# Development

Install Bundler.

`gem install bundler`

Clone the project.

`bundle install`

To execute tests:

`bundle exec rspec`

Coverage can be found in the ./coverage directory

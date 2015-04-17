# Azure DocumentDB Ruby SDK

Lacking an official ruby SDK I'm going to start building one from my use case perspective.  Please help contribute and grow this project.  This project is completely in ALPHA state.

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
```

NOTE: Still working on the create method.  It currently appears that there are more header elements required then what the documentation states.


# Development

Install Bundler.

`gem install bundler`

Clone the project.

`bundle install`

To execute tests:

`bundle exec rspec`

Coverage can be found in the ./coverage directory

# Database

Database provides functionality described in the [MSDN DocumentDB Database REST API description](https://msdn.microsoft.com/en-us/library/azure/dn782194.aspx).

# Example usage

## Instantiation of a database object
```
> require 'documentdb'
>
> url_endpoint = ... # your url address
> master_key = ... # your master_key
>
> context = Azure::DocumentDB::Context.new url_endpoint, master_key
> database = Azure::DocumentDB::Database.new context, RestClient
```

## List Document Databases
```
> database.list
=> {"_rid"=>"", "Databases"=>[], "_count"=>0}
```

## Create a Document Database

```
> database.create "NewDatabase"
=> {"id"=>"DatabaseExample", "_rid"=>"fn4ZAA==", "_ts"=>1429304742, "_self"=>"dbs/fn4ZAA==/", "_etag"=>""00000100-0000-0000-0000-553175a60000"", "_colls"=>"colls/", "_users"=>"users/"}
```

## Get a Document Database

```
> database.get "fn4ZAA=="
=> {"id"=>"DatabaseExample", "_rid"=>"fn4ZAA==", "_ts"=>1429304742, "_self"=>"dbs/fn4ZAA==/", "_etag"=>""00000100-0000-0000-0000-553175a60000"", "_colls"=>"colls/", "_users"=>"users/"}
```

## Delete a Document Database
```
> database.delete "fn4ZAA=="
```

## Get uri of the Document Database
```
> database.uri
=> "https://[your uri of your document db instance]/dbs"
```

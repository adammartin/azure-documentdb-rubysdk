# Database

Database provides functionality described in the [MSDN DocumentDB Database REST API description](https://msdn.microsoft.com/en-us/library/azure/dn782194.aspx).

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

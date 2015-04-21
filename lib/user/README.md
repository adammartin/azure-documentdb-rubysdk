# User

User provides the functionality described in the [MSDN DocumentDB Database REST API description](https://msdn.microsoft.com/en-us/library/azure/dn782193.aspx).

# Example usage

## Instantiation of a user object
```
> require 'documentdb'
>
> url_endpoint = ... # your url address
> master_key = ... # your master_key
>
> context = Azure::DocumentDB::Context.new url_endpoint, master_keys
> database = Azure::DocumentDB::Database.new context, RestClient
> user = Azure::DocumentDB::User.new context, RestClient
> db_instance = database.list["Databases"][0] # or you can use get if you know the exact _rid
> db_instance_id = db_instance["_rid"]
```

## List Users for a Database Instance
```
> user.list db_instance_id
=> {"_rid"=>"1BZ1AA==", "Users"=>[], "_count"=>1}
```

## Create a User for a Document Database

```
> user.create db_instance_id, "craftsmanadam"
=> {"id"=>"craftsmanadam", "_rid"=>"1BZ1AFzDMAA=", "_ts"=>1429621541, "_self"=>"dbs/1BZ1AA==/users/1BZ1AFzDMAA=/", "_etag"=>""00000700-0000-0000-0000-55364b250000"", "_permissions"=>"permissions/"}
```

## Get a User for a Document Database

```
> user.get db_instance_id, "1BZ1AFzDMAA="
=> {"id"=>"craftsmanadam", "_rid"=>"1BZ1AFzDMAA=", "_ts"=>1429621541, "_self"=>"dbs/1BZ1AA==/users/1BZ1AFzDMAA=/", "_etag"=>""00000700-0000-0000-0000-55364b250000"", "_permissions"=>"permissions/"}
```

## Delete a User for a Document Database

```
user.delete db_instance_id, "1BZ1AFzDMAA="
```

## Replace a User for a Document Database
```
> original_user = user.get db_instance_id, "1BZ1AFzDMAA="
=> {"id"=>"craftsmanadam", "_rid"=>"1BZ1AFzDMAA=", "_ts"=>1429621541, "_self"=>"dbs/1BZ1AA==/users/1BZ1AFzDMAA=/", "_etag"=>""00000700-0000-0000-0000-55364b250000"", "_permissions"=>"permissions/"}
>
> user.replace db_instance_id, original_user["_rid"], "craftsmanbob"
=> {"id"=>"craftsmanbob", "_rid"=>"1BZ1AFzDMAA=", "_ts"=>1429627578, "_self"=>"dbs/1BZ1AA==/users/1BZ1AFzDMAA=/", "_etag"=>""00000900-0000-0000-0000-553662ba0000"", "_permissions"=>"permissions/"}
```

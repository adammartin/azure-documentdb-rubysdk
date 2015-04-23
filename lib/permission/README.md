# Permission

Permission provides the functionality desrcribed in the [MSDN DocumentDB Database Rest API description](https://msdn.microsoft.com/en-us/library/azure/dn782246.aspx).

# Example usage

## Instantiation of a Permission object
```
> require 'documentdb'
>
> url_endpoint = ... # your url address
> master_key = ... # your master_key
>
> context = Azure::DocumentDB::Context.new url_endpoint, master_key
> database = Azure::DocumentDB::Database.new context, RestClient
> user = Azure::DocumentDB::User.new context, RestClient
> permission = Azure::DocumentDB::Permission.new context, RestClient
> db_instance = database.list["Databases"][0] # or you can use get if you know the exact _rid
> db_instance_id = db_instance["_rid"]
> user_instance = user.list(db_instance_id)["Users"][0]
> user_id = user_instance["_rid"]

[TODO: NEED TO PUT COLLECTION EXAMPLE HERE]

```

## List Permissions for a User on a Database
```
> permission.list db_instance_id, user_id
=> {"_rid"=>"1BZ1AFzDMAA=", "Permissions"=>[], "_count"=>0}
```

## Create a Permission for a User on a Database for a Resource

A couple of notes.

First there are two types of permission modes "All" and "Read".  "All" grants full CRUD operations while Read only provides standard READ access.  All and Read are represented by `Azure::DocumentDB::Permissions::Mode.ALL` and `Azure::DocumentDB::Permissions::Mode.READ` respectively.

Second the resource link you must pass in is the "_self" designation from a given resource you want permissions applied to.

Third be careful to read the [rules](https://msdn.microsoft.com/en-us/library/azure/dn803932.aspx) on creation to understand what is and is not allowed.  This API is simply a pass through of the requirements.

```
> perm_mode = Azure::DocumentDB::Permissions::Mode.ALL
> permission.create db_instance_id, user_id, "ExamplePermission", perm_mode, [TODO: NEED TO PUT COLLECTION ID HERE]

[TODO: INCLUDE RESULTING PRINT OUT]
```

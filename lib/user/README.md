# User

User provides the functionality described in the [MSDN DocumentDB Database REST API description](https://msdn.microsoft.com/en-us/library/azure/dn782193.aspx).

# Example usage

## Instantiation of a user object

User objects are created by the [Azure::DocumentDB::Database object](/lib/database)

## List Users for a Database Instance
```
> user.list
=> {"_rid"=>"1BZ1AA==", "Users"=>[], "_count"=>1}
```

## Create a User for a Document Database

```
> user.create "craftsmanadam"
=> {"id"=>"craftsmanadam", "_rid"=>"1BZ1AFzDMAA=", "_ts"=>1429621541, "_self"=>"dbs/1BZ1AA==/users/1BZ1AFzDMAA=/", "_etag"=>""00000700-0000-0000-0000-55364b250000"", "_permissions"=>"permissions/"}
```

## Get a User for a Document Database

```
> user.get "1BZ1AFzDMAA="
=> {"id"=>"craftsmanadam", "_rid"=>"1BZ1AFzDMAA=", "_ts"=>1429621541, "_self"=>"dbs/1BZ1AA==/users/1BZ1AFzDMAA=/", "_etag"=>""00000700-0000-0000-0000-55364b250000"", "_permissions"=>"permissions/"}
```

## Delete a User for a Document Database

```
user.delete "1BZ1AFzDMAA="
```

## Replace a User for a Document Database
```
> original_user = user.get "1BZ1AFzDMAA="
=> {"id"=>"craftsmanadam", "_rid"=>"1BZ1AFzDMAA=", "_ts"=>1429621541, "_self"=>"dbs/1BZ1AA==/users/1BZ1AFzDMAA=/", "_etag"=>""00000700-0000-0000-0000-55364b250000"", "_permissions"=>"permissions/"}
>
> user.replace original_user["_rid"], "craftsmanbob"
=> {"id"=>"craftsmanbob", "_rid"=>"1BZ1AFzDMAA=", "_ts"=>1429627578, "_self"=>"dbs/1BZ1AA==/users/1BZ1AFzDMAA=/", "_etag"=>""00000900-0000-0000-0000-553662ba0000"", "_permissions"=>"permissions/"}
```

## Create a Permission for a User

You can create an Azure::DocumentDB::Permission object from a User object using `user_name` or `user_rid`

### Create using a user resource id
```
> user_rid = user.list["Users"][0]["_rid"]
> permission = user.permission_for_rid user_rid
=> #<Azure::DocumentDB::Permission:0x007feb0c40ca78 @context=#<Azure::DocumentDB::Context:0x007feb0c35e978 @endpoint="https://had-test.documents.azure.com:443", @master_token=#<Azure::DocumentDB::MasterToken:0x007feb0c35e950 @master_key="mLg+Dx8tSnnzozD5I2jotTr8FvkI6OSNBmCMwui8U83yxyZvJ2wMHQZjgnvvAfBW7HYJf3xlm/IRjAdRDcWfHw==">, service_version"2015-04-08", rest_clientRestClient, database_id"1BZ1AA==", user_id"1BZ1AFzDMAA=", resource_type"permissions", parent_resource_type"users", secure_header#<Azure::DocumentDB::SecureHeader:0x007feb0c40ca50 @token=#<Azure::DocumentDB::MasterToken:0x007feb0c35e950 @master_key="mLg+Dx8tSnnzozD5I2jotTr8FvkI6OSNBmCMwui8U83yxyZvJ2wMHQZjgnvvAfBW7HYJf3xlm/IRjAdRDcWfHw==">, resource_type"permissions"
```

### Create using a user name
```
> user_name = user.list["Users"][0]["id"]
> permission = user.permission_for_name user_name
=> #<Azure::DocumentDB::Permission:0x007feb0c48e5c8 @context=#<Azure::DocumentDB::Context:0x007feb0c35e978 @endpoint="https://had-test.documents.azure.com:443", @master_token=#<Azure::DocumentDB::MasterToken:0x007feb0c35e950 @master_key="mLg+Dx8tSnnzozD5I2jotTr8FvkI6OSNBmCMwui8U83yxyZvJ2wMHQZjgnvvAfBW7HYJf3xlm/IRjAdRDcWfHw==">, service_version"2015-04-08", rest_clientRestClient, database_id"1BZ1AA==", user_id"1BZ1AFzDMAA=", resource_type"permissions", parent_resource_type"users", secure_header#<Azure::DocumentDB::SecureHeader:0x007feb0c48e5a0 @token=#<Azure::DocumentDB::MasterToken:0x007feb0c35e950 @master_key="mLg+Dx8tSnnzozD5I2jotTr8FvkI6OSNBmCMwui8U83yxyZvJ2wMHQZjgnvvAfBW7HYJf3xlm/IRjAdRDcWfHw==">, resource_type"permissions"
```

## Create a Query Object

You can create a query for user using the User Object.  See Azure::DocumentDB::Query README.md for explination of usage.

```
> query = user.query
=> #<Azure::DocumentDB::Query:0x007fad9d0837f0 @context=#<Azure::DocumentDB::Context:0x007fad9cda84e0 @endpoint="https://had-test.documents.azure.com:443", @master_token=#<Azure::DocumentDB::MasterToken:0x007fad9cda84b8 @master_key="mLg+Dx8tSnnzozD5I2jotTr8FvkI6OSNBmCMwui8U83yxyZvJ2wMHQZjgnvvAfBW7HYJf3xlm/IRjAdRDcWfHw==">, service_version"2015-04-08", rest_clientRestClient, resource_type"users", secure_header#<Azure::DocumentDB::SecureHeader:0x007fad9d0837c8 @token=#<Azure::DocumentDB::MasterToken:0x007fad9cda84b8 @master_key="mLg+Dx8tSnnzozD5I2jotTr8FvkI6OSNBmCMwui8U83yxyZvJ2wMHQZjgnvvAfBW7HYJf3xlm/IRjAdRDcWfHw==">, resource_type"users", parent_resource_id"1BZ1AA==", url"https://had-test.documents.azure.com:443/dbs/1BZ1AA==/users"
```

## Get uri for the User resource
```
user.uri
=> "https://[uri of your documentdb instance]/dbs/1BZ1AA==/users"
```
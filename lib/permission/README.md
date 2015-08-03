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
> collection = Azure::DocumentDB::Collection.new context, RestClient
> db_instance = database.list["Databases"][0] # or you can use get if you know the exact _rid
> db_instance_id = db_instance["_rid"]
> user_instance = user.list(db_instance_id)["Users"][0]
> user_id = user_instance["_rid"]
> collection_id = collection.list(db_instance_id)["DocumentCollections"][0]["_rid"]

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
> collection_resource = "dbs/#{db_instance_id}/colls/#{collection_id}"
> permission.create db_instance_id, user_id, "ExamplePermission", perm_mode, collection_resource

=> {"id"=>"ExamplePermission", "permissionMode"=>"All", "resource"=>"dbs/1BZ1AA==/colls/1BZ1AMBZFwA=", "_rid"=>"1BZ1AFzDMABeWbGCS-8ZAA==", "_ts"=>1438631312, "_self"=>"dbs/1BZ1AA==/users/1BZ1AFzDMAA=/permissions/1BZ1AFzDMABeWbGCS-8ZAA==/", "_etag"=>""00000300-0000-0000-0000-55bfc5900000"", "_token"=>"type=resource&ver=1&sig=CkCYUIZI77hxKsnDc5OPfg==;Oi1wEkvx2ajH5yHJJP67QtvaH3Xi51DIjNNInUJ4+M6tSqh81PcHnptRc3bMsAWMIwwl/hIa7HOfLI9WArc/fAk61pB/a1X1e9+EdNygmVagUVouTMqhDKSlZPEACqgXEwP0jqiMa6eThQ+bkcp0ATM29idYciRGd3oXelSFqrYXd2VKW3uCH3BX3YuLSDAKB+o8nxRCxVStwsSsRrregTcGMVKLonm9OX8iX2rFUrY=;"}
```

## Get a Specific Permission

```
> perm_id = "1BZ1AFzDMABeWbGCS-8ZAA=="
> permission.get db_instance_id, user_id, perm_id

=> {"id"=>"ExamplePermission", "permissionMode"=>"All", "resource"=>"dbs/1BZ1AA==/colls/1BZ1AMBZFwA=", "_rid"=>"1BZ1AFzDMABeWbGCS-8ZAA==", "_ts"=>1438631312, "_self"=>"dbs/1BZ1AA==/users/1BZ1AFzDMAA=/permissions/1BZ1AFzDMABeWbGCS-8ZAA==/", "_etag"=>""00000300-0000-0000-0000-55bfc5900000"", "_token"=>"type=resource&ver=1&sig=ciz2fCxVPCaIlUph7YPhmQ==;GIBUHHaAIB0s5brSP48Pbn9LOtpzZ1oEY0RD93qCZi49wjA5pLAVSymMIG6ZLH5Y1JCLj3XiMUPfpyKF5DYvmeONA1gBo2MvR2BPVGDprjO4woyWvHzkTtBa3Pf5vLIrpz/I+rtcdSDOK3YQFpbxDx9HTvB4XGXjxvR5DsID5dTEbPfBVweftDXrAESktDlhWUUnNFzdhCq4AG6sF4tdY0Zw1Z+IvMgZ+rLD967nbyU=;"}
```

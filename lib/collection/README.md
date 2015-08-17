# Collection

Database provides functionality described in the [MSDN DocumentDB Database REST API description](https://msdn.microsoft.com/en-us/library/azure/dn782194.aspx).

# Example usage

## Instantiation of a collection object

Collection objects are created by the [Azure::DocumentDB::Database object](/lib/database)

## Instantiation of a custom Indexing Policy

Indexing is a mildly complex creature in DocumentDB.  Be sure to read and understand the concept in Microsofts official Collection documentation.

```
> root_path = Azure::DocumentDB::IndexPath.ROOT_PATH # Default root path settings from Azure it is immutable
> custom_timestamp_path = Azure::DocumentDB::IndexPath.new "/\"_ts\"/?", Azure::DocumentDB::IndexType.RANGE
> custom_timestamp_path.numeric_precision 7 # set the precision to a higher level
>
> include_paths = [root_path, custom_timestamp_path]
> exclude_paths = []
> indexing_mode = Azure::DocumentDB::IndexingMode.CONSISTENT
> automatic = true
>
> policy = Azure::DocumentDB::IndexPolicy.new automatic, indexing_mode, include_paths, exclude_paths

```

## List Collections for a Database Instance
```
> collection.list
=> {"_rid"=>"1BZ1AA==", "DocumentCollections"=>[], "_count"=>0}
```

## Create a Collection for a Database Instance

With default indexing
```
> collection.create "sample_collection"
=> {"id"=>"sample_collection", "indexingPolicy"=>{"indexingMode"=>"consistent", "automatic"=>true, "IncludedPaths"=>[{"Path"=>"/", "IndexType"=>"Hash", "NumericPrecision"=>3, "StringPrecision"=>3}, {"Path"=>"/"_ts"/?", "IndexType"=>"Range", "NumericPrecision"=>6}], "ExcludedPaths"=>[]}, "_rid"=>"1BZ1AMBZFwA=", "_ts"=>1430919012, "_self"=>"dbs/1BZ1AA==/colls/1BZ1AMBZFwA=/", "_etag"=>""00000100-0000-0000-0000-554a17640000"", "_docs"=>"docs/", "_sprocs"=>"sprocs/", "_triggers"=>"triggers/", "_udfs"=>"udfs/", "_conflicts"=>"conflicts/"}
```

With custom indexing
```
> collection.create "sample_custom_collection", policy
=> {"id"=>"sample_custom_collection", "indexingPolicy"=>{"indexingMode"=>"consistent", "automatic"=>true, "IncludedPaths"=>[{"Path"=>"/", "IndexType"=>"Hash", "NumericPrecision"=>3, "StringPrecision"=>3}, {"Path"=>"/"_ts"/?", "IndexType"=>"Range", "NumericPrecision"=>6}], "ExcludedPaths"=>[]}, "_rid"=>"1BZ1AOr7lgA=", "_ts"=>1438793238, "_self"=>"dbs/1BZ1AA==/colls/1BZ1AOr7lgA=/", "_etag"=>""00000100-0000-0000-0000-55c23e160000"", "_docs"=>"docs/", "_sprocs"=>"sprocs/", "_triggers"=>"triggers/", "_udfs"=>"udfs/", "_conflicts"=>"conflicts/"}
```

## Get a Collection for a Database Instance
```
> collection_id = "1BZ1AMBZFwA=" # INSERT YOUR COLLECTION ID INSTEAD THIS IS JUST AN EXAMPLE #
> collection.get collection_id
=> {"id"=>"sample_collection", "indexingPolicy"=>{"indexingMode"=>"consistent", "automatic"=>true, "IncludedPaths"=>[{"Path"=>"/", "IndexType"=>"Hash", "NumericPrecision"=>3, "StringPrecision"=>3}, {"Path"=>"/"_ts"/?", "IndexType"=>"Range", "NumericPrecision"=>6}], "ExcludedPaths"=>[]}, "_rid"=>"1BZ1AMBZFwA=", "_ts"=>1430919012, "_self"=>"dbs/1BZ1AA==/colls/1BZ1AMBZFwA=/", "_etag"=>""00000100-0000-0000-0000-554a17640000"", "_docs"=>"docs/", "_sprocs"=>"sprocs/", "_triggers"=>"triggers/", "_udfs"=>"udfs/", "_conflicts"=>"conflicts/"}
```

## Delete a Collection for a Database Instance
```
> coll_to_del_rid = "1BZ1AOr7lgA="
> collection.delete coll_to_del_rid
```

## Using a Resource Token

Per the documentation a resource token is allowed for list, get, and delete operations.  In each case you can simply add the resource token as an optional argument.  Below is an example of a get operation.

```
> perm_rid = # insert your permission resource id here
> user = Azure::DocumentDB::User.new context, RestClient, db_instance_id
> user_id = user.list["Users"][0]["_rid"]
> permission = Azure::DocumentDB::Permission.new context, RestClient, db_instance_id, user_id
> resource_token = permission.resource_token perm_rid
> collection.get collection_id, resource_token

=> {"id"=>"sample_collection", "indexingPolicy"=>{"indexingMode"=>"consistent", "automatic"=>true, "IncludedPaths"=>[{"Path"=>"/", "IndexType"=>"Hash", "NumericPrecision"=>3, "StringPrecision"=>3}, {"Path"=>"/"_ts"/?", "IndexType"=>"Range", "NumericPrecision"=>6}], "ExcludedPaths"=>[]}, "_rid"=>"1BZ1AMBZFwA=", "_ts"=>1430919012, "_self"=>"dbs/1BZ1AA==/colls/1BZ1AMBZFwA=/", "_etag"=>""00000100-0000-0000-0000-554a17640000"", "_docs"=>"docs/", "_sprocs"=>"sprocs/", "_triggers"=>"triggers/", "_udfs"=>"udfs/", "_conflicts"=>"conflicts/"}
```

## Create a Document Object

You can create an Azure::DocumentDB::Document object from the Collection object using `collection_name` or `collection_rid`

### Create using a collection resource id
```
> coll_rid = collection.list["DocumentCollections"][0]["_rid"]
> document = collection.document_for_rid coll_rid
=> #<Azure::DocumentDB::Document:0x007feb0a530730 @context=#<Azure::DocumentDB::Context:0x007feb0c35e978 @endpoint="https://had-test.documents.azure.com:443", @master_token=#<Azure::DocumentDB::MasterToken:0x007feb0c35e950 @master_key="mLg+Dx8tSnnzozD5I2jotTr8FvkI6OSNBmCMwui8U83yxyZvJ2wMHQZjgnvvAfBW7HYJf3xlm/IRjAdRDcWfHw==">, service_version"2015-04-08", rest_clientRestClient, resource_type"docs", secure_header#<Azure::DocumentDB::SecureHeader:0x007feb0a5306e0 @token=#<Azure::DocumentDB::MasterToken:0x007feb0c35e950 @master_key="mLg+Dx8tSnnzozD5I2jotTr8FvkI6OSNBmCMwui8U83yxyZvJ2wMHQZjgnvvAfBW7HYJf3xlm/IRjAdRDcWfHw==">, resource_type"docs", database_id"1BZ1AA==", collection_id"1BZ1AMBZFwA=", resource_tokennil
```
### Creating using a collection resoure id and resource_token
```
> resource_token = # insert your resource token from a permission from an appropriate source
> coll_rid = collection.list["DocumentCollections"][0]["_rid"]
> document = collection.document_for_rid coll_rid, resource_token
 => #<Azure::DocumentDB::Document:0x007feb0a576d70 @context=#<Azure::DocumentDB::Context:0x007feb0c35e978 @endpoint="https://had-test.documents.azure.com:443", @master_token=#<Azure::DocumentDB::MasterToken:0x007feb0c35e950 @master_key="mLg+Dx8tSnnzozD5I2jotTr8FvkI6OSNBmCMwui8U83yxyZvJ2wMHQZjgnvvAfBW7HYJf3xlm/IRjAdRDcWfHw==">, service_version"2015-04-08", rest_clientRestClient, resource_type"docs", secure_header#<Azure::DocumentDB::SecureHeader:0x007feb0a576d20 @token=#<Azure::DocumentDB::MasterToken:0x007feb0c35e950 @master_key="mLg+Dx8tSnnzozD5I2jotTr8FvkI6OSNBmCMwui8U83yxyZvJ2wMHQZjgnvvAfBW7HYJf3xlm/IRjAdRDcWfHw==">, resource_type"docs", database_id"1BZ1AA==", collection_id"1BZ1AMBZFwA=", resource_token#<Azure::DocumentDB::ResourceToken:0x007feb0c560190 @encoded_token="type%3Dresource%26ver%3D1%26sig%3DNIHStPXxgU82yKwnK8RG4A%3D%3D%3BNQ90Jwqp7Q6ejur2Sh4ZnpdB4eNRGgohQYo9zazSQgDtRieGX9e1E7VWvYSIPY9lpYtv8t2EwD1LYXGl5R1K6TBymbqwHrwwWBlH0HEDsEEHZ3mF6%2F1tSkrVh0UjR1sGuuYSyku0cadZm1XNWnM78Fz5AjSHg1LeRNrU%2FMVvW%2BsFZAPxin1SG2Z6lrr0saWTEp2dbU8vv0mLKLvZn61pkbXRWOJHej0fx%2FY1dKe0lIE%3D%3B">
```

### Creating using a collection name
```
> coll_name = collection.list["DocumentCollections"][0]["id"]
> document = collection.document_for_name coll_name
=> #<Azure::DocumentDB::Document:0x007feb0a612bf8 @context=#<Azure::DocumentDB::Context:0x007feb0c35e978 @endpoint="https://had-test.documents.azure.com:443", @master_token=#<Azure::DocumentDB::MasterToken:0x007feb0c35e950 @master_key="mLg+Dx8tSnnzozD5I2jotTr8FvkI6OSNBmCMwui8U83yxyZvJ2wMHQZjgnvvAfBW7HYJf3xlm/IRjAdRDcWfHw==">, service_version"2015-04-08", rest_clientRestClient, resource_type"docs", secure_header#<Azure::DocumentDB::SecureHeader:0x007feb0a612ba8 @token=#<Azure::DocumentDB::MasterToken:0x007feb0c35e950 @master_key="mLg+Dx8tSnnzozD5I2jotTr8FvkI6OSNBmCMwui8U83yxyZvJ2wMHQZjgnvvAfBW7HYJf3xlm/IRjAdRDcWfHw==">, resource_type"docs", database_id"1BZ1AA==", collection_id"1BZ1AMBZFwA=", resource_tokennil
```
### Creating using a collection name and a resource_token
```
> resource_token = # insert your resource token from a permission from an appropriate source
> coll_name = collection.list["DocumentCollections"][0]["id"]
> document = collection.document_for_name coll_name, resource_token
=> #<Azure::DocumentDB::Document:0x007feb0a4e4f10 @context=#<Azure::DocumentDB::Context:0x007feb0c35e978 @endpoint="https://had-test.documents.azure.com:443", @master_token=#<Azure::DocumentDB::MasterToken:0x007feb0c35e950 @master_key="mLg+Dx8tSnnzozD5I2jotTr8FvkI6OSNBmCMwui8U83yxyZvJ2wMHQZjgnvvAfBW7HYJf3xlm/IRjAdRDcWfHw==">, service_version"2015-04-08", rest_clientRestClient, resource_type"docs", secure_header#<Azure::DocumentDB::SecureHeader:0x007feb0a4e4ec0 @token=#<Azure::DocumentDB::MasterToken:0x007feb0c35e950 @master_key="mLg+Dx8tSnnzozD5I2jotTr8FvkI6OSNBmCMwui8U83yxyZvJ2wMHQZjgnvvAfBW7HYJf3xlm/IRjAdRDcWfHw==">, resource_type"docs", database_id"1BZ1AA==", collection_id"1BZ1AMBZFwA=", resource_token#<Azure::DocumentDB::ResourceToken:0x007feb0c560190 @encoded_token="type%3Dresource%26ver%3D1%26sig%3DNIHStPXxgU82yKwnK8RG4A%3D%3D%3BNQ90Jwqp7Q6ejur2Sh4ZnpdB4eNRGgohQYo9zazSQgDtRieGX9e1E7VWvYSIPY9lpYtv8t2EwD1LYXGl5R1K6TBymbqwHrwwWBlH0HEDsEEHZ3mF6%2F1tSkrVh0UjR1sGuuYSyku0cadZm1XNWnM78Fz5AjSHg1LeRNrU%2FMVvW%2BsFZAPxin1SG2Z6lrr0saWTEp2dbU8vv0mLKLvZn61pkbXRWOJHej0fx%2FY1dKe0lIE%3D%3B">
```

## Create a Query Object

You can create a query for a collection using the Collection Object.  See Azure::DocumentDB::Query README.md for explination of usage

```
query = collection.query
 => #<Azure::DocumentDB::Query:0x007fa7caf9efb0 @context=#<Azure::DocumentDB::Context:0x007fa7ca6f2790 @endpoint="https://had-test.documents.azure.com:443", @master_token=#<Azure::DocumentDB::MasterToken:0x007fa7ca6f2740 @master_key="mLg+Dx8tSnnzozD5I2jotTr8FvkI6OSNBmCMwui8U83yxyZvJ2wMHQZjgnvvAfBW7HYJf3xlm/IRjAdRDcWfHw==">, service_version"2015-04-08", rest_clientRestClient, resource_type"colls", secure_header#<Azure::DocumentDB::SecureHeader:0x007fa7caf9ef88 @token=#<Azure::DocumentDB::MasterToken:0x007fa7ca6f2740 @master_key="mLg+Dx8tSnnzozD5I2jotTr8FvkI6OSNBmCMwui8U83yxyZvJ2wMHQZjgnvvAfBW7HYJf3xlm/IRjAdRDcWfHw==">, resource_type"colls", parent_resource_id"1BZ1AA==", url"https://had-test.documents.azure.com:443/dbs/1BZ1AA==/colls"
```

## Get the uri of the Collection
```
> collection.uri

=> "https://[your_uri_goes_here]/dbs/1BZ1AA==/colls"
```
# Collection

Database provides functionality described in the [MSDN DocumentDB Database REST API description](https://msdn.microsoft.com/en-us/library/azure/dn782194.aspx).

# Example usage

## Instantiation of a collection object
```
> require 'documentdb'
>
> url_endpoint = ... # your url address
> master_key = ... # your master_key
>
> context = Azure::DocumentDB::Context.new url_endpoint, master_keys
> database = Azure::DocumentDB::Database.new context, RestClient
> collection = Azure::DocumentDB::Collection.new context, RestClient
> db_instance = database.list["Databases"][0] # or you can use get if you know the exact _rid
> db_instance_id = db_instance["_rid"]
```

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
> collection.list db_instance_id
=> {"_rid"=>"1BZ1AA==", "DocumentCollections"=>[], "_count"=>0}
```

## Create a Collection for a Database Instance
```
> collection.create db_instance_id, "sample_collection"
=> {"id"=>"sample_collection", "indexingPolicy"=>{"indexingMode"=>"consistent", "automatic"=>true, "IncludedPaths"=>[{"Path"=>"/", "IndexType"=>"Hash", "NumericPrecision"=>3, "StringPrecision"=>3}, {"Path"=>"/"_ts"/?", "IndexType"=>"Range", "NumericPrecision"=>6}], "ExcludedPaths"=>[]}, "_rid"=>"1BZ1AMBZFwA=", "_ts"=>1430919012, "_self"=>"dbs/1BZ1AA==/colls/1BZ1AMBZFwA=/", "_etag"=>""00000100-0000-0000-0000-554a17640000"", "_docs"=>"docs/", "_sprocs"=>"sprocs/", "_triggers"=>"triggers/", "_udfs"=>"udfs/", "_conflicts"=>"conflicts/"}
```

## Get a Collection for a Database Instance
```
> collection_id = "1BZ1AMBZFwA=" # INSERT YOUR COLLECTION ID INSTEAD THIS IS JUST AN EXAMPLE #
> collection.get db_instance_id, collection_id
=> {"id"=>"sample_collection", "indexingPolicy"=>{"indexingMode"=>"consistent", "automatic"=>true, "IncludedPaths"=>[{"Path"=>"/", "IndexType"=>"Hash", "NumericPrecision"=>3, "StringPrecision"=>3}, {"Path"=>"/"_ts"/?", "IndexType"=>"Range", "NumericPrecision"=>6}], "ExcludedPaths"=>[]}, "_rid"=>"1BZ1AMBZFwA=", "_ts"=>1430919012, "_self"=>"dbs/1BZ1AA==/colls/1BZ1AMBZFwA=/", "_etag"=>""00000100-0000-0000-0000-554a17640000"", "_docs"=>"docs/", "_sprocs"=>"sprocs/", "_triggers"=>"triggers/", "_udfs"=>"udfs/", "_conflicts"=>"conflicts/"}
```
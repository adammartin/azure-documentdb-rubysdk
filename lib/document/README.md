# Document

User provides the functionality described in the [MSDN DocumentDB Database REST API description](https://msdn.microsoft.com/en-us/library/azure/dn782247.aspx).

# Example usage

## Instantiation of a document object
```
> require 'documentdb'
>
> url_endpoint = ... # your url address
> master_key = ... # your master_key
>
> context = Azure::DocumentDB::Context.new url_endpoint, master_key
> database = Azure::DocumentDB::Database.new context, RestClient
> collection = Azure::DocumentDB::Collection.new context, RestClient
> db_instance = database.list["Databases"][0] # or you can use get if you know the exact _rid
> db_instance_id = db_instance["_rid"]
> collection.list db_instance_id
> document = Azure::DocumentDB::Document.new context, RestClient, db_instance_id, collection_id
```

## Create a document

```
> sample = {"key"=>"value"}.to_json
> unique_document_identifier = "1"
> document.create unique_document_identifier, sample
=> {"id"=>"1", "key"=>"value", "_rid"=>"1BZ1AMBZFwABAAAAAAAAAA==", "_ts"=>1438895651, "_self"=>"dbs/1BZ1AA==/colls/1BZ1AMBZFwA=/docs/1BZ1AMBZFwABAAAAAAAAAA==/", "_etag"=>""00002100-0000-0000-0000-55c3ce230000"", "_attachments"=>"attachments/"}
```

You can also manage the indexing of a document with a header attribute called IndexingDirective.

The two allowed values are:

Azure::DocumentDB::Documents::Indexing.INCLUDE
Azure::DocumentDB::Documents::Indexing.EXCLUDE

```
> sample = {"key"=>"other_value"}.to_json
> unique_document_identifier = "2"
> document.create unique_document_identifier, sample, Azure::DocumentDB::Documents::Indexing.INCLUDE
=> {"id"=>"2", "key"=>"other_value", "_rid"=>"1BZ1AMBZFwACAAAAAAAAAA==", "_ts"=>1438953906, "_self"=>"dbs/1BZ1AA==/colls/1BZ1AMBZFwA=/docs/1BZ1AMBZFwACAAAAAAAAAA==/", "_etag"=>""00002700-0000-0000-0000-55c4b1b20000"", "_attachments"=>"attachments/"}
```

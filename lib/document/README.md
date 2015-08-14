# Document

User provides the functionality described in the [MSDN DocumentDB Database REST API description](https://msdn.microsoft.com/en-us/library/azure/dn782247.aspx).

# Example usage

## Instantiation of a document object

Document objects are created by the [Azure::DocumentDB::Collection object](/lib/collection)


### Using a master key:

```
> require 'documentdb'
>
> url_endpoint = ... # your url address
> master_key = ... # your master_key
>
> context = Azure::DocumentDB::Context.new url_endpoint, master_key
> database = Azure::DocumentDB::Database.new context, RestClient
> db_instance = database.list["Databases"][0] # or you can use get if you know the exact _rid
> db_instance_id = db_instance["_rid"]
> collection = Azure::DocumentDB::Collection.new context, RestClient, db_instance_id
> collection_rid = collection.list["DocumentCollections"][0]["_rid"]
> document = Azure::DocumentDB::Document.new context, RestClient, db_instance_id, collection_id
```
### Using resource token

```
> require 'documentdb'
>
> url_endpoint = ... # your url address
> master_key = ... # your master_key
> resource_token = ... # your user's resource_token object retrieved from a permission for this collection
>
> context = Azure::DocumentDB::Context.new url_endpoint, master_key
> database = Azure::DocumentDB::Database.new context, RestClient
> db_instance = database.list["Databases"][0] # or you can use get if you know the exact _rid
> db_instance_id = db_instance["_rid"]
> collection = Azure::DocumentDB::Collection.new context, RestClient, db_instance_id
> collection_id = collection.list["DocumentCollections"][0]["_rid"]
> document = Azure::DocumentDB::Document.new context, RestClient, db_instance_id, collection_id, resource_token
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
### IdExistsError

When uploading a document to DocumentDB you have to specify a unique id that becomes part of the document uploaded.  The SDK will do this merge for you automatically.  However if the root element contains an "id" element and if that element does NOT match the Id you are using we have a problem.  Your supplied id does not match an already defined id in the document.  As such the SDK will throw an Azure::DocumentDB::Documents::IdExistsError that you must correct.

```
> sample = {"key"=>"other_value", "id"=>"6"}.to_json
> document.create "5", sample

Azure::DocumentDB::Documents::IdExistsError: Azure::DocumentDB::Documents::IdExistsError
	from lib/document/document.rb:61:in `has_id_mismatch'
	from lib/document/document.rb:34:in `create'
        from ...
```

## List Documents for a collection

```
> document.list
=> {"_rid"=>"1BZ1AMBZFwA=", "Documents"=>[{"id"=>"1", "key"=>"value", "_rid"=>"1BZ1AMBZFwABAAAAAAAAAA==", "_ts"=>1438895651, "_self"=>"dbs/1BZ1AA==/colls/1BZ1AMBZFwA=/docs/1BZ1AMBZFwABAAAAAAAAAA==/", "_etag"=>""00002100-0000-0000-0000-55c3ce230000"", "_attachments"=>"attachments/"}, {"id"=>"2", "key"=>"other_value", "_rid"=>"1BZ1AMBZFwACAAAAAAAAAA==", "_ts"=>1438953906, "_self"=>"dbs/1BZ1AA==/colls/1BZ1AMBZFwA=/docs/1BZ1AMBZFwACAAAAAAAAAA==/", "_etag"=>""00002700-0000-0000-0000-55c4b1b20000"", "_attachments"=>"attachments/"}, {"id"=>"3", "key"=>"a_third_value", "_rid"=>"1BZ1AMBZFwADAAAAAAAAAA==", "_ts"=>1438960856, "_self"=>"dbs/1BZ1AA==/colls/1BZ1AMBZFwA=/docs/1BZ1AMBZFwADAAAAAAAAAA==/", "_etag"=>""00002800-0000-0000-0000-55c4ccd80000"", "_attachments"=>"attachments/"}, {"id"=>"4", "key"=>"other_value", "_rid"=>"1BZ1AMBZFwAEAAAAAAAAAA==", "_ts"=>1438978257, "_self"=>"dbs/1BZ1AA==/colls/1BZ1AMBZFwA=/docs/1BZ1AMBZFwAEAAAAAAAAAA==/", "_etag"=>""00004200-0000-0000-0000-55c510d10000"", "_attachments"=>"attachments/"}, {"id"=>"5", "key"=>"other_value", "_rid"=>"1BZ1AMBZFwAFAAAAAAAAAA==", "_ts"=>1438978376, "_self"=>"dbs/1BZ1AA==/colls/1BZ1AMBZFwA=/docs/1BZ1AMBZFwAFAAAAAAAAAA==/", "_etag"=>""00004300-0000-0000-0000-55c511480000"", "_attachments"=>"attachments/"}], "_count"=>5}
```

## Get a Document using it's id

```
> document_rid = "1BZ1AMBZFwABAAAAAAAAAA=="
> document.get document_rid

=> {"id"=>"1", "key"=>"value", "_rid"=>"1BZ1AMBZFwABAAAAAAAAAA==", "_ts"=>1438895651, "_self"=>"dbs/1BZ1AA==/colls/1BZ1AMBZFwA=/docs/1BZ1AMBZFwABAAAAAAAAAA==/", "_etag"=>""00002100-0000-0000-0000-55c3ce230000"", "_attachments"=>"attachments/"}
```

## Replace a Document

### Without an indexing policy
```
> document_rid = "1BZ1AMBZFwAFAAAAAAAAAA=="
> sample = {"key"=>"new_other_value", "id"=>"5"}.to_json
> document.replace document_rid, "5", sample

=> {"id"=>"5", "key"=>"new_other_value", "_rid"=>"1BZ1AMBZFwAFAAAAAAAAAA==", "_ts"=>1439306014, "_self"=>"dbs/1BZ1AA==/colls/1BZ1AMBZFwA=/docs/1BZ1AMBZFwAFAAAAAAAAAA==/", "_etag"=>""00006103-0000-0000-0000-55ca111e0000"", "_attachments"=>"attachments/"}
```

### With an indexing policy
```
> indexing_policy = Azure::DocumentDB::Documents::Indexing.INCLUDE
> sample = {"key"=>"another_new_other_value", "id"=>"5"}.to_json
> document.replace document_rid, "5", sample, indexing_policy

=> {"id"=>"5", "key"=>"another_new_other_value", "_rid"=>"1BZ1AMBZFwAFAAAAAAAAAA==", "_ts"=>1439307000, "_self"=>"dbs/1BZ1AA==/colls/1BZ1AMBZFwA=/docs/1BZ1AMBZFwAFAAAAAAAAAA==/", "_etag"=>""00006403-0000-0000-0000-55ca14f80000"", "_attachments"=>"attachments/"}
```

## Delete a Document
```
> document_rid = "1BZ1AMBZFwAFAAAAAAAAAA=="
> document.delete document_rid

=> ""
```

## Get uri of the Document resource
```
> document.uri
=> "https://[uri of your documentdb instance]/dbs/1BZ1AA==/colls/1BZ1AMBZFwA=/docs"
```
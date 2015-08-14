# Query

Query provides the functionality described in the [MSDN DocumentDB REST API description](https://msdn.microsoft.com/en-us/library/azure/dn783363.aspx).

# Example usage

## Instantiation of the query object
```
> require 'documentdb'
>
> url_endpoint = ... # your url address
> master_key = ... # your master_key
>
> context = Azure::DocumentDB::Context.new url_endpoint, master_keys
> database = Azure::DocumentDB::Database.new context, RestClient
> db_instance = database.list["Databases"][0] # or you can use get if you know the exact _rid
> db_instance_id = db_instance["_rid"]
> collection = Azure::DocumentDB::Collection.new context, RestClient, db_instance_id
> collection_rid = collection.list["DocumentCollections"][0]["_rid"]
> document = Azure::DocumentDB::Document.new context, RestClient, db_instance_id, collection_id
> query = Azure::DocumentDB::Query.new context, RestClient, Azure::DocumentDB::ResourceType.DOCUMENT, collection_rid, document.uri
```

## Example query
```
> query_string = "select * from docs"
> cq_header = Azure::DocumentDB::CustomQueryHeader.new
> params = Azure::DocumentDB::QueryParameter.new
> query.execute
> response = query.execute query_string, cq_header, params
=> {:header=>{:cache_control=>"no-store, no-cache", :pragma=>"no-cache", :transfer_encoding=>"chunked", :content_type=>"application/json", :server=>"Microsoft-HTTPAPI/2.0", :strict_transport_security=>"max-age=31536000", :x_ms_last_state_change_utc=>"Wed, 12 Aug 2015 02:18:09.732 GMT", :x_ms_item_count=>"3", :x_ms_schemaversion=>"1.1", :x_ms_alt_content_path=>"dbs/TestDb/colls/sample_collection", :x_ms_quorum_acked_lsn=>"13", :x_ms_session_token=>"13", :x_ms_current_write_quorum=>"3", :x_ms_current_replica_set_size=>"4", :x_ms_request_charge=>"2.7", :x_ms_serviceversion=>"version=1.3.16.1", :x_ms_activity_id=>"600ef46b-8149-47ac-a50b-a1877da019d6", :set_cookie=>["x-ms-session-token=13; Domain=had-test.documents.azure.com; Path=/dbs/1BZ1AA==/colls/1BZ1AMBZFwA="], :x_ms_gatewayversion=>"version=1.3.16.1", :date=>"Fri, 14 Aug 2015 11:54:12 GMT"}, :body=>{"_rid"=>"1BZ1AMBZFwA=", "Documents"=>[{"id"=>"1", "key"=>"value", "_rid"=>"1BZ1AMBZFwABAAAAAAAAAA==", "_ts"=>1438895651, "_self"=>"dbs/1BZ1AA==/colls/1BZ1AMBZFwA=/docs/1BZ1AMBZFwABAAAAAAAAAA==/", "_etag"=>""00002100-0000-0000-0000-55c3ce230000"", "_attachments"=>"attachments/"}, {"id"=>"2", "key"=>"other_value", "_rid"=>"1BZ1AMBZFwACAAAAAAAAAA==", "_ts"=>1438953906, "_self"=>"dbs/1BZ1AA==/colls/1BZ1AMBZFwA=/docs/1BZ1AMBZFwACAAAAAAAAAA==/", "_etag"=>""00002700-0000-0000-0000-55c4b1b20000"", "_attachments"=>"attachments/"}, {"id"=>"3", "key"=>"a_third_value", "_rid"=>"1BZ1AMBZFwADAAAAAAAAAA==", "_ts"=>1438960856, "_self"=>"dbs/1BZ1AA==/colls/1BZ1AMBZFwA=/docs/1BZ1AMBZFwADAAAAAAAAAA==/", "_etag"=>""00002800-0000-0000-0000-55c4ccd80000"", "_attachments"=>"attachments/"}], "_count"=>3}}

> response[:header]
=> {:cache_control=>"no-store, no-cache", :pragma=>"no-cache", :transfer_encoding=>"chunked", :content_type=>"application/json", :server=>"Microsoft-HTTPAPI/2.0", :strict_transport_security=>"max-age=31536000", :x_ms_last_state_change_utc=>"Wed, 12 Aug 2015 02:18:09.732 GMT", :x_ms_item_count=>"3", :x_ms_schemaversion=>"1.1", :x_ms_alt_content_path=>"dbs/TestDb/colls/sample_collection", :x_ms_quorum_acked_lsn=>"13", :x_ms_session_token=>"13", :x_ms_current_write_quorum=>"3", :x_ms_current_replica_set_size=>"4", :x_ms_request_charge=>"2.7", :x_ms_serviceversion=>"version=1.3.16.1", :x_ms_activity_id=>"600ef46b-8149-47ac-a50b-a1877da019d6", :set_cookie=>["x-ms-session-token=13; Domain=had-test.documents.azure.com; Path=/dbs/1BZ1AA==/colls/1BZ1AMBZFwA="], :x_ms_gatewayversion=>"version=1.3.16.1", :date=>"Fri, 14 Aug 2015 11:54:12 GMT"}

> response[:body]
=> {"_rid"=>"1BZ1AMBZFwA=", "Documents"=>[{"id"=>"1", "key"=>"value", "_rid"=>"1BZ1AMBZFwABAAAAAAAAAA==", "_ts"=>1438895651, "_self"=>"dbs/1BZ1AA==/colls/1BZ1AMBZFwA=/docs/1BZ1AMBZFwABAAAAAAAAAA==/", "_etag"=>""00002100-0000-0000-0000-55c3ce230000"", "_attachments"=>"attachments/"}, {"id"=>"2", "key"=>"other_value", "_rid"=>"1BZ1AMBZFwACAAAAAAAAAA==", "_ts"=>1438953906, "_self"=>"dbs/1BZ1AA==/colls/1BZ1AMBZFwA=/docs/1BZ1AMBZFwACAAAAAAAAAA==/", "_etag"=>""00002700-0000-0000-0000-55c4b1b20000"", "_attachments"=>"attachments/"}, {"id"=>"3", "key"=>"a_third_value", "_rid"=>"1BZ1AMBZFwADAAAAAAAAAA==", "_ts"=>1438960856, "_self"=>"dbs/1BZ1AA==/colls/1BZ1AMBZFwA=/docs/1BZ1AMBZFwADAAAAAAAAAA==/", "_etag"=>""00002800-0000-0000-0000-55c4ccd80000"", "_attachments"=>"attachments/"}], "_count"=>3}
```
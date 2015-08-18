# Query

Query provides the functionality described in the [MSDN DocumentDB REST API description](https://msdn.microsoft.com/en-us/library/azure/dn783363.aspx).

# Example usage

## Instantiation of the query object

This example is creating a query for documents
```
> require 'documentdb'
>
> url_endpoint = ... # your url address
> master_key = ... # your master_key
>
> context = Azure::DocumentDB::Context.new url_endpoint, master_keys
> database = Azure::DocumentDB::Database.new context, RestClient
> database_name = database.list["Databases"][0]["id"]
> collection = collection = database.collection_for_name database_name
> coll_name = collection.list["DocumentCollections"][0]["id"]
> document = collection.document_for_name coll_name
> query = document.query
```

## Query Response

A query response is a hash formed of up to 3 parts:

Key           | Required |Value
--------------|----------|------------------------------------------------------------------
:header       | Yes      | The response header in case you wish to interrogate the header contents
:body         | Yes      | The result body parsed as a hash
:next_request | No       | Next request if x-ms-continuation was returned as part of the response header

## Example query
```
> qreq = Azure::DocumentDB::QueryRequest.new "select * from root"
> response = query.execute qreq
=> {:header=>{:cache_control=>"no-store, no-cache", :pragma=>"no-cache", :transfer_encoding=>"chunked", :content_type=>"application/json", :server=>"Microsoft-HTTPAPI/2.0", :strict_transport_security=>"max-age=31536000", :x_ms_last_state_change_utc=>"Wed, 12 Aug 2015 00:29:19.776 GMT", :x_ms_item_count=>"3", :x_ms_schemaversion=>"1.1", :x_ms_alt_content_path=>"dbs/TestDb/colls/sample_collection", :x_ms_session_token=>"13", :x_ms_request_charge=>"2.7", :x_ms_serviceversion=>"version=1.3.16.1", :x_ms_activity_id=>"796608ff-eb04-42d1-97d3-94ecc6449824", :set_cookie=>["x-ms-session-token=13; Domain=had-test.documents.azure.com; Path=/dbs/1BZ1AA==/colls/1BZ1AMBZFwA="], :x_ms_gatewayversion=>"version=1.3.16.1", :date=>"Tue, 18 Aug 2015 13:44:23 GMT"}, :body=>{"_rid"=>"1BZ1AMBZFwA=", "Documents"=>[{"id"=>"1", "key"=>"value", "_rid"=>"1BZ1AMBZFwABAAAAAAAAAA==", "_ts"=>1438895651, "_self"=>"dbs/1BZ1AA==/colls/1BZ1AMBZFwA=/docs/1BZ1AMBZFwABAAAAAAAAAA==/", "_etag"=>""00002100-0000-0000-0000-55c3ce230000"", "_attachments"=>"attachments/"}, {"id"=>"2", "key"=>"other_value", "_rid"=>"1BZ1AMBZFwACAAAAAAAAAA==", "_ts"=>1438953906, "_self"=>"dbs/1BZ1AA==/colls/1BZ1AMBZFwA=/docs/1BZ1AMBZFwACAAAAAAAAAA==/", "_etag"=>""00002700-0000-0000-0000-55c4b1b20000"", "_attachments"=>"attachments/"}, {"id"=>"3", "key"=>"a_third_value", "_rid"=>"1BZ1AMBZFwADAAAAAAAAAA==", "_ts"=>1438960856, "_self"=>"dbs/1BZ1AA==/colls/1BZ1AMBZFwA=/docs/1BZ1AMBZFwADAAAAAAAAAA==/", "_etag"=>""00002800-0000-0000-0000-55c4ccd80000"", "_attachments"=>"attachments/"}], "_count"=>3}}

```

## Query Parameters

You can use parameters per the documentation to enhance your queries.

For example if I want to produce the following query body:
```
{
    "query": "select * from docs d where d.id = @id",
    "parameters": [
        {"@id": "newdoc"}
     ]
}
```
You can produce it with the following request.
```
> string_query = "select * from docs d where d.id=@key"
> qreq = Azure::DocumentDB::QueryRequest.new string_query
> qreq.parameters.add "@key", "1"
> response = query.execute qreq

=> {:header=>{:cache_control=>"no-store, no-cache", :pragma=>"no-cache", :transfer_encoding=>"chunked", :content_type=>"application/json", :server=>"Microsoft-HTTPAPI/2.0", :strict_transport_security=>"max-age=31536000", :x_ms_last_state_change_utc=>"Sun, 16 Aug 2015 08:19:00.966 GMT", :x_ms_item_count=>"1", :x_ms_schemaversion=>"1.1", :x_ms_alt_content_path=>"dbs/TestDb/colls/sample_collection", :x_ms_session_token=>"13", :x_ms_request_charge=>"2.22", :x_ms_serviceversion=>"version=1.3.16.1", :x_ms_activity_id=>"d237b2ba-a49e-4f82-8aaf-591203ee911a", :set_cookie=>["x-ms-session-token=13; Domain=had-test.documents.azure.com; Path=/dbs/1BZ1AA==/colls/1BZ1AMBZFwA="], :x_ms_gatewayversion=>"version=1.3.16.1", :date=>"Tue, 18 Aug 2015 13:47:42 GMT"}, :body=>{"_rid"=>"1BZ1AMBZFwA=", "Documents"=>[{"id"=>"1", "key"=>"value", "_rid"=>"1BZ1AMBZFwABAAAAAAAAAA==", "_ts"=>1438895651, "_self"=>"dbs/1BZ1AA==/colls/1BZ1AMBZFwA=/docs/1BZ1AMBZFwABAAAAAAAAAA==/", "_etag"=>""00002100-0000-0000-0000-55c3ce230000"", "_attachments"=>"attachments/"}], "_count"=>1}}
```

## Custom Query Headers

Azure DocumentDB Rest API exposes several header attributes that allow greater control over the query results.

Optional Header    | Method                           | Argument
-------------------|----------------------------------|------------------------------------------------
Max Items Per Page | `query.max_items_per_page count` | `count` - this value must be between 1 and 1000
Continuation Token | `query.continuation_token token` | `token` - the non-nil token returned from response[:header][:x_ms_continuation] of the previous page
Service Version    | `query.service_version version`  | `version` - version of the api service to call.
Enable Scan        | `query.enable_scan scan_bool`    | `scan_bool` - boolean value to tell service to process query if the right index does not exist.
Session Token      | `query.session_token token`      | `token` - session token for the request for consistency purposes

### Example Usage
```
> qreq = Azure::DocumentDB::QueryRequest.new "select * from root"
> qreq.custom_query_header.max_items_per_page 1
> response = query.execute qreq

=> {:header=>{:cache_control=>"no-store, no-cache", :pragma=>"no-cache", :transfer_encoding=>"chunked", :content_type=>"application/json", :server=>"Microsoft-HTTPAPI/2.0", :strict_transport_security=>"max-age=31536000", :x_ms_last_state_change_utc=>"Sun, 16 Aug 2015 08:19:00.966 GMT", :x_ms_item_count=>"1", :x_ms_schemaversion=>"1.1", :x_ms_alt_content_path=>"dbs/TestDb/colls/sample_collection", :x_ms_session_token=>"13", :x_ms_request_charge=>"2.22", :x_ms_serviceversion=>"version=1.3.16.1", :x_ms_activity_id=>"72e89f3e-c069-414c-b87e-692f4573b629", :set_cookie=>["x-ms-session-token=13; Domain=had-test.documents.azure.com; Path=/dbs/1BZ1AA==/colls/1BZ1AMBZFwA="], :x_ms_continuation=>"-RID:1BZ1AMBZFwACAAAAAAAAAA==#RT:1", :x_ms_gatewayversion=>"version=1.3.16.1", :date=>"Tue, 18 Aug 2015 13:49:41 GMT"}, :body=>{"_rid"=>"1BZ1AMBZFwA=", "Documents"=>[{"id"=>"1", "key"=>"value", "_rid"=>"1BZ1AMBZFwABAAAAAAAAAA==", "_ts"=>1438895651, "_self"=>"dbs/1BZ1AA==/colls/1BZ1AMBZFwA=/docs/1BZ1AMBZFwABAAAAAAAAAA==/", "_etag"=>""00002100-0000-0000-0000-55c3ce230000"", "_attachments"=>"attachments/"}], "_count"=>1}, :next_request=>#<Azure::DocumentDB::QueryRequest:0x007f877a064f88 @query_string="select * from root", @custom_query_header=#<Azure::DocumentDB::CustomQueryHeader:0x007f877a064f60 @header_options={"x-ms-documentdb-isquery"=>"True", "Content-Type"=>"application/query+json", "Accept"=>"application/json", "x-ms-max-item-count"=>1, "x-ms-continuation"=>"-RID:1BZ1AMBZFwACAAAAAAAAAA==#RT:1"}, parameters#<Azure::DocumentDB::QueryParameter:0x007f877a064e98 @param_array=[]>}
```

### Pagination

Pagination is managed via an x-ms-continuation token that is returned in the header.  For deep knowledge read the documentation on MSDN's query description.

Example usage

```
> qreq = Azure::DocumentDB::QueryRequest.new "select * from root"
> qreq.custom_query_header.max_items_per_page 1 # Assuming multiple documents you will paginate with the first request
> response = query.execute qreq # First document is returned
> response = query.execute response[:next_request] if response[:next_request] # Second Document is returned

=> {:header=>{:cache_control=>"no-store, no-cache", :pragma=>"no-cache", :transfer_encoding=>"chunked", :content_type=>"application/json", :server=>"Microsoft-HTTPAPI/2.0", :strict_transport_security=>"max-age=31536000", :x_ms_last_state_change_utc=>"Sun, 16 Aug 2015 08:19:00.966 GMT", :x_ms_item_count=>"1", :x_ms_schemaversion=>"1.1", :x_ms_alt_content_path=>"dbs/TestDb/colls/sample_collection", :x_ms_session_token=>"13", :x_ms_request_charge=>"2.22", :x_ms_serviceversion=>"version=1.3.16.1", :x_ms_activity_id=>"1b473fcc-43b8-4d28-b220-27d273f78f33", :set_cookie=>["x-ms-session-token=13; Domain=had-test.documents.azure.com; Path=/dbs/1BZ1AA==/colls/1BZ1AMBZFwA="], :x_ms_continuation=>"-RID:1BZ1AMBZFwADAAAAAAAAAA==#RT:2", :x_ms_gatewayversion=>"version=1.3.16.1", :date=>"Tue, 18 Aug 2015 14:12:16 GMT"}, :body=>{"_rid"=>"1BZ1AMBZFwA=", "Documents"=>[{"id"=>"2", "key"=>"other_value", "_rid"=>"1BZ1AMBZFwACAAAAAAAAAA==", "_ts"=>1438953906, "_self"=>"dbs/1BZ1AA==/colls/1BZ1AMBZFwA=/docs/1BZ1AMBZFwACAAAAAAAAAA==/", "_etag"=>""00002700-0000-0000-0000-55c4b1b20000"", "_attachments"=>"attachments/"}], "_count"=>1}, :next_request=>#<Azure::DocumentDB::QueryRequest:0x007f877a064f88 @query_string="select * from root", @custom_query_header=#<Azure::DocumentDB::CustomQueryHeader:0x007f877a064f60 @header_options={"x-ms-documentdb-isquery"=>"True", "Content-Type"=>"application/query+json", "Accept"=>"application/json", "x-ms-max-item-count"=>1, "x-ms-continuation"=>"-RID:1BZ1AMBZFwADAAAAAAAAAA==#RT:2"}, parameters#<Azure::DocumentDB::QueryParameter:0x007f877a064e98 @param_array=[]>}
```
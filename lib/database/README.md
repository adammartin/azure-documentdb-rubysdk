# Database

Database provides functionality described in the [MSDN DocumentDB Database REST API description](https://msdn.microsoft.com/en-us/library/azure/dn782194.aspx).

# Example usage

## Instantiation of a database object
```
> require 'documentdb'
>
> url_endpoint = ... # your url address
> master_key = ... # your master_key
>
> context = Azure::DocumentDB::Context.new url_endpoint, master_key
> database = Azure::DocumentDB::Database.new context, RestClient
```

## List Document Databases
```
> database.list
=> {"_rid"=>"", "Databases"=>[], "_count"=>0}
```

## Create a Document Database

```
> database.create "NewDatabase"
=> {"id"=>"DatabaseExample", "_rid"=>"fn4ZAA==", "_ts"=>1429304742, "_self"=>"dbs/fn4ZAA==/", "_etag"=>""00000100-0000-0000-0000-553175a60000"", "_colls"=>"colls/", "_users"=>"users/"}
```

## Get a Document Database

```
> database.get "fn4ZAA=="
=> {"id"=>"DatabaseExample", "_rid"=>"fn4ZAA==", "_ts"=>1429304742, "_self"=>"dbs/fn4ZAA==/", "_etag"=>""00000100-0000-0000-0000-553175a60000"", "_colls"=>"colls/", "_users"=>"users/"}
```

## Delete a Document Database
```
> database.delete "fn4ZAA=="
```

## Get uri of the Document Database
```
> database.uri
=> "https://[your uri of your document db instance]/dbs"
```

## Create a Collection Object

You can create an Azure::DocumentDB::Collection object from a Database object using `database_name` or `database_rid`

### Create using database resource id

```
> db_instance_id = database.list["Databases"][0]["_rid"]
=> "1BZ1AA=="
> collection = database.collection_for_rid db_instance_id
=> #<Azure::DocumentDB::Collection:0x007feb0a4a6f80 @context=#<Azure::DocumentDB::Context:0x007feb0c35e978 @endpoint="https://had-test.documents.azure.com:443", @master_token=#<Azure::DocumentDB::MasterToken:0x007feb0c35e950 @master_key="mLg+Dx8tSnnzozD5I2jotTr8FvkI6OSNBmCMwui8U83yxyZvJ2wMHQZjgnvvAfBW7HYJf3xlm/IRjAdRDcWfHw==">, service_version"2015-04-08", rest_clientRestClient, database_id"1BZ1AA==", resource_type"colls", secure_header#<Azure::DocumentDB::SecureHeader:0x007feb0a4a6f58 @token=#<Azure::DocumentDB::MasterToken:0x007feb0c35e950 @master_key="mLg+Dx8tSnnzozD5I2jotTr8FvkI6OSNBmCMwui8U83yxyZvJ2wMHQZjgnvvAfBW7HYJf3xlm/IRjAdRDcWfHw==">, resource_type"colls"
```

### Create using a database name

```
> database_name = "TestDb"
> collection = database.collection_for_name database_name
=> #<Azure::DocumentDB::Collection:0x007feb0a3d07c8 @context=#<Azure::DocumentDB::Context:0x007feb0c35e978 @endpoint="https://had-test.documents.azure.com:443", @master_token=#<Azure::DocumentDB::MasterToken:0x007feb0c35e950 @master_key="mLg+Dx8tSnnzozD5I2jotTr8FvkI6OSNBmCMwui8U83yxyZvJ2wMHQZjgnvvAfBW7HYJf3xlm/IRjAdRDcWfHw==">, service_version"2015-04-08", rest_clientRestClient, database_id"1BZ1AA==", resource_type"colls", secure_header#<Azure::DocumentDB::SecureHeader:0x007feb0a3d07a0 @token=#<Azure::DocumentDB::MasterToken:0x007feb0c35e950 @master_key="mLg+Dx8tSnnzozD5I2jotTr8FvkI6OSNBmCMwui8U83yxyZvJ2wMHQZjgnvvAfBW7HYJf3xlm/IRjAdRDcWfHw==">, resource_type"colls"
```

## Create a Query Object

You can create a query for databases using the Database Object.  See Azure::DocumentDB::Query README.md for explination of usage.

```
> query = database.query
=> #<Azure::DocumentDB::Query:0x007feb0a2da738 @context=#<Azure::DocumentDB::Context:0x007feb0c35e978 @endpoint="https://had-test.documents.azure.com:443", @master_token=#<Azure::DocumentDB::MasterToken:0x007feb0c35e950 @master_key="mLg+Dx8tSnnzozD5I2jotTr8FvkI6OSNBmCMwui8U83yxyZvJ2wMHQZjgnvvAfBW7HYJf3xlm/IRjAdRDcWfHw==">, service_version"2015-04-08", rest_clientRestClient, resource_type"dbs", secure_header#<Azure::DocumentDB::SecureHeader:0x007feb0a2da710 @token=#<Azure::DocumentDB::MasterToken:0x007feb0c35e950 @master_key="mLg+Dx8tSnnzozD5I2jotTr8FvkI6OSNBmCMwui8U83yxyZvJ2wMHQZjgnvvAfBW7HYJf3xlm/IRjAdRDcWfHw==">, resource_type"dbs", parent_resource_id"", url"https://had-test.documents.azure.com:443/dbs"
```
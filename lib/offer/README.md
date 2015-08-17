# Offer

Offer provides the functionality described in the [MSDN DocumentDB Database REST API description](https://msdn.microsoft.com/en-us/library/azure/dn962115.aspx).

# Example usage

## Instantiation of an offer object
```
> require 'documentdb'
>
> url_endpoint = ... # your url address
> master_key = ... # your master_key
>
> context = Azure::DocumentDB::Context.new url_endpoint, master_keys
> offer = Azure::DocumentDB::Offer.new context, RestClient
```

## List Offers
```
> offer.list
=> {"_rid"=>"", "Offers"=>[], "_count"=>0}
```

## Get Offer
```
> offer_id = "qKcE"
> offer.get offer_id
=> {"offerType"=>"S1", "resource"=>"dbs/1BZ1AA==/colls/1BZ1AMBZFwA=/", "offerResourceId"=>"1BZ1AMBZFwA=", "id"=>"qKcE", "_rid"=>"qKcE", "_ts"=>1430919012, "_self"=>"offers/qKcE/", "_etag"=>""00000200-0000-0000-0000-554a17640000""}
```

## Replace Offer
> _NOTE:_ this feature has not been integrated tested yet.  If you use it please let me know that it is working as intended or report any bugs

```
=> new_offer_record =  {"offerType"=>"S2", "resource"=>"dbs/1BZ1AA==/colls/1BZ1AMBZFwA=/", "offerResourceId"=>"1BZ1AMBZFwA=", "id"=>"qKcE", "_rid"=>"qKcE" }
> offer.replace offer_id, new_offer_record

=> {"offerType"=>"S1", "resource"=>"dbs/1BZ1AA==/colls/1BZ1AMBZFwA=/", "offerResourceId"=>"1BZ1AMBZFwA=", "id"=>"qKcE", "_rid"=>"qKcE", "_ts"=>1430919012, "_self"=>"offers/qKcE/", "_etag"=>""00000200-0000-0000-0000-554a17640000""}
```

## Create a Query Object

You can create a query for offers using the Database Object.  See Azure::DocumentDB::Query README.md fo rexplination of usage.

```
query = offer.query
=> #<Azure::DocumentDB::Query:0x007fa7cd32ed18 @context=#<Azure::DocumentDB::Context:0x007fa7ca6f2790 @endpoint="https://had-test.documents.azure.com:443", @master_token=#<Azure::DocumentDB::MasterToken:0x007fa7ca6f2740 @master_key="mLg+Dx8tSnnzozD5I2jotTr8FvkI6OSNBmCMwui8U83yxyZvJ2wMHQZjgnvvAfBW7HYJf3xlm/IRjAdRDcWfHw==">, service_version"2015-04-08", rest_clientRestClient, resource_type"offers", secure_header#<Azure::DocumentDB::SecureHeader:0x007fa7cd32ecf0 @token=#<Azure::DocumentDB::MasterToken:0x007fa7ca6f2740 @master_key="mLg+Dx8tSnnzozD5I2jotTr8FvkI6OSNBmCMwui8U83yxyZvJ2wMHQZjgnvvAfBW7HYJf3xlm/IRjAdRDcWfHw==">, resource_type"offers", parent_resource_id"", url"https://had-test.documents.azure.com:443/offers"
```

## Get URI of the Offer resource
```
> offer.uri
=> "https://[uri of your documentdb instance]/offers"
```
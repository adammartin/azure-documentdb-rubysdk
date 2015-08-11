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

## Replace Offer - PENDING
```
```

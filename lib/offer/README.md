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

## Get Offer - PENDING
```
```

## Replace Offer - PENDING
```
```

## Querying Offers - PENDING
```
```
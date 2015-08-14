# Permission

Permission provides the functionality desrcribed in the [MSDN DocumentDB Database Rest API description](https://msdn.microsoft.com/en-us/library/azure/dn782246.aspx).

# Example usage

## Instantiation of a Permission object

Permission objects are created by the [Azure::DocumentDB::User object](/lib/user)

## List Permissions for a User on a Database
```
> permission.list
=> {"_rid"=>"1BZ1AFzDMAA=", "Permissions"=>[], "_count"=>0}
```

## Create a Permission for a User on a Database for a Resource

A couple of notes.

First there are two types of permission modes "All" and "Read".  "All" grants full CRUD operations while Read only provides standard READ access.  All and Read are represented by `Azure::DocumentDB::Permissions::Mode.ALL` and `Azure::DocumentDB::Permissions::Mode.READ` respectively.

Second the resource link you must pass in is the "_self" designation from a given resource you want permissions applied to.

Third be careful to read the [rules](https://msdn.microsoft.com/en-us/library/azure/dn803932.aspx) on creation to understand what is and is not allowed.  This API is simply a pass through of the requirements.

```
> perm_mode = Azure::DocumentDB::Permissions::Mode.ALL
> collection_resource = "dbs/#{db_instance_id}/colls/#{collection_id}"
> perm_def = Azure::DocumentDB::PermissionDefinition.new "ExamplePermission", perm_mode, collection_resource
> permission.create perm_def

=> {"id"=>"ExamplePermission", "permissionMode"=>"All", "resource"=>"dbs/1BZ1AA==/colls/1BZ1AMBZFwA=", "_rid"=>"1BZ1AFzDMABeWbGCS-8ZAA==", "_ts"=>1438631312, "_self"=>"dbs/1BZ1AA==/users/1BZ1AFzDMAA=/permissions/1BZ1AFzDMABeWbGCS-8ZAA==/", "_etag"=>""00000300-0000-0000-0000-55bfc5900000"", "_token"=>"type=resource&ver=1&sig=CkCYUIZI77hxKsnDc5OPfg==;Oi1wEkvx2ajH5yHJJP67QtvaH3Xi51DIjNNInUJ4+M6tSqh81PcHnptRc3bMsAWMIwwl/hIa7HOfLI9WArc/fAk61pB/a1X1e9+EdNygmVagUVouTMqhDKSlZPEACqgXEwP0jqiMa6eThQ+bkcp0ATM29idYciRGd3oXelSFqrYXd2VKW3uCH3BX3YuLSDAKB+o8nxRCxVStwsSsRrregTcGMVKLonm9OX8iX2rFUrY=;"}
```

## Get a Specific Permission

```
> perm_rid = "1BZ1AFzDMABeWbGCS-8ZAA=="
> permission.get perm_rid

=> {"id"=>"ExamplePermission", "permissionMode"=>"All", "resource"=>"dbs/1BZ1AA==/colls/1BZ1AMBZFwA=", "_rid"=>"1BZ1AFzDMABeWbGCS-8ZAA==", "_ts"=>1438631312, "_self"=>"dbs/1BZ1AA==/users/1BZ1AFzDMAA=/permissions/1BZ1AFzDMABeWbGCS-8ZAA==/", "_etag"=>""00000300-0000-0000-0000-55bfc5900000"", "_token"=>"type=resource&ver=1&sig=ciz2fCxVPCaIlUph7YPhmQ==;GIBUHHaAIB0s5brSP48Pbn9LOtpzZ1oEY0RD93qCZi49wjA5pLAVSymMIG6ZLH5Y1JCLj3XiMUPfpyKF5DYvmeONA1gBo2MvR2BPVGDprjO4woyWvHzkTtBa3Pf5vLIrpz/I+rtcdSDOK3YQFpbxDx9HTvB4XGXjxvR5DsID5dTEbPfBVweftDXrAESktDlhWUUnNFzdhCq4AG6sF4tdY0Zw1Z+IvMgZ+rLD967nbyU=;"}
```
## Get a Resource Token

An Azure::DocumentDB::ResourceToken is an abstraction for the _token that sits in a retrieved permission.

```
> perm_rid = "1BZ1AFzDMABeWbGCS-8ZAA=="
> permission.resource_token perm_rid

=> #<Azure::DocumentDB::ResourceToken:0x007f8f941f1938 @encoded_token="type%3Dresource%26ver%3D1%26sig%3D4782G27WsbB%2FzWghTC2qnA%3D%3D%3BIDDDRF5rUNLZ%2ByZDGz3hRmkhHtpOMyrm7XyVlt%2B4cScFMeCVV1Nn2MjQQ20eT2DEbVk%2BtgTSkWSdzCjXiGdOjBi1l46NRkE7dVQK4Y%2FKzEpsBAURW3qvurGrZlfXPPMoHm3sampfUG2J2XCM4k%2FRJ62ELIOAvg%2FKTj3f7TMGdEb8ICfQZuam4U8USDmaFrym%2Bbf1%2Fk1PjDDDBch2U6t%2F0TdKL%2BjuTce0WEFLxrtIFQA%3D%3B">
```

## Replace a Specific Permission

Here is an example that replaces just the permission name (or "id"). You can replace permission mode or resource just as easily.

```
> perm_rid = "1BZ1AFzDMABeWbGCS-8ZAA=="
> perm = permission.get perm_rid
> new_perm_name = "ExPermission"
> rep_perm = Azure::DocumentDB::PermissionDefinition.new new_perm_name, perm["permissionMode"], perm["resource"]
> permission.replace perm_rid, rep_perm

=> "id"=>"ExPermission", "permissionMode"=>"All", "resource"=>"dbs/1BZ1AA==/colls/1BZ1AMBZFwA=", "_rid"=>"1BZ1AFzDMABeWbGCS-8ZAA==", "_ts"=>1438711483, "_self"=>"dbs/1BZ1AA==/users/1BZ1AFzDMAA=/permissions/1BZ1AFzDMABeWbGCS-8ZAA==/", "_etag"=>""00000100-0000-0000-0000-55c0febb0000"", "_token"=>"type=resource&ver=1&sig=YYkZG3KWvs4qiSaEtIWJMQ==;OYrCdLj6j9u2ht2pvsboOs+VN2IN3eGvwdDMcXmMPevF6lh5MluQdOYR3iNj2p+GbfxTCRiSrpoxUY5Cf1mH30Nf3z4OYE+u5KlnJYWX20tr4hJ0+1TF9DnceX69ET6AEAwVwYjGRiDNIltLKretP5esxjvDANNBk4x6FybItVN1SDS3NfM5bzOq70hWoLAWEduQacbnHy1iTieir1kECIk8uFDGOOh1NMaVAH2JNLI=;"}
```

## Delete a Specific Permission

So long as 204 is returned then you will receive an empty string (this is leaky abstraction from the RestClient api we use.

```
> perm_rid = "1BZ1AFzDMABeWbGCS-8ZAA=="
> permission.delete perm_rid

=> ""
```

## Get uri of the Permission resource
```
> permission.uri
=> "https://[uri of your site]/dbs/1BZ1AA==/users/1BZ1AFzDMAA=/permissions"
```
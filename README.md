# Azure DocumentDB Ruby SDK
[![Build Status](https://travis-ci.org/adammartin/azure-documentdb-rubysdk.svg?branch=v0.2.1)](https://travis-ci.org/adammartin/azure-documentdb-rubysdk)
[![Code Climate](https://codeclimate.com/github/adammartin/azure-documentdb-rubysdk/badges/gpa.svg)](https://codeclimate.com/github/adammartin/azure-documentdb-rubysdk)

Lacking an official ruby SDK I'm going to start building one from my use case perspective.  Please help contribute and grow this project.

# Usage

gem install azure-documentdb-sdk

Require the SDK

`require 'documentdb'`

# Sections

* [Database](/lib/database) - CRUD operations associated to a database.
* [User](/lib/user) - CRUD operations associated to a user.
* [Permission](/lib/permission) - CRUD operations associated to a permission.
* [Collection](/lib/collection) - CRUD operations associated to a collection.
* [Document](/lib/document) - CRUD operations associated to a document.
* [Offer](/lib/offer) - CRUD operations associated to an offer.
* [Query](/lib/query) - object encompassing the execution of a query on an entity.

# Master Key vs Resource Token

Master Key vs Resource Token is an important cooncept this is explained in detail under [Access Control](https://msdn.microsoft.com/en-us/library/azure/dn783368.aspx).

Implementation wise the mechanism these two entities work under has resulted in some details that are important to know and understand.

* Master Token authentication is automatically assumed for all entitites.  It is handled via the application Azure::DocumentDB::Context object.  This is intended to be managed in the constructor of all objects so you don't have to worry about it.
* Resource Token usage is intended to be explicit and when you use it then the operation should fail if authorization fails.  This allows fall back to master token usage to be allowed by your logic rather then the SDK.
* For entities like context that only have some operations that can take a resource token then it was intended that you explicitly call a method with the token.
* For entities that allow all operations to be used with a resource token then the entire entity either uses the resource token or the master key for all operations.

# Errors

API errors will be allowed to bubble up for clarity reasons.  For example supplying the wrong master key will result in a 401 error or a 409 error will result from using a resource token that is not authorized for the requested operation or resource.  These error will be thrown by the [RestClient](https://github.com/rest-client/rest-client) api.

# Development

Install Bundler.

`gem install bundler`

Clone the project.

`bundle install`

To execute tests and run static analysis via [rubocop](https://github.com/bbatsov/rubocop):

`rake`

Coverage can be found in the ./coverage directory

# Docker for development

Build docker.

`docker-compose up -d --build`

Bash in your docker.

`docker exec -it rubysdk bash`

Build your gem version.

`gem build azure-documentdb-sdk.gemspec`

Install your gem version.

`gem install azure-documentdb-sdk-x.x.x.gem`
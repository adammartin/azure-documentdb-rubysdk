FROM ruby:2.6.2
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

RUN mkdir /azure-documentdb-rubysdk
WORKDIR /azure-documentdb-rubysdk

COPY Gemfile /azure-documentdb-rubysdk/Gemfile
COPY Gemfile.lock /azure-documentdb-rubysdk/Gemfile.lock

RUN bundle install
COPY . /azure-documentdb-rubysdk
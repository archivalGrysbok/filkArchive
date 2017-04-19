# Arclight Demo Application

[![Build Status](https://travis-ci.org/sul-dlss/arclight-demo.svg?branch=master)](https://travis-ci.org/sul-dlss/arclight-demo)

To setup the server:

```
bundle install
```

Then, to run the server:

```
bundle exec rake demo:server  # runs both Rails and Solr
bundle exec rake demo:seed    # to load data from data/ead folder
```

## Updating Arclight

To update to a new version of Arclight:

```
bundle update arclight
```

**NOTE** that if the solr configuration or the fixture data changes, you will need to copy those over manually. Same with the arclight generators (e.g., catalog_controller.rb), you will need to run the `arclight:install` again.

## Regenerating the application

In the oft case that we need to rebuild the demo application from scratch, these are the basic steps for regenerating the demo application:

```
rails new arclight-demo -m https://raw.githubusercontent.com/sul-dlss/arclight/master/template.rb
rm -rf solr && cp -r path/to/arclight/solr ./
cp path/to/arclight/spec/fixtures/ead/* ./data/ead/
vi Rakefile # add demo:* tasks
vi .travis.yml # add Travis configuration
```

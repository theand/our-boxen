#!/bin/bash


bundle install --without development --path .bundle
bundle exec librarian-puppet install --path=shared --clean

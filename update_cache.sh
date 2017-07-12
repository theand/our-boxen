#!/bin/bash
set -x


rm -f Gemfile.lock
rm -rf .bundle
bundle install --without development --path .bundle

rm -f Puppetfile.lock
rm -rf .librarian
rm -rf .tmp
rm -rf shared
rm -rf vendor/puppet/cache
librarian-puppet install --path=shared --clean

#!/bin/bash
bundle config set --local path 'vendor/bundle'
bundle install
bundle exec jekyll build
rsync -ahvP _site/ /var/www/html/ --delete --exclude=Covers --exclude=archive
sudo systemctl restart nginx


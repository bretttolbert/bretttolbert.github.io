# frozen_string_literal: true

source "https://rubygems.org"

ruby ">= 3.4.10"

gem "jekyll", "= 4.4.1"

# This is the default theme for new Jekyll sites. You may change this to anything you like.
gem "minima"
gem "jekyll-remote-theme"

# If you want to use GitHub Pages, remove the "gem "jekyll"" above and
# uncomment the line below. To upgrade, run `bundle update github-pages`.
# gem "github-pages", group: :jekyll_plugins

gem "storyblok"
gem "rack-jekyll"

# If you have any plugins, put them here!
group :jekyll_plugins do
   gem "jekyll-feed"
   gem 'jekyll-seo-tag'
   gem "jekyll-relative-links"
end

# Windows and JRuby platforms
install_if -> { RUBY_PLATFORM =~ %r!mingw|mswin|java! } do
  gem "tzinfo", "~> 2.0"
  gem "tzinfo-data"
end

gem "rexml", "~> 3.4"

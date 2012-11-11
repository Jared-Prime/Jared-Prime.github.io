require 'rubygems'
require 'sitemap_generator'

SitemapGenerator::Sitemap.default_host = 'http://www.haiqus.com'
SitemapGenerator::Sitemap.create do
  add '/home', :changefreq => 'weekly', :priority => 0.9
  add '/about', :changefreq => 'weekly'
  add '/index', :changefreq => 'daily'
end
SitemapGenerator::Sitemap.ping_search_engines # called for you when you use the rake task

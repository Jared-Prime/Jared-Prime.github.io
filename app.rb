require 'sinatra'
require 'yaml'
require 'tire'
require 'xml-sitemap'

#Tire.configure { url 'http://g8jpi55h:muc7avs8yhzmzbhl@yew-7190793.us-east-1.bonsai.io' }

get '/' do
  erb :home
end

get '/about' do
  erb :about
end

get '/blog' do
  @articles = Tire.search('articles') { 
    query { all }
    sort { by :date, 'desc' }
  }.results
  erb :index
end

get '/blog/:article' do
  slug = params[:article]
  article = Tire.search('articles') { filter(:and, [{:term => {:slug => slug}}]) }.results.first
  erb :'pages/article', :locals => { :article => article }
end

get '/archives/:article' do
  slug = params[:article]
  article = Tire.search('articles') { filter(:and, [{:term => {:slug => slug}}]) }.results.first
  erb :'pages/article', :locals => { :article => article }, :layout => false
end

get '/bookshelf' do
  links = Tire.search('links',:size => 50) { 
    query { all } 
    sort { by :ts, 'desc' }
  }.results
  erb :bookshelf, :locals => { :links => links }
end

get '/sitemap.xml' do
  map = XmlSitemap::Map.new('haiqus.com') do |m|
    m.add(:url => '/')
    m.add(:url => '/blog', :period => :weekly)
  end
 
  headers['Content-Type'] = 'text/xml'
  map.render
end

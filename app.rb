require 'sinatra'
require 'httparty'
require 'json'
require 'yaml'
require 'rdiscount'

get '/' do
  erb :home
end

get '/about' do
  erb :about
end

get '/index' do
  path = './articles/2012-11-04-my-1up-project.txt'

  Dir['articles/*.txt'].each do |filename|
    File.open( filename, 'r' ) do |f|

      info, html = f.read.split(/---\n/).reject(&:empty?)
      summary = html.slice(/.+\n/)
      {
        :info =>    YAML::load( info ),
        :summary => Markdown.new( summary.to_s.strip ).to_html,
        :html =>    Markdown.new( html.to_s.strip.gsub(/\n/,'') ).to_html
      }

    end
  end

  erb :index
end

get '/bookshelf' do
  erb :bookshelf
end

get '/bitly' do
  content_type :json
  token = '595b595991b04ecf3fb155fb6d3da1952d0c112a'
  user = 'o_6fcrlaophq'
  # get_bundles
  response = HTTParty.get("https://api-ssl.bitly.com/v3/bundle/bundles_by_user?access_token=#{token}&user=#{user}")
  bundles = response['data']['bundles'].select{ |b| b['private'] == false }.map{|b| b['bundle_link'] }

  # get_bundle_contents
  contents = []
  bundles.each_with_index do |bundle,i|
    contents << Thread.new(contents,bundle,i) do
      puts "#{bundle}"
      puts "launching thread at #{Time.now}"
      Thread.current['response'] = HTTParty.get("https://api-ssl.bitly.com/v3/bundle/contents?bundle_link=#{bundle}&bundles=#{user}&access_token=#{token}")
    end
  end
  
  contents.map{ |t| t.join; t['response']['data']['bundle'] }.to_json
end

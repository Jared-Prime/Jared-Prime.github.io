require 'twitter'
require 'tire'

desc "Create a new article."
task :new do
  title = ask('Title: ')
  slug = title.empty?? nil : title.strip.slugize

  article = {'title' => title, 'date' => Time.now.strftime("%d/%m/%Y")}.to_yaml
  article << "\n"
  article << "Once upon a time...\n\n"

  path = "#{Toto::Paths[:articles]}/#{Time.now.strftime("%Y-%m-%d")}#{'-' + slug if slug}.#{@config[:ext]}"

  unless File.exist? path
    File.open(path, "w") do |file|
      file.write article
    end
    toto "an article was created for you at #{path}."
  else
    toto "I can't create the article, #{path} already exists."
  end
end

desc "Last article published"
task :last do
  article = Dir.glob("#{Toto::Paths[:articles]}/*").last
  puts "Filename: #{article}"
end

desc "Publish my blog."
task :publish do
  toto "publishing your article(s)..."
  `git push heroku master`
end

desc "Tweet latest article"
task :tweet do
  twitter = Twitter.configure do |config|
    config.consumer_key = 'eFOyKZLdXS8KTHY8mOLUg'
    config.consumer_secret = '2W67LUnSwkGBoiSEhB7j07bLyYjOSjbld6vjf2LFok'
    config.oauth_token = '491976140-JomBWSmxix93dRFTd7uZPeoIubVrrUE3wepUeneg'
    config.oauth_token_secret = 'YLNEVEuWj4oE2m3DJegNBQhG8SxnMkbzxOW6Qg9d64w'
  end

  articles = Dir.glob("#{Toto::Paths[:articles]}/*")

  puts "Choose an article:\n"
  n = ask("#{articles.each_with_index {|a,i|puts "#{i}: #{a}\n"}}\n")

  article = find_article(n.to_i)
  tweet = build_tweet(article)

  confirm = ask("Do you want to post this tweet? \n #{tweet}\n")

  if ["yes","y"].include? confirm
    puts "tweeting..."
    Twitter.update(tweet)
  else
    puts "canceling tweet"
  end
  
end

namespace :index do
  desc "build brand-new ElasticSearch index from scratch"
  task :build do
    articles = []
    puts "Reading articles..."
    Dir['articles/*.txt'].each_with_index do |filename, i|
      File.open( filename, 'r' ) do |f|
        article = {}
        puts "\tassigning id: #{i + 1}..."
        article[:id] = i + 1
        puts "\t\tparsing YAML..."
        info, html = f.read.split(/---\n/).reject(&:empty?)
        info = YAML::load( info )
        info['date'] = Date.parse(info['date'])
        puts "\t\tcreating summary..."
        summary = html.slice(/.+\n/)
        article[:summary] = summary.to_s.strip,
        article[:content] = html.to_s.strip.gsub(/\n/,'')
        article.merge!(info)
        article.merge!({:type => :article})
        puts "\t\tadding article to collection."
        articles.push(article)
      end
    end

    puts "*************************"
    puts "Starting index rebuild..."
    Tire.index 'articles' do
      puts "\tdelete the old index..."
      delete
      puts "\tcreate the new with mappings..."
      create :mappings => {
        :article => {
          :properties => {
            :id       => { :type => :integer, :index => :not_analyzed },
            :title    => { :type => :string, :boost => 3.0, :analyzer => :standard },
            :date     => { :type => :date, :index => :not_analyzed },
            :summary  => { :type => :string, :boost => 2.0, :analyzer => :standard },
            :content  => { :type => :string, :boost => 1.0, :analyzer => :standard },
            :category => { :type => :string, :analyzer => :keyword }
          }
        }
      }
      puts "\tand import the articles."
      import articles
    end
    puts "Done!"
  end
end

def toto msg
  puts "\n  toto ~ #{msg}\n\n"
end

def ask message
  print message
  STDIN.gets.chomp
end

def find_article(n=-1)
  path = Dir.glob("#{Toto::Paths[:articles]}/*")[n]
  article = YAML::load(File.open(path))
  article['url'] = shorten_url("http://www.haiqus.com#{path.gsub('articles','').gsub('.txt','/')}")

  return article
end

def build_tweet(article)
  tweet =  "#{article['title']} #{article['url']}"
  mention = ask("Mention a user: ")
  tweet << " #{mention}" if !mention.nil? && !mention.empty?
  article['category'].each {|c| tweet << " ##{c}"}

  return tweet
end

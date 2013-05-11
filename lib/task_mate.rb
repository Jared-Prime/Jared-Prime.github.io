require 'rdiscount'
require 'twitter'
require 'tire'
require 'bitly'

module TaskMate

  class Tweet
    def initialize
      Twitter.configure do |config|
        config.consumer_key = 'eFOyKZLdXS8KTHY8mOLUg'
        config.consumer_secret = '2W67LUnSwkGBoiSEhB7j07bLyYjOSjbld6vjf2LFok'
        config.oauth_token = '491976140-JomBWSmxix93dRFTd7uZPeoIubVrrUE3wepUeneg'
        config.oauth_token_secret = 'YLNEVEuWj4oE2m3DJegNBQhG8SxnMkbzxOW6Qg9d64w'
      end
    end

    def build_tweet(article)
      tweet =  "#{article['title']} #{article['url']}"
      mention = ask("Mention a user: ")
      tweet << " #{mention}" if !mention.nil? && !mention.empty?
      article['category'].each {|c| tweet << " ##{c}"}

      return tweet
    end

  end

  def load_articles
    articles = []
    puts "Reading articles..."
    Dir['articles/*.txt'].each_with_index do |filename, i|
      File.open( filename, 'r' ) do |f|
        article = {}
        article[:type] = :article

        puts "\tassigning id: #{i + 1}..."
        article[:id] = i + 1
        
        puts "\t\tparsing YAML..."
        info, content = f.read.split(/---\n/).reject(&:empty?)
        info = YAML::load( info )
        info['date'] = Date.parse(info['date'])
        
        puts "\t\tcreating summary..."
        summary = Markdown.new( content.slice(/.+\n/).to_s.strip ).to_html
        content = Markdown.new( content.to_s.strip ).to_html
        article[:summary] = summary
        article[:content] = content
        article[:slug] = info['title'].gsub(/[^0-9a-z ]/i, '').gsub(/\s/,'-')
        article.merge!(info)
        
        puts "\t\tadding article to collection."
        articles.push(article)
      end
    end
    return articles
  end

  def load_links
    root = 'https://api-ssl.bitly.com/v3/'
    request = 'bundle/bundles_by_user?'
    token = 'access_token=595b595991b04ecf3fb155fb6d3da1952d0c112a'
    user = 'o_6fcrlaophq'
    links = []
    HTTParty.get(root + request + token + '&user=' + user)['data']['bundles'].each do |bundle|
      unless bundle['private']
        links << Thread.new(links,bundle) do
          Thread.current['response'] = HTTParty.get(root + 'bundle/contents?bundle_link=' + bundle['bundle_link'] + '&bundles=' + user + '&' + token)
        end
      end
    end
    links.map! do |t|
      t.join
      t['response']['data']['bundle']
    end
    links.map! do |b|
      b['links'].each do |link|
        link.select! { |k,v| ['title','link','ts','long_url'].include? k }
      end
    end
    return links.flatten!
  end

  def ask message
    print message
    STDIN.gets.chomp
  end

  def get_articles(choice=nil)
    articles = Dir['articles/*.txt']
    if choice
      articles[choice]
    else
      articles
    end
  end

  def choose_article
    which_article = ""
    get_articles.each_with_index {|a,i| which_article += "#{i}: #{a}\n"}
    n = ask(which_article)
    return n
  end

  def find_article
    choice = choose_article
    get_articles(choice)
  end

end

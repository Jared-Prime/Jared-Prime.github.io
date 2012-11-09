require 'toto'
require 'twitter'

@config = Toto::Config::Defaults

task :default => :new

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

  article = Dir.glob("#{Toto::Paths[:articles]}/*").last

  
  
end

def toto msg
  puts "\n  toto ~ #{msg}\n\n"
end

def ask message
  print message
  STDIN.gets.chomp
end


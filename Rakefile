require './lib/task_mate'
include TaskMate

desc "Create a new article."
task :new do
  title = ask('Title: ')
  slug = title.empty?? nil : title.strip.slugize

  article = {'title' => title, 'date' => Time.now.strftime("%d/%m/%Y")}.to_yaml
  article << "\n"
  article << "Once upon a time...\n\n"

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
  puts "Filename: #{article}"
end

namespace :blog do
  desc "Publish my blog."
  task :publish do
    toto "publishing your article(s)..."
    `git push heroku master`
  end

  desc "Tweet latest article"
  task :tweet do
    Tweet.new
    articles = 
    puts "Choose an article:\n"
  end
end

namespace :index do

  desc "build brand-new ElasticSearch index from scratch"
  task :build_articles do
    articles = load_articles
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
            :slug     => { :type => :string, :index => :not_analyzed },
            :title    => { :type => :string, :index => :not_analyzed },
            :date     => { :type => :date, :index => :not_analyzed },
            :summary  => { :type => :string, :index => :not_analyzed },
            :content  => { :type => :string, :index => :not_analyzed },
            :category => { :type => :string, :analyzer => :keyword }
          }
        }
      }
      puts "\tand import the articles."
      import articles
    end
    puts "Done!"
  end

  desc "load images into ElasticSearch"
  task :build_links do
    links = load_links
    Tire.index 'links' do
      puts "\tdelete the old index..."
      delete
      puts "\tcreate the new with mappings..."
      create :mappings => {
        :link => {
          :properties => {
            :id       => { :type => :integer, :index => :not_analyzed },
            :link     => { :type => :string, :index => :not_analyzed },
            :long_url => { :type => :string, :index => :not_analyzed },
            :title    => { :type => :string, :index => :not_analyzed },
            :ts       => { :type => :date, :index => :not_analyzed }
          }
        }
      }
      puts "\tand import the links."
      import links
      puts "Done!"
    end
  end
end

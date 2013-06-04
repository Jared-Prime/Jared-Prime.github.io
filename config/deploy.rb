set :application, "haiqus"
set :repository,  "git@bitbucket.org:haiqus/haiqus.git"
set :scm, "git"
set :user, "jared"
set :group, "jared"
set :ssh_options, { :forward_agent => true }
set :deploy_via, :remote_cache
set :deploy_to, "/var/www/#{application}"
set :use_sudo, true
default_run_options[:pty] = true

role :web, "96.126.114.4"
role :app, "96.126.114.4"

after "deploy:setup", :setup_ownership
task :setup_ownership do
  run "#{sudo} chown -R #{user}:#{group} #{deploy_to} && chmod -R g+s #{deploy_to}"
end

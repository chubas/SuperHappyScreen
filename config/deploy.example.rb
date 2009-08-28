default_run_options[:pty] = true
set :repository,  "git@github.com:chubas/SuperHappyScreen.git"
set :scm, "git"
set :branch, "master"
set :scm_verbose, true

set :user, 'user'
set :domain, 'domain.com'
set :project, 'Super Happy Screen'
set :application, 'sub.domain.com'
set :applicationdir, "/home/#{user}/#{application}"

# deploy config
set :deploy_to, applicationdir
set :deploy_via, :remote_cache

# roles (servers)
role :app, domain
role :web, domain
role :db,  domain, :primary => true

namespace :deploy do
 [:start, :stop, :restart, :finalize_update, :migrate, :migrations, :cold].each do |t|
   desc "#{t} task is a no-op with mod_rails"
   task t, :roles => :app do ; end
 end
end

# additional settings
default_run_options[:pty] = true  # Forgo errors when deploying from windows
#ssh_options[:keys] = %w(/Path/To/id_rsa)            # If you are using ssh_keys
#set :chmod755, "app config db lib public vendor script script/* public/disp*"
set :use_sudo, false

#########################################################################################################

#for use with shared files (e.g. config files)
after "deploy:update_code" do
  #run "ln -s #{shared_path}/database.yml #{release_path}/config"
  #run "ln -s #{shared_path}/environment.rb #{release_path}/config"
end


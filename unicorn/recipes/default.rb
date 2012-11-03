gem_package 'unicorn' do
  gem_binary '/usr/local/bin/gem'
end

directory '/etc/unicorn'

cookbook_file "/etc/init.d/unicorn" do
  source "unicorn_init.sh"
  mode "0755"
end

service "unicorn" do
  supports reload: true, restart: true
  action :enable
end

node["unicorn"]["apps"].each do |app|
  unicorn_app app["name"] do
    rails_env app['rails_env']
    rails_root app['rails_root']
    user node[:system_user]
  end
end

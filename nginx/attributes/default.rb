default[:nginx][:reinstall] = false
default[:nginx][:version] = '1.3.7'
default[:nginx][:prefix] = "/opt/nginx-#{node['nginx']['version']}"

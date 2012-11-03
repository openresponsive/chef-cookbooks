%w{ libc6 libpcre3 libpcre3-dev libpcrecpp0 libssl0.9.8 libssl-dev zlib1g
  zlib1g-dev lsb-base}.each do |pkg|
  package pkg
end

user "www-data" do
  system true
  shell "/bin/false"
end

%w{ /usr/local/nginx/sites-available /usr/local/nginx/sites-enabled }.each do |dirname|
  directory dirname do
    owner "www-data"
    group "vagrant"
    mode "0644"
    recursive true
    action :create
  end
end

nginx_source_path = "/u/sources/nginx-#{node[:nginx][:version]}.tar.gz"

remote_file(nginx_source_path) do
  source "http://nginx.org/download/nginx-#{node[:nginx][:version]}.tar.gz"
  owner "vagrant"
  not_if do
    File.exists?(nginx_source_path)
  end
end

bash "compile_nginx_source" do
  cwd "/u/sources"
  code <<-EOH
    tar zxf nginx-#{node[:nginx][:version]}.tar.gz
    cd nginx-#{node[:nginx][:version]} && ./configure --prefix=/usr/local/nginx --sbin-path=/usr/local/sbin/nginx --with-http_ssl_module --with-http_gzip_static_module
    make && make install
  EOH

  only_if { !File.exists?("/usr/local/sbin/nginx") || node[:nginx][:reinstall] }
end

cookbook_file "/etc/init.d/nginx" do
  source "nginx-init-script"
  mode "0755"
  action :create_if_missing
end

cookbook_file "/usr/local/nginx/conf/nginx.conf" do
  source "nginx.conf"
  mode "0755"
end

service "nginx" do
  supports status: true, restart: true
  action [:enable, :start]
end

package 'libreadline-dev'

# http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p286.tar.gz
ruby_source_path = "/u/sources/ruby-#{node[:ruby][:version]}.tar.gz"

remote_file(ruby_source_path) do
  source "http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-#{node[:ruby][:version]}.tar.gz"
  owner node[:system_user]
  not_if do
    File.exists?(ruby_source_path)
  end
end

bash "install_ruby" do
  cwd "/u/sources"
  code <<-EOH
    tar zxf ruby-#{node[:ruby][:version]}.tar.gz
    cd ruby-#{node[:ruby][:version]} && ./configure
    make && sudo make install
  EOH

  only_if do
    !File.exists?("/usr/local/bin/ruby") || node[:ruby][:reinstall]
  end
end

gem_package 'bundler' do
  gem_binary '/usr/local/bin/gem'
end

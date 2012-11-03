package 'libshadow-ruby1.8'
package 'git-core'
package 'libyaml-dev'
package 'libcurl4-openssl-dev'
package 'vim'
chef_gem 'ruby-shadow'

if node[:system_user] != 'vagrant'
  user node[:system_user] do
    home "/home/#{node[:system_user]}"
    group 'www-data'
    system true
    shell "/bin/bash"
    password "$1$0lpZCZ7q$Ogd3QcaqDj2k3g4Kh3zuO1" # testpass
    supports manage_home: true
  end
end

%w(/u/sources /u/apps).each do |dirname|
  directory dirname do
    owner "vagrant"
    group "www-data"
    mode "0774"
    recursive true
    action :create
  end
end



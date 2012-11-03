package 'postgresql-9.1'
package 'postgresql-client-9.1'
package 'postgresql-server-dev-9.1'
package 'libpq-dev'

service "postgresql" do
  supports :status => true, :restart => true, :reload => true
end

Array(node["postgresql"]["users"]).each do |user|
  pg_user user["username"] do
    privileges :superuser => user["superuser"], :createdb => user["createdb"]
    password user["password"]
  end
end

Array(node["postgresql"]["databases"]).each do |database|
  pg_database database["name"] do
    owner database["owner"]
    locale database["locale"]
  end
end

cookbook_file "/etc/postgresql/9.1/main/postgresql.conf" do
  source "postgresql.conf"
  mode "0644"
  notifies :restart, "service[postgresql]"
end

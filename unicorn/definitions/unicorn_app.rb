define :unicorn_app, :action => :create do
  name = params[:name]
  case params[:action]
  when :create
    parameters = { env: 'production' }.merge(params)
    template "/etc/unicorn/#{name}.conf" do
      mode 0644
      owner  node[:system_user]
      source "unicorn_app.conf.erb"
      variables(parameters)
    end
  when :drop
  end
end


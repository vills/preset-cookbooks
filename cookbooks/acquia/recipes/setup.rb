include_recipe "acquia"
include_recipe "hosts"

hosts "127.0.0.1" do
  action "add"
  host "#{node['web_app']['ui']['domain']}"
end

execute "setup" do
  command "php /tmp/setup.php 'login=#{node['web_app']['ui']['login']}' 'pass=#{node['web_app']['ui']['pass']}' 'email=#{node['web_app']['ui']['email']}' 'domain=#{node['web_app']['ui']['domain']}' 'title=#{node['web_app']['ui']['title']}' 'db_name=#{node['web_app']['system']['name']}' 'db_host=localhost' 'db_login=#{node['web_app']['system']['name']}' 'db_pass=#{node['web_app']['system']['pass']}'"
  action :nothing
end

remote_file "/tmp/setup.php" do
  source "setup.php"
  cookbook "#{node['web_app']['system']['name']}"
  mode 0600
  backup 0
  notifies :run, resources(:execute => "setup"), :immediately
end

file "/tmp/setup.php" do
  action :delete
  backup 0
end

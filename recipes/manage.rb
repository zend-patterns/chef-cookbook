# Restart in zs-manage is restart after 6.2
# restart = Chef::VersionConstraint.new(">= 6.2").include?(node[:zendserver][:version]) ? "restart" : "restart-php"
restart = "restart"

key_name 	 = node[:zendserver][:apikeyname]
key_secret   = node[:zendserver][:apikeysecret]

execute "restart-api" do
  action :nothing
  command "#{node[:zendserver][:zsmanage]} #{restart} -N #{node[:zendserver][:apikeyname]} -K #{node[:zendserver][:apikeysecret]}"
  retries 3
  retry_delay 3
end

execute "restart-api-if-needed" do
  action :nothing
  only_if { is_restart_needed(key_name, key_secret) }
  command "#{node[:zendserver][:zsmanage]} #{restart} -N #{node[:zendserver][:apikeyname]} -K #{node[:zendserver][:apikeysecret]}"
  retries 3
  retry_delay 3
end

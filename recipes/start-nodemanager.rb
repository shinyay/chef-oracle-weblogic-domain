#
# Cookbook Name:: oracle-weblogic-domain
# Recipe:: start-nodemanager
#
# Copyright (c) 2016 Shinya Yanagihara, All Rights Reserved.

# log  "####{cookbook_name}::#{recipe_name} #{Time.now.inspect}: Starting execution phase"
puts "####{cookbook_name}::#{recipe_name} #{Time.now.inspect}: Starting compile phase"

#############################
# Create WLST Script file for starting NodeManager
template "#{node['weblogic-domain']['response_file_dir']}/start_#{node['weblogic-domain']['domain_name']}_nodemanager.py" do
  source "start_nodemanager.py.erb"
  owner node['weblogic-domain']['owner']
  group node['weblogic-domain']['group']
  mode '0755'
end

#############################
# Run wlst and Start NodeManager
execute "wlst.sh start_#{node['weblogic-domain']['domain_name']}_nodemanager.py" do
  environment "CONFIG_JVM_ARGS" => "-Djava.security.egd=file:/dev/./urandom"
  command <<-EOH 
    . #{node['weblogic-domain']['domain_home']}/#{node['weblogic-domain']['domain_name']}/bin/setDomainEnv.sh
    java weblogic.WLST #{node['weblogic-domain']['response_file_dir']}/start_#{node['weblogic-domain']['domain_name']}_nodemanager.py
  EOH
  user node['weblogic-domain']['user']
  group node['weblogic-domain']['group']
  action :run
  creates "#{node['weblogic-domain']['domain_home']}/#{node['weblogic-domain']['domain_name']}/nodemanager/nodemanager.process.lck"
end

# log  "####{cookbook_name}::#{recipe_name} #{Time.now.inspect}: Finished execution phase"
puts "####{cookbook_name}::#{recipe_name} #{Time.now.inspect}: Finished compile phase"

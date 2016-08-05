#
# Cookbook Name:: oracle-weblogic-domain
# Recipe:: create-machine
#
# Copyright (c) 2016 Shinya Yanagihara, All Rights Reserved.

# log  "####{cookbook_name}::#{recipe_name} #{Time.now.inspect}: Starting execution phase"
puts "####{cookbook_name}::#{recipe_name} #{Time.now.inspect}: Starting compile phase"

#############################
# Create WLST Script file for creating domain
template "#{node['weblogic-domain']['response_file_dir']}/create_#{node['weblogic-domain']['domain_name']}_machine.py" do
  source "create_machine.py.erb"
  owner node['weblogic-domain']['owner']
  group node['weblogic-domain']['group']
  mode '0755'
end

#############################
# Run wlst and Create a WLS Domain
execute "wlst.sh create_#{node['weblogic-domain']['domain_name']}_machine.py" do
  environment "CONFIG_JVM_ARGS" => "-Djava.security.egd=file:/dev/./urandom"
  command <<-EOH 
    . #{node['weblogic-domain']['wls_home']}/server/bin/setWLSEnv.sh
    #{node['weblogic-domain']['oracle_common']}/common/bin/wlst.sh #{node['weblogic-domain']['response_file_dir']}/create_#{node['weblogic-domain']['domain_name']}_machine.py
  EOH
  user node['weblogic-domain']['user']
  group node['weblogic-domain']['group']
  action :run
  #creates "#{node['weblogic-domain']['domain_home']}/#{node['weblogic-domain']['domain_name']}/bin"
end

# log  "####{cookbook_name}::#{recipe_name} #{Time.now.inspect}: Finished execution phase"
puts "####{cookbook_name}::#{recipe_name} #{Time.now.inspect}: Finished compile phase"

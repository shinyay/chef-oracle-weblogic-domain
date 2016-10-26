#
# Cookbook Name:: oracle-weblogic-domain
# Recipe:: create
#
# Copyright (c) 2016 Shinya Yanagihara, All Rights Reserved.

# log  "####{cookbook_name}::#{recipe_name} #{Time.now.inspect}: Starting execution phase"
puts "####{cookbook_name}::#{recipe_name} #{Time.now.inspect}: Starting compile phase"

#############################
# Create a Domain Directory
dirs = [
  "#{node['weblogic-domain']['domain_home']}",
  "#{node['weblogic-domain']['domain_home']}/#{node['weblogic-domain']['domain_name']}"
]

dirs.each do |dir|
  directory dir do
    owner node['weblogic-domain']['owner']
    group node['weblogic-domain']['group']
    mode '0755'
  end
end

#############################
# Create WLST Script file for creating domain
template "#{node['weblogic-domain']['response_file_dir']}/create_#{node['weblogic-domain']['domain_name']}_domain.py" do
  source "create_domain.py.erb"
  owner node['weblogic-domain']['owner']
  group node['weblogic-domain']['group']
  mode '0755'
end

#############################
# Run wlst and Create a WLS Domain
execute "wlst.sh create_#{node['weblogic-domain']['domain_name']}_domain.py" do
  environment "CONFIG_JVM_ARGS" => "-Djava.security.egd=file:/dev/./urandom"
  command <<-EOH 
    . #{node['weblogic-domain']['wls_home']}/server/bin/setWLSEnv.sh
    #{node['weblogic-domain']['oracle_common']}/common/bin/wlst.sh #{node['weblogic-domain']['response_file_dir']}/create_#{node['weblogic-domain']['domain_name']}_domain.py
  EOH
  user node['weblogic-domain']['user']
  group node['weblogic-domain']['group']
  action :run
  creates "#{node['weblogic-domain']['domain_home']}/#{node['weblogic-domain']['domain_name']}"/servers
end

# log  "####{cookbook_name}::#{recipe_name} #{Time.now.inspect}: Finished execution phase"
puts "####{cookbook_name}::#{recipe_name} #{Time.now.inspect}: Finished compile phase"

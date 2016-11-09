#
# Cookbook Name:: oracle-weblogic-domain
# Recipe:: create-bootproperties
#
# Copyright (c) 2016 Shinya Yanagihara, All Rights Reserved.

# log  "####{cookbook_name}::#{recipe_name} #{Time.now.inspect}: Starting execution phase"
puts "####{cookbook_name}::#{recipe_name} #{Time.now.inspect}: Starting compile phase"

#############################
# Create a Domain Directory
dirs = [
  "#{node['weblogic-domain']['domain_home']}/#{node['weblogic-domain']['domain_name']}/servers/AdminServer/security"
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
template "#{node['weblogic-domain']['domain_home']}/#{node['weblogic-domain']['domain_name']}/servers/AdminServer/security/boot.properties" do
  source "boot.properties.erb"
  owner node['weblogic-domain']['owner']
  group node['weblogic-domain']['group']
  mode '0755'
end

# log  "####{cookbook_name}::#{recipe_name} #{Time.now.inspect}: Finished execution phase"
puts "####{cookbook_name}::#{recipe_name} #{Time.now.inspect}: Finished compile phase"

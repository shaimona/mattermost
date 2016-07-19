#
# Cookbook Name:: mattermost
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe "postgresql::server"
include_recipe "postgresql::config_initdb"
include_recipe "database::postgresql"

conn_info = {
:host => "localhost",
:username => "postgres",
:password => node['postgresql']['password']['postgres']
}

postgresql_database_user "mmuser" do
  connection conn_info
  password node['mattermost']['database']['password']
  action :create
end

postgresql_database "mattermost" do
  connection conn_info
  action :create
end

postgresql_database_user "mmuser" do
  connection conn_info
  database_name "mattermost"
  privileges [:all]
  action :grant
end

group node['mattermost']['group']
  user node['mattermost']['user'] do
  group node['mattermost']['group']
  system true
  shell '/bin/bash'
end

ark 'mattermost' do
  path node['mattermost']['install_dir']
  url "https://releases.mattermost.com/#{node['mattermost']['version']}/mattermost-team-#{node['mattermost']['version']}-linux-amd64.tar.gz"
  action :put
  owner node['mattermost']['user']
  group node['mattermost']['user']
  mode 00765
end

directory "#{node['mattermost']['install_dir']}/mattermost/data" do
  owner node['mattermost']['user']
  group node['mattermost']['user']
  mode 00765
  recursive true
  action :create
end

template "#{node['mattermost']['install_dir']}/mattermost/config/config.json" do
  source 'config.json.erb'
  owner node['mattermost']['user']
  group node['mattermost']['group']
  mode 00765
end

template '/etc/systemd/system/mattermost.service' do
  source 'mattermost.service.erb'
  owner 'root'
  group 'root'
  mode 00755
end

service 'mattermost' do
  action [:enable, :start]
end

yum_repository 'nginx' do
  description "Nginx repository"
  baseurl "http://nginx.org/packages/rhel/7/$basearch/"
  gpgcheck false
  action :create
end

package 'nginx'

template "#{node['mattermost']['ngnix']['conf_dir']}/default.conf" do
  source 'mattermost.conf.erb'
  owner 'root'
  group 'root'
  mode 00755
end

service 'nginx' do
  action [:enable, :start]
end

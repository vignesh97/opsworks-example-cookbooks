# Copyright 2013 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You may not
# use this file except in compliance with the License. A copy of the License is
# located at
#
#     http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is distributed on
# an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
# or implied. See the License for the specific language governing permissions
# and limitations under the License.
Chef::Log.info("********** enable mod_proxy for apache-tomcat binding *********")
Chef::Log.info("********** File Join #{node['apache']['dir']},'mods-enabled', 'proxy.load' || #{node['tomcat']['apache_tomcat_bind_mod']} !~ /proxy/*********")

execute 'enable mod_proxy for apache-tomcat binding' do
  command '/usr/sbin/a2enmod proxy'
  not_if do
    ::File.symlink?(::File.join(node['apache']['dir'], 'mods-enabled', 'proxy.load')) || node['tomcat']['apache_tomcat_bind_mod'] !~ /\Aproxy/
  end
end

Chef::Log.info("********** enable mod_proxy for apache-tomcat binding *********")
Chef::Log.info("**********  executing command /usr/sbin/a2enmod #{node['tomcat']['apache_tomcat_bind_mod']} *********")

Chef::Log.info("**********  File symlink  #{node['apache']['dir']}, 'mods-enabled', #{node['tomcat']['apache_tomcat_bind_mod']}.load *********")

execute 'enable module for apache-tomcat binding' do
  command "/usr/sbin/a2enmod #{node['tomcat']['apache_tomcat_bind_mod']}"
  not_if {::File.symlink?(::File.join(node['apache']['dir'], 'mods-enabled', "#{node['tomcat']['apache_tomcat_bind_mod']}.load"))}
end


include_recipe 'apache2::service'

Chef::Log.info("********** tomcat thru apache binding *********")
Chef::Log.info("**********  File join   #{node['apache']['dir']}, 'conf.d', #{node['tomcat']['apache_tomcat_bind_config']}*********")

template 'tomcat thru apache binding' do
  path ::File.join(node['apache']['dir'], 'conf.d', node['tomcat']['apache_tomcat_bind_config'])
  source 'apache_tomcat_bind.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  backup false
  notifies :restart, resources(:service => 'apache2')
end
Chef::Log.info("********** Restarting apache2 *********")

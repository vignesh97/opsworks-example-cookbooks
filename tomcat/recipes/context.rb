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

include_recipe 'tomcat::service'

Chef::Log.info("********** Tomcat Context **********")

Chef::Log.info("********** #{node[:deploy]}**********")


node[:deploy].each do |application, deploy|

  Chef::Log.info("********** deploy each loop - application = #{application} , deploy = #{deploy}**********")

  context_name = deploy[:document_root].blank? ? application : deploy[:document_root]
  
  Chef::Log.info("********** context_name = #{context_name}**********")
  Chef::Log.info("**********context file for #{application} (context name: #{context_name})***********")
  Chef::Log.info("***********File Join #{node['tomcat']['catalina_base_dir']}, 'Catalina', 'localhost', #{context_name}.xml}*********")
  Chef::Log.info("*********** Attributes - webapp_name = #{application} , resource_name = #{node['datasources'][context_name]}*********")
  template "context file for #{application} (context name: #{context_name})" do
    path ::File.join(node['tomcat']['catalina_base_dir'], 'Catalina', 'localhost', "#{context_name}.xml")
    source 'webapp_context.xml.erb'
    owner node['tomcat']['user']
    group node['tomcat']['group']
    mode 0640
    backup false
    only_if { node['datasources'][context_name] }
    variables(:resource_name => node['datasources'][context_name], :webapp_name => application)
    notifies :restart, resources(:service => 'tomcat')
  end
end
  Chef::Log.info("*********** Tomcat restart*********")
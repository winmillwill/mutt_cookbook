#
# Cookbook Name:: mutt
# Recipe:: default
#
# Copyright (C) 2012 Will Milton
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

case node["platform"]
when "debian"
  package "mutt-patched"
when "mac_os_x"
  include_recipe 'homebrew'
  package "contacts"
  package "mutt" do
    options "--sidebar-patch"
  end
end

if node["mutt"]["urlview"] then
  package 'urlview'
end

if node["mutt"]["notmuch"] then
  package 'notmuch'
end

home_dir = ENV['HOME']
for_user = ENV['SUDO_USER']

directory "#{home_dir}/.mutt/tmp" do
  owner for_user
  recursive TRUE
end

# TODO: how the fuck am I supposed to template all of this?
template "#{home_dir}/.mutt/muttrc" do
  source "muttrc.erb"
  owner for_user
  variables(
    :alternates => node['mutt']['alternates'] || [node['mutt']['account']],
    :account => node['mutt']['account']
  )
end

cookbook_file "#{home_dir}/.mutt/view_attachment.sh" do
  owner for_user
end
cookbook_file "#{home_dir}/.mutt/mailcap" do
  owner for_user
end

template "#{home_dir}/.urlview" do
  source "urlview.erb"
  owner for_user
  variables(
    :command => node["urlview"]["command"]
  )
end

#
# Cookbook Name:: rails_jge_admin
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

directory '/var/www' do
    mode    '0755'
    owner   'ec2-user'
end
directory '/var/www/jge_sinage' do
    mode    '0755'
    owner   'ec2-user'
end


%w[ ruby-libs ruby ].each do  |pkg|
  package pkg do
    action :purge
  end
end

%w{nodejs}.each do |pkg|
  package pkg do
    version '0.10.21'
    action :install
  end
end

execute "devtools" do
  user "root"
  command 'yum -y groupinstall "Development Tools"'
  action :run
end

%w[ gcc git openssl-devel readline-devel].each do  |pkg|
  package pkg do
    action :install
  end
end

script 'git' do
  interpreter 'bash'
  user 'root'
  code <<-EOS
  git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
  echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
  EOS
end

script 'git2' do
  interpreter 'bash'
  user 'root'
  code <<-EOS
  git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
  ~/.rbenv/bin/rbenv install 2.0.0-p353
  ~/.rbenv/bin/rbenv global 2.0.0-p353
  EOS
end


%w[ nginx ].each do  |pkg|
  package pkg do
    action :install
  end
end

service "nginx" do
  supports :status => true, :restart => true, 
    :reload => true
  action [ :enable, :start ]
end

template "nginx.conf" do 
  path "/etc/nginx/nginx.conf"
  source "nginx.conf.erb"
  owner "ec2-user"
  mode 0644
  notifies :reload, 'service[nginx]'
end


%w[ ruby-devel mongo-10gen mongo-10gen-server].each do  |pkg|
  package pkg do
    action :install
  end
end

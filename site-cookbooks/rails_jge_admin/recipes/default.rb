#
# Cookbook Name:: rails_jge_admin
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
directory '/etc/sudoers.d' do
    mode    '0755'
    owner   'root'
#    group   node['root_group']
end

directory '/var/www' do
    mode    '0755'
    owner   'ec2-user'
end
directory '/var/www/jge_admin' do
    mode    '0755'
    owner   'ec2-user'
end

template "sudoers" do
  source 'sudoers.erb'
  mode   '0440'
  owner  'root'
#  group  node['root_group']
end

%w[ ruby-libs ruby ].each do  |pkg|
  package pkg do
    action :purge
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
=begin
script 'git' do
  interpreter 'bash'
  user 'ec2-user'
  code <<-EOS
  git clone https://github.com/sstephenson/rbenv.git /home/ec2-user/.rbenv
  git clone https://github.com/sstephenson/ruby-build.git /home/ec2-user/.rbenv/plugins/ruby-build
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /home/ec2-user/.bash_profile
  echo 'eval "$(rbenv init -)"' >> /home/ec2-user/.bash_profile
  source /home/ec2-user/.bash_profile
  EOS
end
script 'gitroot' do
  interpreter 'bash'
  user 'root'
  code <<-EOS
  echo 'export RBENV_ROOT="/home/ec2-user/.rbenv"' >> ./.bash_profile
  echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> ./.bash_profile
  source ~/.bash_profile
  EOS
end

script 'git2' do
  interpreter 'bash'
  user 'ec2-user'
  code <<-EOS
  /home/ec2-user/.rbenv/bin/rbenv install 2.0.0-p353
  /home/ec2-user/.rbenv/bin/rbenv global 2.0.0-p353
  EOS
end
  #source /home/ec2-user/.bash_profile
=end

=begin
rootでやるときはこっちがいいかも
export RBENV_ROOT=/usr/local/rbenv
export PATH=${RBENV_ROOT}/bin:${PATH}
git clone git://github.com/sstephenson/rbenv.git ${RBENV_ROOT}
sudo git clone git://github.com/sstephenson/ruby-build.git ${RBENV_ROOT}/plugins/ruby-build
sudo rbenv init -

これを.bash_profileに書き込む
export RBENV_ROOT="/usr/local/rbenv"
export PATH="${RBENV_ROOT}/bin:${PATH}"
eval "$(rbenv init -)"
=end

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


=begin
user_account 'developer' do            
  action :create                        
  ssh_keys  ['ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCuJ5QtApzKx5G1H4/sCFjtQLMHHhyeKJFlScsvtduxq26Yj7HdFVFtfPquRjsEoSjAot/RCtZbVLzq/xxcONjslnOhsfZJewNuEWge/tg5Vr95wTa2u7aWE5mfWGBISJpZxITTfO5DZx7ofLccKolZJ4hUHjW53Zb2N0e7UkqR4bYqYl16cUMQGEugzKKv7D9fgGtuvTFowUyTEVXUahOxYvfHGgAvBppMRaOC3A+EN4okdxggJBIoYGzUsP4PEdfbaHlvkZDysle2UrFeYpj8FslbTrNO6VUkxdW1ziI4vD6rupDk7o44ZYvAbkr+ykjSllF21pMrZjXWvAqZi8uN s.yuichi@gmail.com']
  # authorized_keysはこれで
end
=end


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



#
# Cookbook Name:: rails_jge_admin
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
user_account 'developer' do            # tsuchikazuというユーザを
  action :create                        # 作成するよ
  ssh_keys  ['ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCuJ5QtApzKx5G1H4/sCFjtQLMHHhyeKJFlScsvtduxq26Yj7HdFVFtfPquRjsEoSjAot/RCtZbVLzq/xxcONjslnOhsfZJewNuEWge/tg5Vr95wTa2u7aWE5mfWGBISJpZxITTfO5DZx7ofLccKolZJ4hUHjW53Zb2N0e7UkqR4bYqYl16cUMQGEugzKKv7D9fgGtuvTFowUyTEVXUahOxYvfHGgAvBppMRaOC3A+EN4okdxggJBIoYGzUsP4PEdfbaHlvkZDysle2UrFeYpj8FslbTrNO6VUkxdW1ziI4vD6rupDk7o44ZYvAbkr+ykjSllF21pMrZjXWvAqZi8uN s.yuichi@gmail.com']
  # authorized_keysはこれで
end

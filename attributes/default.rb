
node.set['postgresql']['config']['log_timezone'] = 'UTC'
node.set['postgresql']['config']['timezone'] = 'UTC'

default['mattermost']['user'] = 'mattermost'
default['mattermost']['group'] = 'mattermost'
default['mattermost']['version'] = '3.1.0'
default['mattermost']['install_dir'] = '/opt'

default['mattermost']['ngnix']['conf_dir'] = '/etc/nginx/conf.d'

def random_password
  require 'securerandom'
  SecureRandom.hex
end
normal_unless['mattermost']['database']['password'] = random_password

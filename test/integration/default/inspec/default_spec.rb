# require 'spec_helper'
#
# describe 'mattermost::default' do
#   # Serverspec examples can be found at
#   # http://serverspec.org/resource_types.html
#   it 'does something' do
#     skip 'Replace this with meaningful tests'
#   end
# end

describe package 'postgresql' do
  it { should be_installed}
end

describe service 'postgresql' do
  it { should be_enabled }
  it { should be_running }
end

describe package 'mattermost' do
  it { should be_installed }
end

describe service 'mattermost' do
  it { should be_enabled }
  it { should be_running }
end

describe 'ngnix' do
  it { should be_installed}
end

describe service 'ngnix' do
  it { should be_enabled }
  it { should be_running }
end

describe post 80 do
  it { should be_listening }
end

describe post 8065 do
  it { should be_listening }
end

require 'spec_helper'
describe 'puppet_deluge' do
  context 'with default values for all parameters' do
    it { should contain_class('puppet_deluge') }
  end
end

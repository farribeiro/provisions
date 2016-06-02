require 'spec_helper'
describe 'bootstrap' do

  context 'with defaults for all parameters' do
    it { should contain_class('bootstrap') }
  end
end

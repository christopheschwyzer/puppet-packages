require 'spec_helper'

describe 'jenkins::plugin::github' do

  describe file('/var/lib/jenkins/com.cloudbees.jenkins.GitHubPushTrigger.xml') do
    its(:content) { should match /<oauthAccessToken>foo<\/oauthAccessToken>/ }
  end
end

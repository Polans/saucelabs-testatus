# Add this lines on support/env.rb file for Cucumber project using Selenium-Webdriver

require 'rest_client'

def update_test_status(@browser,result)
  
  user=$CONFIG['user']
  access_key=$CONFIG['access_key']
  session=@browser.instance_variable_get(:@bridge).session_id
  http = "https://saucelabs.com/rest/v1/#{user}/jobs/#{session}"
  body = {"passed" => result}.to_json

  RestClient::Request.execute(
      :method => :put,
      :url => http,
      :user => user,
      :password => access_key,
      :headers => {:content_type => "application/json"},
      :payload => body)
end


After do |scenario|
  if scenario.failed?
    passed=false
  else
    passed=true
  end
  
  update_test_status(@browser,passed)

end

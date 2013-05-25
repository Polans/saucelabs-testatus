# Add this lines on support/env.rb file for Cucumber project using Capybara

require 'rest_client'

def update_test_status(page,result)
  
  user=$CONFIG['user']
  access_key=$CONFIG['access_key']
  session=page.driver.browser.driver.instance_variable_get(:@bridge).session_id #using Capybara
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
  
  update_test_status(page,passed)

end

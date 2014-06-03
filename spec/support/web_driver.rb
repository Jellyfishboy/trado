RSpec.configure do |config|
  config.before :suite, js: :true do
      if ENV['FF'] == 'true' # in case you wanna run it with selenium
        require 'selenium-webdriver'
      else
        require 'capybara/poltergeist'
        Capybara.register_driver :poltergeist do |app|
          Capybara::Poltergeist::Driver.new(app, {
            js_errors: true,
            inspector: true,
            phantomjs_options: ['--load-images=no', '--ignore-ssl-errors=yes'],
            timeout: 120
          })
        end
      end
  end


  config.before :each, js: :true do
    Capybara.current_driver = ENV['FF'] == 'true' ? Capybara.javascript_driver : :poltergeist
  end
end
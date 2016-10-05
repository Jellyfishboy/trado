RSpec.configure do |config|
  config.before :each, js: :true do
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

  config.before :each, js: :true do
    Capybara.current_driver = :poltergeist
  end
end
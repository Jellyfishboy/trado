RSpec.configure do |config|

  # Before running the test suite, clear the test database completely.
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  # Sets the default database cleaning strategy to be transactions. Transactions are alot faster.
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  # Only runs on examples which have been flagged with ':js => true'. Used for capybara and selenium for integration testing. These types of tests wont
  # work with transactions, so sets the database strategy as truncation.
  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  # Need to set app feature specs as truncaton strategy, as transaction does not reset the primary key for the Shipatron4000::tier method spec
  config.before(:each, type: :feature) do
    DatabaseCleaner.strategy = :truncation
  end

  # Execute the aforementioned cleanup strategy before and after.
  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end
require 'sunspot/rails/spec_helper'

RSpec.configure do |config|

    # Stub out SOLR during test
  config.before(:each) do
    ::Sunspot.session = ::Sunspot::Rails::StubSessionProxy.new(::Sunspot.session)
  end

  config.after(:each) do
    ::Sunspot.session = ::Sunspot.session.original_session
  end

end
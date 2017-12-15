require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def assert_model_creation_failure model_name='', object_parameters={}
    model_creation model_name, object_parameters, 0
  end

  def assert_model_creation_success model_name='', object_parameters={}
    model_creation model_name, object_parameters, +1
  end

  def model_creation model_name='', object_parameters={}, difference=0
    assert_difference "#{model_name.capitalize}.count", difference do
      post send("#{model_name.downcase.pluralize}_new_path"), params: object_parameters
    end
  end
end

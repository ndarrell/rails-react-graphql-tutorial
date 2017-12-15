require 'test_helper'

class YetiTest < ActiveSupport::TestCase
  def setup
    @minimum_valid_yeti = Yeti.new(name: 'new yeti',
                                       email: 'foo@example.com',
                                       password: 'abc123',
                                       password_confirmation: 'abc123')
  end

  test 'new yeti is valid with only name, email, and password' do
    assert @minimum_valid_yeti.valid?
  end

  test 'new yeti is invalid without a name' do
    invalid_member = invalidate_model_by_field @minimum_valid_yeti, :name
    assert_not invalid_member.valid?
  end

  test 'new yeti is invalid without an email' do
    invalid_member = invalidate_model_by_field @minimum_valid_yeti, :email
    assert_not invalid_member.valid?
  end

  test 'new yeti is invalid without a password' do
    invalid_member = invalidate_model_by_field @minimum_valid_yeti, :password
    assert_not invalid_member.valid?
  end

  test 'new yeti is invalid without a correct password confirmation' do
    invalid_member = invalidate_model_by_field @minimum_valid_yeti, :password_confirmation
    assert_not invalid_member.valid?
  end

  test 'new yeti is invalid without a password and confirmation' do
    invalid_member = invalidate_model_by_field @minimum_valid_yeti, [:password, :password_confirmation]
    assert_not invalid_member.valid?
  end

  def invalidate_model_by_field object=nil, attributes
    throw if object.nil?

    attributes = [] << attributes unless attributes.is_a? Array
    attributes.map { |a| a = a.to_sym unless a.is_a? Symbol  }

    invalid_object = object

    attributes.each do |a|
      invalid_object.send(a).chomp!(invalid_object.send(a))
    end

    invalid_object

  end
end

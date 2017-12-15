require 'test_helper'

class YetisControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get yetis_new_url
    assert_response :success
  end

  test "should get create" do
    get yetis_create_url
    assert_response :success
  end

  test 'should rerender the same page when new member is invalid and not created' do
    assert_model_creation_failure 'yeti', yeti: { name: 'Foo Bar' }
    assert_response :success
  end

  test 'should be able to create a new yeti' do
    assert_model_creation_success(
      'yeti',
      { yeti: { name: 'Awesome League', email: 'yeti@example.com'} }
    )
    assert_response :success
  end

  test 'should go to root when new yeti is valid and created' do
    post yetis_new_path, params: {
      yeti: {
        name: 'Foo Bar',
        email: 'foobar@example.com',
        password: 'P@ssword1!' } }
    assert_redirected_to root_url
  end

  test "should get index" do
    get yetis_index_url
    assert_response :success
  end

end

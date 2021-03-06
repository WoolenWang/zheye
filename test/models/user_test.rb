class UserTest < ActiveSupport::TestCase
  test "should create user" do
    user = User.new(login: "tester1", password: "password", password_confirmation: "password")
    user.save
    assert_equal user.errors.full_messages, []
    assert_equal user.crypted_password, user.password_salt, user.persistence_token
  end

  test "shouldn't create user with same login" do
    user = User.new(login: "tester", password: "password", password_confirmation: "password")
    user.save
    assert_equal user.errors.full_messages, ["Login has already been taken"]
  end

  test "shouldn't create user with wrong password" do
    user = User.new(login: "tester1", password: "password", password_confirmation: "password2")
    user.save
    assert_equal user.errors.full_messages, ["Password confirmation doesn't match Password"]
  end

end

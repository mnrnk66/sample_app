require 'spec_helper'

describe User do

  before do
    @user = User.new(name: "Test User", email: "user@sigmix.com") 
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }

  it { should be_valid }

# nameが空のときはエラー
  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

# emailが空のときはエラー
  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

# nameの文字列の長さが51文字以上はエラー
  describe "when name is too long" do
    before { @user.name = 'a' * 51 }
    it { should_not be_valid }
  end

# emailの形式が無効
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

# emailの形式が有効
  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

# emailが重複するときはエラーera-
  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

end

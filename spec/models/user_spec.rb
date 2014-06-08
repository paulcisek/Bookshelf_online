require 'rails_helper'

describe User do
  let(:user) { FactoryGirl.create(:user)}

  it { is_expected.to respond_to(:admin) }
  it { is_expected.to respond_to(:books) }
  it { is_expected.not_to be_admin }

  describe "User validation" do
    it "has valid factory" do
      expect(user).to be_valid
    end
  end
  describe "With admin attribute set to true" do
    it "should be admin" do
      @user = user
      @user.toggle!(:admin)
      expect(@user).to be_admin
    end
  end
  describe "user associations" do
    it "should recognise when user has no books" do
      expect(user.books.count).to  eq(0)
    end
    it "should recognise when user has a book" do
      user.books << FactoryGirl.create(:book)
      expect(user.books.count).to  eq(1)
    end
  end
end
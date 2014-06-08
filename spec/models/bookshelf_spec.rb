require 'rails_helper'

describe Bookshelf do
  let(:bookshelf) { FactoryGirl.create(:bookshelf)}

  it { is_expected.to respond_to(:books) }
  it { should have_many(:books) }

  describe "Bookshelf validation" do
    it "has valid factory" do
      expect(bookshelf).to be_valid
    end
  end
end
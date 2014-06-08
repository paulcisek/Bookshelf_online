require 'rails_helper'

describe Book do
  let(:book) { FactoryGirl.create(:book)}

  it { is_expected.to respond_to(:title) }
  it { is_expected.to respond_to(:author) }
  it { is_expected.to respond_to(:photo_data) }
  it { is_expected.to respond_to(:filename) }
  it { is_expected.to respond_to(:mime_type) }
  it { is_expected.to respond_to(:users)}
  it { should belong_to(:bookshelf)}

  describe "book validation" do
    it "fails validation with no title" do
      book.title = nil
      expect(book).to have(1).error_on(:title)
    end
    it "fails validation with no author" do
      book.author = nil
      expect(book).to have(1).error_on(:author)
    end
    it "fails validation with no photo" do
      book.photo_data = nil
      expect(book).to have(1).error_on(:photo_data)
    end
    it "fails validation with not unique title" do
      book1 = Book.create(title: "same", author: "author", photo_data: "data")
      book2 = Book.create(title: "same", author: "author", photo_data: "data")
      expect(book2).to have(1).error_on(:title)
    end
    it "has valid factory" do
      expect(book).to be_valid
    end
  end
  describe "book associations" do
    it "should recognise when book has no users" do
      expect(book.users.count).to  eq(0)
    end
    it "should recognise when book has an user" do
      book.users << FactoryGirl.create(:user)
      expect(book.users.count).to  eq(1)
    end
  end
end
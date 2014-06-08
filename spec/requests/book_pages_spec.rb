require 'rails_helper'

describe "BookPages" do

  shared_examples_for "all book pages" do
    describe "pagination" do
      before do
        @bookshelf = FactoryGirl.create(:bookshelf)
        31.times do
          @bookshelf.books << FactoryGirl.create(:book)
        end
        visit admin_path
      end
      it "should have pagination div" do
        expect(page).to have_selector("div.pagination")
      end
    end
    it "should have table for books" do
      expect(page).to have_selector("table")
    end
    it "should not have pagination div with no books" do
      expect(page).not_to have_selector("div.pagination")
    end
  end

  describe "Admin page" do
    before(:each) do
      visit admin_path
    end
    it_should_behave_like "all book pages"
    it "should have Books Page link" do
      expect(page).to have_link("Books Page")
    end

    it "should have 'Books' content" do
      expect(page).to have_content("Books")
    end
    it "should not have pagination div with no books" do
      expect(page).not_to have_selector("div.pagination")
    end
    it "should have 'Add Book' content" do
      expect(page).to have_content("Books")
    end
    it "should have form for adding books" do
      expect(page).to have_selector("form.new_book")
      expect(page).to have_field("book_title")
      expect(page).to have_field("book_author")
      expect(page).to have_field("book_photo_data")
    end
    it "should have button Add Book" do
      expect(page).to have_button('Add Book')
    end

    describe "book table" do
      before do
        @bookshelf = FactoryGirl.create(:bookshelf)
        @book = FactoryGirl.create(:book)
        @bookshelf.books << @book
        @bookshelf.save!
        visit admin_path
      end
      it "should have row with book" do
        expect(page).to have_selector("tr#bookID_#{@book.id}")
        expect(page).to have_selector("img")
        expect(page).to have_content(@book.title)
        expect(page).to have_content(@book.author)
      end
      it "should have delete link for book" do
        expect(page).to have_link("Delete")
      end
      describe "delete link for book" do
        before do
          click_link "Delete"
        end
        it "should remove book from table" do
          expect(page).not_to have_selector("tr#bookID_#{@book.id}")
          expect(page).not_to have_selector("img")
          expect(page).not_to have_content(@book.title)
          expect(page).not_to have_content(@book.author)
          expect(page).not_to have_link("Delete")
        end
      end
    end
  end
  describe "User page" do
    before(:each) do
      @admin = FactoryGirl.create(:admin)
      @user = FactoryGirl.create(:user)
      visit bookshelf_path id: @user.id
    end
    it_should_behave_like "all book pages"

    it "should have Administration Page link if user is Admin" do
      visit bookshelf_path id: @admin.id
      expect(page).to have_link("Administration Page")
    end
    it "should not have Administration Page link" do
      expect(page).not_to have_link("Administration Page")
    end
    it "should have 'Books available' content" do
      expect(page).to have_content("Books available")
    end
    it "should have 'Books Owned' content" do
      expect(page).to have_content("Books Owned")
    end
    describe "Books available table" do
      before do
        @bookshelf = FactoryGirl.create(:bookshelf)
        @book = FactoryGirl.create(:book)
        @bookshelf.books << @book
        @bookshelf.save!
        visit bookshelf_path id: @user.id
      end
      it "should have row with book" do
        expect(page).to have_selector("tr#bookID_#{@book.id}")
        expect(page).to have_selector("img")
        expect(page).to have_content(@book.title)
        expect(page).to have_content(@book.author)
      end
      it "should have Add To Collection link for book" do
        expect(page).to have_link("Add To Collection")
      end
      describe "Add To Collection and Remove From Collection link for book" do
        before do
          click_link "Add To Collection"
          visit bookshelf_path id: @user.id
        end
        it "Add To Collection should put book to Book Owned table" do
          expect(page).to have_selector("tbody#bookshelf-owned tr#bookID_#{@book.id}")
          expect(page).to have_link("Remove From Collection")
        end
        it "Remove From Collection should remove book from Book Owned table" do
          click_link "Remove From Collection"
          visit bookshelf_path id: @user.id
          expect(page).not_to have_selector("tbody#bookshelf-owned tr#bookID_#{@book.id}")
          expect(page).not_to have_link("Remove From Collection")
        end
      end
    end
  end
end
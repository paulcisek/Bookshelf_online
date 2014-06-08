require 'rails_helper'

describe BooksController do

  let(:bookshelf) { FactoryGirl.create(:bookshelf) }
  let(:book) {FactoryGirl.create(:book) }
  let(:user) { FactoryGirl.create(:user)}

  describe "GET #new"  do
    it "always creates or finds bookshelf" do
      get :new
      expect(assigns(:bookshelf)).not_to be_nil
    end
    it "loads all books in the bookshelf" do
      bookshelf.books << book
      get :new
      expect(assigns(:books)).to match_array([book])
    end

    it "assign empty array if books doesnt exist" do
      get :new
      expect(assigns(:books)).to match_array([])
    end

    it "assigns new book" do
      get :new
      expect(assigns(:book)).to be_a_new(Book)
    end


  end
  describe "GET #show" do
    it "always creates or finds bookshelf" do
      get :show, id: 1
      expect(assigns(:bookshelf)).not_to be_nil
    end
    it "always creates or finds user" do
      get :show, id: 1
      expect(assigns(:user)).not_to be_nil
    end
  end

  describe "POST #create" do
    it "should create a book" do
      expect do
        xhr :post, :create, book: { title: book.title, author: book.author }
      end.to change(Book, :count).by(1)
    end
    it "always creates or finds bookshelf" do
      post :create, book: { title: book.title, author: book.author }
      expect(assigns(:bookshelf)).not_to be_nil
    end
  end

  describe "POST #destroy" do
    it "should delete a book" do
      book.save!
      expect do
        xhr :post, :destroy, id: book.id
      end.to change(Book, :count).by(-1)
    end
    it "always finds a book with id" do
      xhr :post, :destroy, id: book.id
      expect(assigns(:book)).not_to be_nil
    end
  end

  describe "POST #add_to_collection" do
    it "always finds a book and user with id" do
      xhr :post, :add_to_collection, id: book.id, user_id: user.id
      expect(assigns(:book)).not_to be_nil
      expect(assigns(:user)).not_to be_nil
    end
    it "add books to user.books if it was not there" do
      xhr :post, :add_to_collection, id: book.id, user_id: user.id
      expect(user.books.length).to eq(1)
    end
  end

  describe "POST #remove_from_collection" do
    before (:each)do
      @user = user
      @book = book
      @user.books << @book
      @user.save!
    end
    let(:book_from_user) do
      @user.books.find(@book)
    end
    it "removes book from user.books if it was there" do
      expect(@user.books.length).to eq(1)
      xhr :post, :remove_from_collection, id: book_from_user.id, user_id: user.id
      @user = User.find(user.id)
      expect(@user.books.length).to eq(0)
    end
    it "always finds a book and user with id" do
      xhr :post, :remove_from_collection, id: book.id, user_id: user.id
      expect(assigns(:book)).not_to be_nil
      expect(assigns(:user)).not_to be_nil
    end

  end
end
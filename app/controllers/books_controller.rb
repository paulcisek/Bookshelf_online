class BooksController < ApplicationController
  def new
    @bookshelf = Bookshelf.first_or_create
    @book = Book.new
    @books = @bookshelf.books
    @books = Book.paginate(:page => params[:page], :per_page => 5)
    # if(params[:user_id])
  end

  def show #'/bookshelves/USER_:id'
    @bookshelf = Bookshelf.first_or_create
    @books = @bookshelf.books


    if User.exists?(params[:id])
      @user = User.find(params[:id])

    else
      @user = User.create(id: params[:id])
    end

    @books = Book.paginate(:page => params[:page], :per_page => 5)
  end

  def create
    @bookshelf = Bookshelf.first_or_create
    @book = @bookshelf.books.new(book_params) do |f|
          if (params[:book][:photo_data])
            f.photo_data = params[:book][:photo_data].read
            f.filename = params[:book][:photo_data].original_filename
            f.mime_type = params[:book][:photo_data].content_type
          end
        end
    @books = @bookshelf.books
    @books = Book.paginate(:page => params[:page], :per_page => 5)
    respond_to do |format|
      if @book.save
        format.html { redirect_to new_book_path, notice: 'Book was successfully created.' }
        format.js   {}
      else
        format.html { render :new }
        format.js { render action: 'invalid_create' }
      end
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    respond_to do |format|
      if @book.destroyed?
        format.html { redirect_to new_book_path, notice: 'Book was successfully deleted.' }
        format.js   {}
      else
        format.html { render action: "new" }
      end
    end
  end

  def show_image
    @book = Book.find(params[:id])
    send_data(@book.photo_data, :type => @book.mime_type, :filename => "#{@book.filename}", :disposition => "inline")
  end

  def add_to_collection
    @book = Book.find(params[:id])
    @user = User.find(params[:user_id])
    if(!@user.books.exists?(@book))
      @user.books << @book
    end
    respond_to do |format|
      if @user.books.exists?(@book)
        format.html { redirect_to new_book_path, notice: 'Book was successfully added.' }
        format.js   {}
      else
        format.html { render action: "show" }
      end
    end
  end

  def remove_from_collection
    @book = Book.find(params[:id])
    @user = User.find(params[:user_id])
    @user.books.delete(@book)
    respond_to do |format|
      if !@user.books.exists?(@book)
        format.html { redirect_to new_book_path, notice: 'Book was successfully removed.' }
        format.js   {}
      else
        format.html { render action: "show" }
      end
    end
  end

  private

  def book_params
    params.require(:book).permit(:title, :author)
  end
end

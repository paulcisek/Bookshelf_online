class CreateBooksUsers < ActiveRecord::Migration
  def change
    create_table :books_users, id: false do |t|
      t.belongs_to :user
      t.belongs_to :book
    end
  end
end

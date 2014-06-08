class ChangeBooksAddBelongsToBookshelf < ActiveRecord::Migration
  def up
    change_table :books do |t|
      t.belongs_to :bookshelf
    end
  end
end

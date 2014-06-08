class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.string :filename
      t.string :mime_type
      t.binary :photo_data


      t.timestamps
    end
  end
end

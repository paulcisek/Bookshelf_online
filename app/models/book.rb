class Book < ActiveRecord::Base
  has_and_belongs_to_many :users
  belongs_to :bookshelf
  validates_presence_of :title, :author, :photo_data
  validates_uniqueness_of :title
end

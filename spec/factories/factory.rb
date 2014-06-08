FactoryGirl.define do
  factory :book do
    sequence(:title) {|n| "Book_#{n}"}
    sequence(:author) {|n| "Author_#{n}"}
    filename "filename"
    photo_data "data"
    mime_type "png"
  end
  factory :user do
    admin false
    factory :admin do
      admin true
    end
  end
  factory :bookshelf do

  end
end
class Profile < ActiveRecord::Base
  belongs_to :user
  belongs_to :programming_language
end

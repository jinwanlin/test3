class SearchHistory < ActiveRecord::Base
  belongs_to :user
  attr_accessible :keywords, :user, :user_id, :has_result
end

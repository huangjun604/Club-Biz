class Membership < ActiveRecord::Base
	belongs_to :user
	belongs_to :society
	validates :user_id, presence: true
	validates :society_id, presence: true
end

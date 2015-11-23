class Announcement < ActiveRecord::Base
	belongs_to :society
	default_scope -> { order('created_at DESC') }
	validates :content, presence: true
	validates :society_id, presence: true
end

class Comment < ActiveRecord::Base
	belongs_to :user, class_name: User
	belongs_to :event, class_name: Event
	default_scope -> { order('created_at DESC') }
	validates :content, presence: true, length: { maximum: 140 }
	validates :user_id, presence: true
	validates :event_id, presence: true
end

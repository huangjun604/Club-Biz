class Event < ActiveRecord::Base
	belongs_to :society
	has_many :tickets
	has_many :comments
	has_many :users, through: :tickets
	has_many :users, through: :comments
	validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
	validates :date, presence: true
	validates :ticketnum, presence: true
	validates :description, presence: true
	validates :image_data, presence: true
	validates :image_filename, presence: true
	validates :image_type, presence: true

	def updateNum(ticketnum)
		self.update(ticketnum: ticketnum)
	end
end

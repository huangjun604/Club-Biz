class Society < ActiveRecord::Base
	has_many :events
	has_many :announcements
	has_many :memberships, dependent: :destroy
	has_many :users, through: :memberships
	before_save { self.s_name = s_name.downcase }
	before_save { self.catalogue = catalogue.downcase }
	before_save { self.website = website.downcase }
	validates :s_name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
	validates :regnum, presence: true, uniqueness: true
	validates :catalogue, presence: true
	validates :website, presence: true, uniqueness: { case_sensitive: false }
	validates :description, presence: true
end

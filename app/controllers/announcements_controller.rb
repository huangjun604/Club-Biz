class AnnouncementsController < ApplicationController
	before_action :has_permission, only: [:create, :destroy]

	def create
		@society = Society.find(params[:announcement][:society_id])
		@announcement = Announcement.new(announcement_params)
		if @announcement.save
			redirect_to @society, notice: 'You have successfully added an announcement!'
		else
			redirect_to @society, notice: 'Error. Content is Empty.'
		end
	end

	def destroy
		@announcement = Announcement.find(params[:id])
		@society = Society.find(@announcement.society_id)
		@announcement.destroy
		redirect_to @society, notice: 'You have deleted an announcement.'
	end

	private
	def announcement_params
		params.require(:announcement).permit(:society_id, :content)
	end

	def has_permission
		if params[:id]
			@announcement = Announcement.find(params[:id])
			@society = Society.find(@announcement.society_id)
		else
			@society = Society.find(params[:announcement][:society_id])
		end
		@membership = Membership.find_by(society_id: @society.id, user_id: current_user.id)
		redirect_to(root_path) unless (@membership.isadmin)
	end
end
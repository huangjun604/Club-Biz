class CommentsController < ApplicationController
	before_action :has_permission, only: [:destroy]

	def create
		@event = Event.find(params[:comment][:event_id])
		@comment = Comment.new(comment_params)
		if @comment.save
			redirect_to society_event_path(society_id: @event.society_id, id: @event.id), notice: 'Comment Successfully!'
		else
			redirect_to society_event_path(society_id: @event.society_id, id: @event.id), notice: 'Error. Content is Empty.'
		end
	end

	def destroy
		@comment = Comment.find(params[:id])
		@event = Event.find(@comment.event_id)
		@comment.destroy
		redirect_to society_event_path(society_id: @event.society_id, id: @event.id), notice: 'You have deleted a comment.'
	end

	private
	def comment_params
		params.require(:comment).permit(:user_id, :event_id, :content)
	end

	def has_permission
		@comment = Comment.find(params[:id])
		@event = Event.find(@comment.event_id)
		@membership = Membership.find_by(society_id: @event.society_id, user_id: current_user.id)
		redirect_to(root_path) unless ((current_user.id == @comment.user_id) || (@membership.isadmin))
	end
end
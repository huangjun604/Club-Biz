class UsersController < ApplicationController
  before_action :correct_user, only: [:show]

  def show
  	@user = User.find(params[:id])
    @memberships = @user.memberships.paginate(page: params[:page])
    @tickets = @user.tickets.paginate(page: params[:page])
    
    respond_to do |format|
        format.html # show.html.erb
        format.xml { render :xml => @user }
    end
  end

  def show_avatar
    @user = User.find(params[:id])
    send_data(@user.avator_data, :type => @user.avator_type, :filename => "#{@user.avator_filename}.jpg", :disposition => "inline")
  end

  def update
    @user = current_user
    respond_to do |format|
      if params[:user][:avatar] != nil
        @avator_data = params[:user][:avatar].read
        @avator_filename = params[:user][:avatar].original_filename
        @avator_type = params[:user][:avatar].content_type
      else
        @avator_data = nil
        @avator_filename = nil
        @avator_type = nil
      end
      if @user.update_attributes(avator_type: @avator_type, avator_data: @avator_data, avator_filename: @avator_filename)
        format.html { redirect_to @user, notice: 'user avatar was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless (current_user == @user)
    end
end

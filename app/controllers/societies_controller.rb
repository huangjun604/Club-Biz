class SocietiesController < ApplicationController
  before_action :set_society, only: [:show, :edit, :update, :destroy]
  before_action :signned_in, only: [:new, :join, :leave, :edit, :update, :destroy]
  before_action :admin_user, only: [:edit, :update, :destroy]

  # GET /societies
  # GET /societies.json
  def index
    @societies = Society.paginate(page: params[:page], :per_page => 4)
  end

  # GET /societies/1
  # GET /societies/1.json
  def show
    @society = Society.find(params[:id])
    @events = @society.events.paginate(page: params[:page])
    @announcements = @society.announcements.paginate(page: params[:page], :per_page => 4)
  end

  # GET /societies/new
  def new
    @society = Society.new
  end

  # GET /societies/1/edit
  def edit
  end

  # POST /societies
  # POST /societies.json
  def create
    @logo = society_params[:logo]
    if @logo != nil
      @logo_data = society_params[:logo].read
      @logo_filename = society_params[:logo].original_filename
      @logo_type = society_params[:logo].content_type
    else
      @logo_data = nil
      @logo_filename = nil
      @logo_type = nil
    end
    @society = Society.new(s_name: society_params[:s_name], website: society_params[:website], regnum: society_params[:regnum], catalogue: society_params[:catalogue], description: society_params[:description], logo_type: @logo_type, logo_data: @logo_data, logo_filename: @logo_filename)

    respond_to do |format|
      if @society.save
        @membership = Membership.new(user_id: current_user.id, society_id: @society.id, isadmin: true)
        @membership.save
        format.html { redirect_to @society, notice: 'Society was successfully created.' }
        format.json { render action: 'show', status: :created, location: @society }
      else
        format.html { render action: 'new' }
        format.json { render json: @society.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /societies/1
  # PATCH/PUT /societies/1.json
  def update
    respond_to do |format|
      if society_params[:logo] != nil
        @logo_data = society_params[:logo].read
        @logo_filename = society_params[:logo].original_filename
        @logo_type = society_params[:logo].content_type
      else
        @logo_data = nil
        @logo_filename = nil
        @logo_type = nil
      end
      if @society.update(s_name: society_params[:s_name], website: society_params[:website], regnum: society_params[:regnum], catalogue: society_params[:catalogue], description: society_params[:description], logo_type: @logo_type, logo_data: @logo_data, logo_filename: @logo_filename)
        format.html { redirect_to @society, notice: 'Society was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @society.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /societies/1
  # DELETE /societies/1.json
  def destroy
    @society.destroy
    respond_to do |format|
      format.html { redirect_to societies_url }
      format.json { head :no_content }
    end
  end

  def checkadmin?
    if current_user != nil
      @membership = Membership.find_by(user_id: current_user.id, society_id: @society.id)
      if @membership != nil
        @membership.isadmin
      end
    else
      current_user
    end
  end
  helper_method :checkadmin?

  def join
    set_society
    @membership = Membership.new(user_id: current_user.id, society_id: @society.id, isadmin: false)
    @membership.save
    redirect_to @society
  end

  def leave
    set_society
    @membership = Membership.find_by(user_id: current_user.id, society_id: @society.id)
    if @membership != nil
      @membership.destroy
    end
    redirect_to @society
  end

  def serve
    set_society
    send_data(@society.logo_data, :type => @society.logo_type, :filename => "#{@society.logo_filename}.jpg", :disposition => "inline")
  end

  def joined?
    if current_user != nil
      set_society
      Membership.find_by(user_id: current_user.id, society_id: @society.id)
    else
      current_user
    end
  end
  helper_method :joined?

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_society
      @society = Society.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def society_params
      params.require(:society).permit(:s_name, :website, :regnum, :catalogue, :description, :logo)
    end

    def signned_in
      redirect_to(new_user_session_path) unless current_user
    end

    def admin_user
      redirect_to(root_path) unless checkadmin?
    end
end

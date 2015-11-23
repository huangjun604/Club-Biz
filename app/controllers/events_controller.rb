class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :check_admin, only: [:edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    @events = Event.paginate(page: params[:page], :per_page => 6)
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @tickets = @event.tickets
    @comments = @event.comments.paginate(page: params[:page])
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @image = event_params[:image]
    if @image != nil
      @image_data = @image.read
      @image_filename = @image.original_filename
      @image_type = @image.content_type
    else
      @image_data = nil
      @image_filename = nil
      @image_type = nil
    end
    @event = Event.new(name: event_params[:name], date: event_params[:date], society_id: event_params[:society_id], ticketnum: event_params[:ticketnum], description: event_params[:description], image_data: @image_data, image_filename: @image_filename, image_type: @image_type)

    respond_to do |format|
      if @event.save
        format.html { redirect_to society_event_path(id: @event.id), notice: 'Event was successfully created.' }
        format.json { render action: 'show', status: :created, location: @event }
      else
        format.html { render action: 'new' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    @image = event_params[:image]
    if @image != nil
      @image_data = @image.read
      @image_filename = @image.original_filename
      @image_type = @image.content_type
    else
      @image_data = nil
      @image_filename = nil
      @image_type = nil
    end
    respond_to do |format|
      if @event.update(name: event_params[:name], date: event_params[:date], society_id: event_params[:society_id], ticketnum: event_params[:ticketnum], description: event_params[:description], image_data: @image_data, image_filename: @image_filename, image_type: @image_type)
        format.html { redirect_to society_event_path(id: @event.id), notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end

  def ismembership?
    if current_user != nil
      Membership.find_by(user_id: current_user.id, society_id: @event.society_id)
    else
      current_user
    end
  end
  helper_method :ismembership?

  def issadmin?
    if current_user != nil
      @membership = Membership.find_by(user_id: current_user.id, society_id: @event.society_id)
      if @membership != nil
        @membership.isadmin
      end
    else
      current_user
    end
  end
  helper_method :issadmin?

  def display
    set_event
    send_data(@event.image_data, :type => @event.image_type, :filename => "#{@event.image_filename}.jpg", :disposition => "inline")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:name, :date, :society_id, :ticketnum, :description, :image)
    end

    def check_admin
      redirect_to(root_path) unless issadmin?
    end
end

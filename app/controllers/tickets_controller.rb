class TicketsController < ApplicationController
  before_action :joined_user, only: [:create]
  before_action :check_user, only: [:destroy]

  def create
    @event = Event.find(params[:ticket][:event_id])
    @newticketnum = @event.ticketnum - Integer(ticket_params[:number])
    @reservedNum = 0
    @reservedTickets = Ticket.where(user_id: current_user.id, event_id: @event.id)
    if @reservedTickets.any?
      @reservedTickets.each do |reservedTicket|
        @reservedNum = @reservedNum + reservedTicket.number + Integer(ticket_params[:number])
      end
    end
    if @newticketnum >= 0
      if @reservedNum <= 4
        @ticket = Ticket.new(user_id: current_user.id, event_id: @event.id, number: ticket_params[:number])
        @ticket.save
        @event.updateNum(@newticketnum)
        redirect_to current_user, notice: 'You have a new reservation.'
      else
        redirect_to society_event_path(society_id:@event.society_id, id: @event.id), notice: 'Sorry. You have register the maximum number of tickets.'
      end
    else
      redirect_to society_event_path(society_id:@event.society_id, id: @event.id), notice: 'Sorry. There is no enough tickets.'
    end
  end

  def destroy
    @ticket = Ticket.find(params[:id])
    @event = Event.find(@ticket.event_id)
    @newticketnum = @event.ticketnum + Integer(@ticket.number)
    @ticket.destroy
    @event.updateNum(@newticketnum)
    redirect_to current_user, notice: 'Your reservation has been successfully canceled.'
  end

  private

  def ticket_params
      params.require(:ticket).permit(:number)
  end

  def joined_user
    @event = Event.find(params[:ticket][:event_id])
    @membership = Membership.find_by(user_id: current_user.id, society_id: @event.society_id)
    redirect_to(root_path) unless @membership
  end


  def check_user
    @ticket = Ticket.find(params[:id])
    redirect_to(root_path) unless (current_user.id == @ticket.user_id)
  end
end
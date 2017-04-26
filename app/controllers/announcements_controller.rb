require 'rubygems'
require 'twilio-ruby'

class AnnouncementsController < ApplicationController
  before_action :set_announcement, only: [:show, :edit, :update, :destroy]

  # GET /announcements
  # GET /announcements.json
  def index
    @announcements = Announcement.all
    @user = User.find(session[:user_id])
  end

  # GET /announcements/1
  # GET /announcements/1.json
  def show
  end

  # GET /announcements/new
  def new
    @announcement = Announcement.new
  end

  # GET /announcements/1/edit
  def edit
  end

  # POST /announcements
  # POST /announcements.json
  def create
    @user = User.find(session[:user_id])
    name = @user.firstName + ' ' + @user.lastName
    id = session[:user_id]
    @announcement = Announcement.new(name: name, announcement: announcement_params[:announcement], creator_id: id)

    respond_to do |format|
      if @announcement.save
        # configure Twilio account for text messaging
        account_sid = 'AC2cb3447521c10d66dacebce598f4326b'
        auth_token = '6eccfca2a20a9715d8f8f7d99e46c17b'
        incoming_phone = '+18044635203'
        message = @announcement.announcement
        @client = Twilio::REST::Client.new account_sid, auth_token
        #send a text message to each member
        @users = User.all
        @users.each do |user|
          @client.messages.create(
            from: incoming_phone,
            to: '+1' + user.phone,
            body: "\nFrom: " + @announcement.name + "\n" + message
          )
        end


        format.html { redirect_to '/announcements'}
        format.json { render :show, status: :created, location: @announcement }
      else
        format.html { render :new }
        format.json { render json: @announcement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /announcements/1
  # PATCH/PUT /announcements/1.json
  def update
    respond_to do |format|
      if @announcement.update(announcement_params)
        format.html { redirect_to @announcement, notice: 'Announcement was successfully updated.' }
        format.json { render :show, status: :ok, location: @announcement }
      else
        format.html { render :edit }
        format.json { render json: @announcement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /announcements/1
  # DELETE /announcements/1.json
  def destroy
    @announcement.destroy
    respond_to do |format|
      format.html { redirect_to announcements_url, notice: 'Announcement was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_announcement
      @announcement = Announcement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def announcement_params
      params.require(:announcement).permit(:announcement)
    end
end

require 'bcrypt'

class SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  # GET sessions/new
  def new
  end

  include BCrypt

  def create
    @user = User.find_by(email: params[:email])
    if @user.nil?
        render :new, notice: "Invalid email or password"
    else
      if @user.password == params[:password]
        session[:user_id] = @user.id
        redirect_to '/home'
      else
        redirect_to '/login'
      end
    end
  end

  def destroy
    reset_session
    redirect_to '/'
  end
end


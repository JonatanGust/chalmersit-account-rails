class AdminsController < ApplicationController
  include ConfigurableEngine::ConfigurablesController
  include SubscriptionHelper
  before_filter :ensure_admin
  after_action :verify_authorized

  def show
  end

  def edit
  end

  def update
  end

  def index
  end

  def mail
  end
  def send_invitations
    @emails = params[:emails].split(';')
    UserMailer.send_invitations(@emails)
  end
end

class Cpanel::InvitesController < Cpanel::ApplicationController
  def index
    @invites = Invite.order('created_at desc').paginate page: params[:page], per_page: 30
    if params[:q].present?
      @invites = @invites.search(params[:q])
    end
  end
end
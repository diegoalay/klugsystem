class RolesChannel < ApplicationCable::Channel
  def subscribed
    @role = Role.find_by(id: params[:id])

    stream_for @role
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end

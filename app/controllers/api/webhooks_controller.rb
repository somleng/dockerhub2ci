class Api::WebhooksController < Api::BaseController
  private

  def association_chain
    Webhook
  end

  def save_resource?
    ENV["SAVE_WEBHOOKS"].to_i == 1
  end

  def build_resource
    @resource ||= association_chain.new(:payload => params)
  end

  def trigger_resource_events
    resource.subscribe(WebhookEventListener.new)
    resource.broadcast_received!
  end
end

class WebhookSubscriber::Base
  def webhook_received!(payload)
    WebhookJob.perform_later(self.class.to_s, payload)
  end
end

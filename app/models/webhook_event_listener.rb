class WebhookEventListener
  delegate :webhook_subscribers, :to => :class

  def webhook_received(payload)
    webhook_subscribers.each do |subscriber|
      subscriber.new.webhook_received!(payload)
    end
  end

  def self.webhook_subscribers
    registered_subscribers = ENV["WEBHOOK_SUBSCRIBERS"].to_s.split(";").index_by(&:to_s)
    WebhookSubscriber::Base.descendants.select { |subscriber| registered_subscribers.has_key?(subscriber.name) }
  end
end

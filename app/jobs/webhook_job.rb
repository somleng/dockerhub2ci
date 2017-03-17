class WebhookJob < ApplicationJob
  queue_as :default

  def perform(subscriber_class, payload)
    subscriber_class.constantize.new.perform!(payload)
  end
end

require 'rails_helper'

describe Webhook do
  let(:factory) { :webhook }

  describe "validations" do
    it { is_expected.to validate_presence_of(:push_data) }
  end

  describe "events", :focus do
    subject { build(factory) }

    def assert_broadcasted!(broadcast_method, &block)
      expect { yield }.to broadcast(broadcast_method)
    end

    it("should broadcast") { assert_broadcasted!(:webhook_received) { subject.broadcast_received! } }
  end

  describe ".by_tag(tag)" do
    let(:tag) { "my-tag" }
    let(:webhook) { create(factory, :tag => tag) }

    def setup_scenario
      webhook
    end

    before do
      setup_scenario
    end

    def assert_by_tag!
      expect(described_class.by_tag(tag)).to match_array([webhook])
      expect(described_class.by_tag("another-tag")).not_to include([webhook])
    end

    it { assert_by_tag! }
  end
end

require 'rails_helper'

describe Webhook do
  describe "#by_tag(tag)" do
    let(:tag) { "my-tag" }
    let(:webhook) { create(:webhook, :tag => tag) }

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

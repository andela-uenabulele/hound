require "rails_helper"

RSpec.describe Tier do
  describe "#current" do
    it "returns user's current pricing" do
      count = 1
      pricing = instance_double(Pricing)
      repos = class_double(Repo, count: count)
      user = instance_double(User, subscribed_repos: repos)
      tier = Tier.new(user)
      allow(Pricing).to receive(:where).once.with(count: count).
        and_return([pricing])

      expect(tier.current).to eq pricing
    end
  end

  describe "full?" do
    context "when the next tier is different to the current tier" do
      it "returns true" do
        repos = double("Repos", count: 4)
        user = double("User", subscribed_repos: repos)
        tier = Tier.new(user)
        expect(tier.full?).to be(true)
      end
    end

    context "when the user has no repos" do
      it "returns false" do
        user = create(:user)
        tier = Tier.new(user)
        expect(tier).to_not be_full
      end
    end

    context "when the next tier is not the same as the current tier" do
      it "returns false" do
        repos = double("Repos", count: 3)
        user = double("User", subscribed_repos: repos)
        tier = Tier.new(user)
        expect(tier.full?).to be(false)
      end
    end
  end

  describe "#next" do
    context "when the user has at least thirty subscribed repos" do
      it "returns the 'Bulk' tier" do
        repos = double("Repos", count: 30)
        user = double("User", subscribed_repos: repos)
        tier = Tier.new(user)
        expect(tier.next).to eq(Tier::BULK_ID)
      end
    end

    context "when the user has no subscribed repos" do
      it "returns the 'Tier 1' tier" do
        count = 1
        pricing = instance_double(Pricing)
        repos = class_double(Repo, count: count)
        user = instance_double(User, subscribed_repos: repos)
        tier = Tier.new(user)
        allow(Pricing).to receive(:where).once.with(count: count.succ).
          and_return([pricing])

        expect(tier.next).to eq pricing
      end
    end
  end

  describe "#previous" do
    it "returns the pricing for the preceding count's tier" do
      count = 0
      pricing = instance_double(Pricing)
      repo = double("Repo")
      user = double("User")
      tier = Tier.new(user)

      allow(Pricing).to receive(:where).once.with(count: count).
        and_return([pricing])
      allow(user).to receive(:subscribed_repos).once.with(no_args).
        and_return([repo])

      expect(tier.previous).to eq pricing
    end
  end
end

require 'rails_helper'

RSpec.describe Advertisement, type: :model do
  let(:adv) { Advertisement.create!(title: "New Ad Title", copy: "New Ad Body", price: 1) }

  describe "attributes" do
    it "should respond to title" do
      expect(adv).to respond_to(:title)
    end

    it "should respond to body" do
      expect(adv).to respond_to(:copy)
    end

    it "should respond to price" do
      expect(adv).to respond_to(:price)
    end
  end

end

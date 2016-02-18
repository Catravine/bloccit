require 'rails_helper'

RSpec.describe Topic, type: :model do
  let(:topic) { FactoryGirl.create(:topic) }

  it { is_expected.to have_many(:posts) }
  it { is_expected.to have_many(:labelings) }
  it { is_expected.to have_many(:labels).through(:labelings) }

  describe "attributes" do
    it "responds to name" do
      expect(topic).to respond_to(:name)
    end

    it "responds to description" do
      expect(topic).to respond_to(:description)
    end

    it "responds to public" do
      expect(topic).to respond_to(:public)
    end

    it "is public by default" do
      expect(topic.public).to be(true)
    end
  end

  describe "scopes" do
    before do
      @public_topic = Topic.create!(name: RandomData.random_sentence, description: RandomData.random_paragraph)
      @private_topic = Topic.create!(name: RandomData.random_sentence, description: RandomData.random_paragraph, public: false)
    end

    describe "visible_to(user)" do
      it "returns all topics if the user is present" do
        user = User.new
        expect(Topic.visible_to(user)).to eq(Topic.all)
      end

      it "returns only public topics if user is nil" do
        expect(Topic.visible_to(nil)).not_to include(@private_topic)
      end
    end

    describe "publicly_viewable" do
      it "only returns topics with public: true" do
        expect(Topic.publicly_viewable).to include(@public_topic)
        expect(Topic.publicly_viewable).not_to include(@private_topic)
      end
    end

    describe "privately_viewable" do
      it "only returns topics with public: false" do
        expect(Topic.privately_viewable).to include(@private_topic)
        expect(Topic.privately_viewable).not_to include(@public_topic)
      end
    end
  end

end

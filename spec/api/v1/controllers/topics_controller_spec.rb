require 'rails_helper'

RSpec.describe Api::V1::TopicsController, type: :controller do
  let(:my_user) { FactoryGirl.create(:user) }
  let(:my_topic) { FactoryGirl.create(:topic) }

  context "unauthenticated user" do
    it "GET index returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "GET show returns http success" do
      get :show, id: my_topic.id
      expect(response).to have_http_status(:success)
    end

    it "PUT update returns http unauthenticated" do
      put :update, id: my_topic.id, topic: { name: "Topic Name", description: "Topic Description" }
      expect(response).to have_http_status(401)
    end

    it "POST create returns http unauthenticated" do
      post :create, topic: { name: "Topic Name", description: "Topic Description" }
      expect(response).to have_http_status(401)
    end

    it "DELETE destroy returns http unauthenticated" do
      delete :destroy, id: my_topic.id
      expect(response).to have_http_status(401)
    end

    it "POST create_post returns http unauthenticated" do
      post :create, post: { name: "Post Name", body: "Post Body" }
      expect(response).to have_http_status(401)
    end
  end

  context "unauthorized user" do
    before do
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
    end

    it "GET index returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "GET show returns http success" do
      get :show, id: my_topic.id
      expect(response).to have_http_status(:success)
    end

    it "PUT update returns http forbidden" do
      put :update, id: my_topic.id, topic: { name: "Topic Name", description: "Topic Description" }
      expect(response).to have_http_status(403)
    end

    it "POST create returns http forbidden" do
      post :create, topic: { name: "Topic Name", description: "Topic Description" }
      expect(response).to have_http_status(403)
    end

    it "DELETE destroy returns http forbidden" do
      delete :destroy, id: my_topic.id
      expect(response).to have_http_status(403)
    end

    it "POST create_post returns http forbidden" do
      post :create, post: { name: "Post Name", body: "Post Body" }
      expect(response).to have_http_status(403)
    end
  end

  context "authenticted and authorized users" do
    before do
      my_user.admin!
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
      @new_topic = FactoryGirl.build(:topic)
    end

    describe "PUT update" do
      before { put :update, id: my_topic.id, topic: {name: @new_topic.name, description: @new_topic.description} }

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "returns json content type" do
        expect(response.content_type).to eq 'application/json'
      end

      it "updates a topic with the correct attributes" do
        update_topic = Topic.find(my_topic.id)
        expect(response.body).to eq(update_topic.to_json)
      end
    end

    describe "POST create" do
      before { post :create, topic: { name: @new_topic.name, description: @new_topic.description } }

      it "reutrns http success" do
        expect(response).to have_http_status(:success)
      end

      it "returns json content type" do
        expect(response.content_type).to eq 'application/json'
      end

      it "creates a topic with the correct attributes" do
        hashed_json = JSON.parse(response.body)
        expect(hashed_json["name"]).to eq(@new_topic.name)
        expect(hashed_json["description"]).to eq(@new_topic.description)
      end
    end

    describe "DELETE destroy" do
      before { delete :destroy, id: my_topic.id }

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "returns json content type" do
        expect(response.content_type).to eq 'application/json'
      end

      it "returns the correct josn success message" do
        expect(response.body).to eq({"message" => "Topic destroyed","status" => 200}.to_json)
      end

      it "deletes my_topic" do
        expect{ Topic.find(my_topic.id) }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end

    describe "POST create_post" do
      before do
        @new_post = FactoryGirl.build(:post, topic: my_topic, user: my_user)
        controller.create_post(@new_post.title, @new_post.body)
        #post :create, post: { title: @new_post.title, body: @new_post.body }
        #@new_post = FactoryGirl.create(:post, user: my_user, topic: my_topic)
        #@new_post = FactoryGirl.create(:post, user: my_user, topic: my_topic)
        #@new_post = FactoryGirl.build(:post, user: my_user, topic: my_topic)
        #post :create_post, post: { name: @new_post.title, body: @new_post.body, user: my_user, topic: my_topic}
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "returns json content type" do
        expect(response.content_type).to eq 'application/json'
      end

      it "creates a post with the correct attributes" do
        hashed_json = JSON.parse(response.body)
        expect(hashed_json["title"]).to eq(@new_post.title)
        expect(hashed_json["body"]).to eq(@new_post.body)
      end
    end
  end
end

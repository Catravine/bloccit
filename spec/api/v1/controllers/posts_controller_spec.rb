require 'rails_helper'

RSpec.describe Api::V1::PostsController, type: :controller do
  let(:my_user) { FactoryGirl.create(:user) }
  let(:my_topic) { FactoryGirl.create(:topic) }
  let(:my_post) { FactoryGirl.create(:post, topic: my_topic, user: my_user) }

  context "unauthenticated user" do
    it "GET index returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "GET show returns http success" do
      get :show, id: my_post.id
      expect(response).to have_http_status(:success)
    end

    it "PUT update returns http unauthenticated" do
      put :update, id: my_post.id, post: { name: "Post Name", body: "Post Body" }
      expect(response).to have_http_status(401)
    end

    it "DELETE destroy returns http unauthenticated" do
      delete :destroy, id: my_post.id
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
      get :show, id: my_post.id
      expect(response).to have_http_status(:success)
    end

    it "PUT update returns http forbidden" do
      put :update, id: my_post.id, post: { name: "Post Name", body: "Post Body" }
      expect(response).to have_http_status(403)
    end

    it "DELETE destroy returns http forbidden" do
      delete :destroy, id: my_post.id
      expect(response).to have_http_status(403)
    end
  end

  context "authenticted and authorized users" do
    before do
      my_user.admin!
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
      @new_post = FactoryGirl.build(:post, user: my_user, topic: my_topic)
    end

    describe "PUT update" do
      before { put :update, id: my_post.id, post: {name: @new_post.title, body: @new_post.body} }

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "returns json content type" do
        expect(response.content_type).to eq 'application/json'
      end

      it "updates a topic with the correct attributes" do
        update_post = Post.find(my_post.id)
        expect(response.body).to eq(update_post.to_json)
      end
    end

    describe "DELETE destroy" do
      before { delete :destroy, id: my_post.id }

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "returns json content type" do
        expect(response.content_type).to eq 'application/json'
      end

      it "returns the correct josn success message" do
        expect(response.body).to eq({"message" => "Post destroyed","status" => 200}.to_json)
      end

      it "deletes my_post" do
        expect{ Post.find(my_post.id) }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end
end

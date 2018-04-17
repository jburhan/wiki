require 'rails_helper'
include RandomData

RSpec.describe PagesController, type: :controller do
  let(:my_user) { create(:user) }
  let(:my_page) { create(:page) }

  describe "GET #index" do

    before do
      sign_in my_user
    end

    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      get :show, params: { id: my_page.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end

    it "renders the #new view" do
      get :new
      expect(response).to render_template :new
    end

    it "instantiates @wiki" do
      get :new
      expect(assigns(:page)).not_to be_nil
    end
  end

  describe "POST create" do
    it "increases the number of Wiki by 1" do
      expect{ post :create, params: { page: { title: RandomData.random_sentence, body: RandomData.random_paragraph } } }.to change(Page,:count).by(1)
    end

    it "assigns the new wiki to @page" do
      post :create, params: { page: { title: RandomData.random_sentence, body: RandomData.random_paragraph } }
      expect(assigns(:page)).to eq Page.last
    end

    it "redirects to the new wiki" do
      post :create, params: { page: { title: RandomData.random_sentence, body: RandomData.random_paragraph } }
      expect(response).to redirect_to Page.last
    end
  end

  describe "GET #edit" do
    it "returns http success" do
      get :edit, params: { id: my_page.id }
      expect(response).to have_http_status(:success)
    end

    it "renders the #edit view" do
      get :edit, params: { id: my_page.id }
      expect(response).to render_template :edit
    end

    it "assigns wiki to be updated to @page" do
      get :edit, params: { id: my_page.id }

      page_instance = assigns(:page)

      expect(page_instance.id).to eq my_page.id
      expect(page_instance.title).to eq my_page.title
      expect(page_instance.body).to eq my_page.body
    end
  end

  describe "PUT update" do
    it "updates wiki with expected attributes" do
      new_title = RandomData.random_sentence
      new_body = RandomData.random_paragraph

      put :update, params: { id: my_page.id, page: {title: new_title, body: new_body} }

      updated_page = assigns(:page)
      expect(updated_page.id).to eq my_page.id
      expect(updated_page.title).to eq new_title
      expect(updated_page.body).to eq new_body
    end

    it "redirects to the updated wiki" do
      new_title = RandomData.random_sentence
      new_body = RandomData.random_paragraph

      put :update, params: { id: my_page.id, page: {title: new_title, body: new_body} }
      expect(response).to redirect_to my_page
    end
  end

  describe "DELETE destroy" do
    it "deletes the wiki" do
      delete :destroy, params: { id: my_page.id }
      count = Page.where({id: my_page.id}).size
      expect(count).to eq 0
    end

    it "redirects to wikis index" do
      delete :destroy, params: { id: my_page.id }
      expect(response).to redirect_to pages_path
    end
  end

end

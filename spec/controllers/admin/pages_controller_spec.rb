require 'rails_helper'

describe Admin::PagesController do

    store_setting
    login_admin

    describe 'GET #index' do
        let!(:standard_page) { create(:standard_page) }
        let!(:contact_page) { create(:contact_page) }

        it "should populate an array of all pages" do
            get :index
            expect(assigns(:pages)).to match_array([standard_page, contact_page])
        end
        it "should render the :index template" do
            get :index
            expect(response).to render_template :index
        end
    end

    describe 'GET #edit' do
        let(:page) { create(:standard_page) }

        it 'should assign a list of template types to @template_types' do
            patch :update, id: page.id, page: attributes_for(:page)
            expect(assigns(:template_types).keys.map{|type| type }).to eq ["standard","contact"] 
        end
        it "should assign the requested page to @page" do
            get :edit , id: page.id
            expect(assigns(:page)).to eq page
        end
        it "should render the :edit template" do
            get :edit, id: page.id
            expect(response).to render_template :edit
        end
    end

    describe 'PUT #update' do
        let!(:page) { create(:standard_page, title: 'Page #1', active: false) }

        it 'should assign a list of template types to @template_types' do
            patch :update, id: page.id, page: attributes_for(:page)
            expect(assigns(:template_types).keys.map{|type| type }).to eq ["standard","contact"] 
        end
        context "with valid attributes" do
            it "should locate the requested @page" do
                patch :update, id: page.id, page: attributes_for(:page)
                expect(assigns(:page)).to eq(page)
            end
            it "should update the page in the database" do
                patch :update, id: page.id, page: attributes_for(:page, title: 'Page #2', active: true)
                page.reload
                expect(page.title).to eq('Page #2')
                expect(page.active).to eq(true)
            end
            it "should redirect to the pages#index" do
                patch :update, id: page.id, page: attributes_for(:page)
                expect(response).to redirect_to admin_pages_url
            end
        end
        context "with invalid attributes" do 
            it "should not update the page" do
                patch :update, id: page.id, page: attributes_for(:page, title: nil, active: true)
                page.reload
                expect(page.title).to eq('Page #1')
                expect(page.active).to eq(false)
            end
            it "should re-render the #edit template" do
                patch :update, id: page.id, page: attributes_for(:page, title: nil, active: true)
                expect(response).to render_template :edit
            end
        end 
    end
end
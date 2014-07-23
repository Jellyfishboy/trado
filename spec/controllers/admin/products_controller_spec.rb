require 'rails_helper'

describe Admin::ProductsController do

    store_setting
    login_admin

    describe 'GET #index' do
        let!(:category_1) { create(:category, sorting: 1) }
        let!(:category_2) { create(:category, sorting: 0) }
        let!(:product_1) { create(:product_sku, weighting: 2000, active: true, category_id: category_1.id) }
        let!(:product_2) { create(:product_sku, weighting: 1000, active: true, category_id: category_2.id) }
        let!(:product_3) { create(:product_sku, weighting: 3000, active: false, category_id: category_1.id) }

        it "should populate an array of all products" do
            get :index
            expect(assigns(:products)).to match_array([product_2, product_1])
        end

        it "should populate an array of all categories" do
            get :index
            expect(assigns(:categories)).to match_array([category_2, category_1])
        end

        it "should render the :index template" do
            get :index
            expect(response).to render_template :index
        end
    end

    describe 'GET #new' do

        it "should assign a new Product to @product" do
            get :new
            expect(assigns(:product)).to be_a_new(Product)
        end

        context "if there are no Attribute types" do

            it "should flash an error message" do
                get :new
                expect(subject.request.flash[:error]).to_not be_nil
            end

            it "should redirect to the products#index" do
                get :new
                expect(response).to redirect_to(admin_products_url)
            end
        end

        context "if there are Attribute types" do
            before(:each) do
                create(:attribute_type)
            end

            it "should render the :new template" do
                get :new
                expect(response).to render_template :new
            end
        end
    end

    describe 'GET #edit' do
        let(:product) { create(:product_sku, active: true) }

        it "should assign the requested product to @product" do
            get :edit, id: product.id
            expect(assigns(:product)).to eq product
        end

        it "should render the :edit template" do
            get :edit, id: product.id
            expect(response).to render_template :edit
        end
    end
end
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
        
        it "should create a new product" do
            expect {
                get :new
            }.to change(Product, :count).by(1)
        end

        it "should redirect to the edit product path" do
            get :new
            expect(response).to redirect_to(edit_admin_product_path(assigns(:product)))
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

    describe 'PATCH #update' do
        let!(:category) { create(:category) }
        let!(:product) { create(:product_sku_attachment, name: 'Product #1', featured: false) }
        let!(:product_attributes) { attributes_for(:product_sku_attachment, category_id: category.id) }

        it "should assign the requested product to @product" do
            patch :update, id: product.id, product: product_attributes, commit: 'Save'
            expect(assigns(:product)).to eq product
        end

        context "if the commit type was 'Save'" do

            it "should set the product status to 'draft'" do
                patch :update, id: product.id, product: product_attributes, commit: 'Save'
                expect(assigns(:product).status).to eq "draft"
            end

            it "should set the correct string for the @message variable" do
                patch :update, id: product.id, product: product_attributes, commit: 'Save' 
                expect(assigns(:message)).to eq "Your product has been saved successfully as a draft."
            end
        end

        context "if the commit type was 'Publish'" do

            it "should set the product status to 'published'" do
                patch :update, id: product.id, product: product_attributes, commit: 'Publish'
                expect(assigns(:product).status).to eq "published"
            end

            it "should set the correct string for the message variable" do
                patch :update, id: product.id, product: product_attributes, commit: 'Publish'
                expect(assigns(:message)).to eq "Your product has been published successfully. It is now live in your store."
            end
        end

        context "with valid attributes" do

            it "should update the associated tags" do
                patch :update, id: product.id, product: attributes_for(:product_sku, category_id: category.id), taggings: 'tag 1,tag 2,hehe'
                product.reload
                expect(product.tags.map(&:name)).to eq ['tag 1', 'tag 2', 'hehe']
            end


            it "should save the product" do
                patch :update, id: product.id, product: attributes_for(:product_sku, category_id: category.id, name: 'Product #2', featured: true), commit: 'Save'
                product.reload
                expect(product.name).to eq('Product #2')
                expect(product.featured).to eq(true)
            end

            it "should redirect to products#index" do
                patch :update, id: product.id, product: attributes_for(:product_sku, category_id: category.id), commit: 'Save'
                expect(response).to redirect_to(admin_products_url)
            end
        end

        context "with invalid attributes" do

            it "should not update the product" do
                patch :update, id: product.id, product: attributes_for(:invalid_product, category_id: category.id),commit: 'Publish'
                expect(product.name).to eq 'Product #1'
                expect(product.featured).to eq false
            end

            it "should render the :edit template" do
                patch :update, id: product.id, product: attributes_for(:invalid_product, category_id: category.id), commit: 'Publish'
                expect(response).to render_template :edit
            end
        end
    end

    describe 'PATCH #autosave' do
        let!(:category) { create(:category) }
        let!(:product) { create(:product_sku_attachment, name: 'Product #1', featured: false) }
        let!(:product_attributes) { attributes_for(:product_sku_attachment, category_id: category.id) }

        it "should assign the requested product to @product" do
            xhr :patch, :autosave, id: product.id, product: product_attributes
            expect(assigns(:product)).to eq product
        end

        context "with valid attributes" do

            it "should save the product" do
                xhr :patch, :autosave, id: product.id, product: attributes_for(:product_sku, category_id: category.id, name: 'Product #2', featured: true)
                product.reload
                expect(product.name).to eq('Product #2')
                expect(product.featured).to eq(true)
            end

            it "should return 200 status code" do
                xhr :patch, :autosave, id: product.id, product: attributes_for(:product_sku, category_id: category.id, name: 'Product #2', featured: true)
                expect(response.status).to eq 200
            end
        end

        context "with invalid attributes" do

            it "should not update the product" do
                xhr :patch, :autosave, id: product.id, product: attributes_for(:invalid_product, category_id: category.id)
                expect(product.name).to eq 'Product #1'
                expect(product.featured).to eq false
            end

            it "should return 422 status code" do
                xhr :patch, :autosave, id: product.id, product: attributes_for(:invalid_product, category_id: category.id)
                expect(response.status).to eq 422
            end
        end
    end

    # describe 'DELETE #destroy' do
    #     let!(:product) { create(:product_skus, active: true) }
    #     let(:order) { create(:order) }
    #     let(:cart) { create(:cart) }

    #     it "should assign the requested product to @product" do
    #         delete :destroy, id: product.id
    #         expect(assigns(:product)).to eq product
    #     end

    #     context "if the product has associated orders" do
    #         before(:each) do
    #             product.reload
    #             create(:order_item, sku_id: product.skus.first.id, order_id: order.id)
    #         end

    #         it "should set the product as inactive" do
    #             expect{
    #                 delete :destroy, id: product.id
    #                 product.reload
    #             }.to change{
    #                 product.active
    #             }.from(true).to(false)
    #         end

    #         it "should not delete the product from the database" do
    #             expect{
    #                 delete :destroy, id: product.id
    #             }.to change(Product, :count).by(0)
    #         end

    #         it "should not delete any associated SKUs from the database" do
    #             expect{
    #                 delete :destroy, id: product.id
    #             }.to change(Sku, :count).by(0)
    #         end

    #         it "should set the associated SKUs as inactive" do
    #             delete :destroy, id: product.id
    #             product.reload
    #             expect(product.skus.map(&:active)).to eq [false, false, false]
    #         end
    #     end

    #     context "if the product has no associated orders" do

    #         it "should delete the product from the database"  do
    #             expect {
    #                 delete :destroy, id: product.id
    #             }.to change(Product, :count).by(-1)
    #         end

    #         it "should delete associated SKUs from the database" do
    #             expect{
    #                 delete :destroy, id: product.id
    #             }.to change(Sku, :count).by(-3)
    #         end
    #     end

    #     context "if the product has associated carts" do
    #         before(:each) do
    #             product.reload
    #             create_list(:cart_item, 2, sku_id: product.skus.first.id, cart_id: cart.id)
    #         end

    #         it "should delete all associated cart item products from the database" do
    #             expect{
    #                 delete :destroy, id: product.id
    #             }.to change(CartItem, :count).by(-2)
    #         end
    #     end

    #     it "should redirect to products#index" do
    #         delete :destroy, id: product.id
    #         expect(response).to redirect_to admin_products_url
    #     end
    # end
end
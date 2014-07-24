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

    describe "POST #create" do
        let!(:category) { create(:category) }

        context "with valid attributes" do

            it "should save the new product in the database" do
                expect {
                    xhr :post, :create, product: attributes_for(:product, category_id: category.id)
                }.to change(Product, :count).by(1)
            end

            it "should link to to product page"  do
                xhr :post, :create, product: attributes_for(:product, category_id: category.id)
                expect(response.body).to eq "window.location.replace('#{category_product_url(assigns(:product).category, assigns(:product))}');"
            end

            it "should return a 200 status code" do
                xhr :post, :create, product: attributes_for(:product, category_id: category.id)
                expect(response.status).to eq 200
            end
        end
        context "with invalid attributes" do
            let(:errors) { ["Name can't be blank", "Name is too short (minimum is 10 characters)"] }

            it "should not save the new product in the database" do
                expect {
                    xhr :post, :create, product: attributes_for(:invalid_product, category_id: category.id)
                }.to_not change(Product, :count)
            end

            it "should return a JSON object of errors" do
                xhr :post, :create, product: attributes_for(:invalid_product, category_id: category.id)
                expect(assigns(:product).errors.full_messages).to eq errors
            end

            it "should return a 422 status code" do
                xhr :post, :create, product: attributes_for(:invalid_product, category_id: category.id)
                expect(response.status).to eq 422
            end
        end 
    end

    describe 'PATCH #update' do
        let!(:category) { create(:category) }
        let!(:product) { create(:product_sku, name: 'Product #1', featured: false) }

        it "should assign the requested product to @product" do
            xhr :patch, :update, id: product.id, product: attributes_for(:product_sku, category_id: category.id)
            expect(assigns(:product)).to eq product
        end

        context "with valid attributes" do

            it "should update the associated tags" do
                xhr :patch, :update, id: product.id, product: attributes_for(:product_sku, category_id: category.id), taggings: 'tag 1,tag 2,hehe'
                product.reload
                expect(product.tags.map(&:name)).to eq ['tag 1', 'tag 2', 'hehe']
            end

            it "should set the associated attachment as default" do
                expect(product.attachments.first.default_record).to eq false
                xhr :patch, :update, id: product.id, product: attributes_for(:product_sku, category_id: category.id), default_attachment: product.attachments.first.id
                product.reload
                expect(product.attachments.first.default_record).to eq true
            end

            it "should save the product" do
                xhr :patch, :update, id: product.id, product: attributes_for(:product_sku, category_id: category.id, name: 'Product #2', featured: true)
                product.reload
                expect(product.name).to eq('Product #2')
                expect(product.featured).to eq(true)
            end

            it "should link to the products#index" do
                xhr :patch, :update, id: product.id, product: attributes_for(:product_sku, category_id: category.id)
                expect(response.body).to eq "window.location.replace('#{admin_products_url}');"
            end
        end

        context "with invalid attributes" do
            let(:errors) { ["Name can't be blank", "Name is too short (minimum is 10 characters)"] }
            before(:each) do
                xhr :patch, :update, id: product.id, product: attributes_for(:invalid_product, category_id: category.id)
            end

            it "should not update the product" do
                product.reload
                expect(product.name).to eq 'Product #1'
                expect(product.featured).to eq false
            end

            it "should return a JSON object of errors" do
                expect(assigns(:product).errors.full_messages).to eq errors
            end

            it "should return a 422 status code" do
                expect(response.status).to eq 422
            end
        end
    end

    describe 'DELETE #destroy' do
        let!(:product) { create(:product_skus, active: true) }
        let(:order) { create(:order) }
        let(:cart) { create(:cart) }

        it "should assign the requested product to @product" do
            delete :destroy, id: product.id
            expect(assigns(:product)).to eq product
        end

        context "if the product has associated orders" do
            before(:each) do
                product.reload
                create(:order_item, sku_id: product.skus.first.id, order_id: order.id)
            end

            it "should set the product as inactive" do
                expect{
                    delete :destroy, id: product.id
                    product.reload
                }.to change{
                    product.active
                }.from(true).to(false)
            end

            it "should not delete the product from the database" do
                expect{
                    delete :destroy, id: product.id
                }.to change(Product, :count).by(0)
            end

            it "should not delete any associated SKUs from the database" do
                expect{
                    delete :destroy, id: product.id
                }.to change(Sku, :count).by(0)
            end

            it "should set the associated SKUs as inactive" do
                delete :destroy, id: product.id
                product.reload
                expect(product.skus.map(&:active)).to eq [false, false, false]
            end
        end

        context "if the product has no associated orders" do

            it "should delete the product from the database"  do
                expect {
                    delete :destroy, id: product.id
                }.to change(Product, :count).by(-1)
            end

            it "should delete associated SKUs from the database" do
                expect{
                    delete :destroy, id: product.id
                }.to change(Sku, :count).by(-3)
            end
        end

        context "if the product has associated carts" do
            before(:each) do
                product.reload
                create_list(:cart_item, 2, sku_id: product.skus.first.id, cart_id: cart.id)
            end

            it "should delete all associated cart item products from the database" do
                expect{
                    delete :destroy, id: product.id
                }.to change(CartItem, :count).by(-2)
            end
        end

        it "should redirect to products#index" do
            delete :destroy, id: product.id
            expect(response).to redirect_to admin_products_url
        end
    end
end
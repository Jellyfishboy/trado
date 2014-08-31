require 'rails_helper'

describe ProductsController do

    store_setting

    describe 'GET #show' do
        let(:category) { create(:category) }
        let(:product) { create(:product_sku_attachment, active: true, category: category) }

        it "should assign the request product to @product" do
            get :show, { category_id: category.id, id: product.id }
            expect(assigns(:product)).to eq product
        end

        it "should build a new cart item and assign it to @cart_item" do
            get :show, { category_id: category.id, id: product.id }
            expect(assigns(:cart_item)).to be_a_new(CartItem) 
        end

        context "if the product has an accessory" do
            let(:product) { create(:product_accessory, active: true) }

            it "should build a new cart item accessory and assign it to @cart_item_accessory" do
                get :show, { category_id: category.id, id: product.id }
                expect(assigns(:cart_item_accessory)).to be_a_new(CartItemAccessory)
            end
        end

        context "if the product has no accessories" do
            let(:product) { create(:product_sku_attachment, active: true) }

            it "should set @cart_item_accessory as nil" do
                get :show, { category_id: category.id, id: product.id }
                expect(assigns(:cart_item_accessory)).to eq nil
            end
        end

        it "should build a new notification and assign it to @notification" do
            get :show, { category_id: category.id, id: product.id }
            expect(assigns(:notification)).to be_a_new(Notification)
        end

        it "should assign the requested product skus to @skus" do
            get :show, { category_id: category.id, id: product.id }
            product.reload
            expect(assigns(:skus)).to match_array(product.skus)
        end 

        it "should render the :show template" do
            get :show, category_id: category.id, id: product.id
            expect(response).to render_template(:show)
        end
    end
end
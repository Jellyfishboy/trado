require 'rails_helper'

describe CartItemsController do

    store_setting

    describe 'POST #create' do

        it "should assign the related SKU to @sku" do

        end

        it "should assign the updated cart item to @cart_item" do 

        end

        context "with valid attributes" do

            it "should render the update partial" do

            end
        end

        context "with invalid attributes" do

        end
    end

    describe 'PATCH #update' do

    end

    describe 'DELETE #destroy' do
        let!(:cart_item) { create(:cart_item) }

        it "should delete the cart item" do            
            expect{
                xhr :delete, :destroy, id: cart_item.id
            }.to change(CartItem, :count).by(-1)
        end

        it "should render the update partial" do
            xhr :delete, :destroy, id: cart_item.id
            expect(response).to render_template(partial: 'carts/_update')
        end
    end
end
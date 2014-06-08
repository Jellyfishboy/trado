require 'spec_helper'

describe CartItem do

    # ActiveRecord relations
    # it { expect(subject).to belong_to(:sku) }
    # it { expect(subject).to belong_to(:cart) }
    # it { expect(subject).to have_one(:cart_item_accessory).dependent(:delete) }

    # # Nested attributes
    # it { expect(subject).to accept_nested_attributes_for(:cart_item_accessory) }

    # describe "When calculating a cart item total" do
    #     let!(:cart_item) { build(:cart_item, price: 12, quantity: 7) }
    #     it "should return the sum of price multiplied by quantity" do
    #         expect(cart_item.total_price).to eq 84
    #     end
    # end

    describe "When adding a new cart item" do

        context "if its a new cart item" do

            context "and the cart item does not have an accessory" do
                let(:sku) { create(:sku) }
                let!(:current_cart) { create(:cart) }
                let(:cart_item) { CartItem.increment(sku, 5, nil, current_cart) }

                it "should build a new cart item", skip_before: true do
                    expect{
                        CartItem.increment(sku, 5, nil, current_cart).save(validate: false)
                    }.to change(CartItem, :count).by(1)
                end

                it "should not build a new cart item accessory", skip_before: true do
                    expect{
                        CartItem.increment(sku, 5, nil, current_cart).save(validate: false)
                    }.to change(CartItemAccessory, :count).by(0)
                end

                it "should update the cart item's quantity" do
                    expect(cart_item.quantity).to eq 5
                end

                it "should update the cart item's weight" do
                    expect(cart_item.weight).to eq (cart_item.sku.weight*5)
                end

                it "should not have an associated cart item accessory record" do
                    expect(cart_item.cart_item_accessory).to eq nil
                end
            end

            context "and the cart item has an accessory" do
                let(:accessory) { create(:accessory) }
                let(:sku) { create(:sku) }
                let!(:current_cart) { create(:cart) }
                let(:param) { Hash({:accessory_id => accessory.id}) }
                let(:cart_item) { CartItem.increment(sku, 5, param, current_cart) }

                it "should build a new cart item" do
                    expect{
                        CartItem.increment(sku, 5, param, current_cart).save(validate: false)
                    }.to change(CartItem, :count).by(1)
                end

                it "should build a new cart item accessory" do
                    expect{
                        CartItem.increment(sku, 5, param, current_cart).save(validate: false)
                    }.to change(CartItemAccessory, :count).by(1)
                end

                it "should update the cart item's quantity" do
                    expect(cart_item.quantity).to eq 5
                end

                it "should update the cart item's weight" do
                    expect(cart_item.weight).to eq ((cart_item.sku.weight + cart_item.cart_item_accessory.accessory.weight)*5)
                end

                it "should update the cart item accessory's quantity" do
                    expect(cart_item.cart_item_accessory.quantity).to eq 5
                end
            end
        end

        # context "if its updating an existing cart item" do

        #     context "and the cart item does not have an accessory" do

        #         it "should update the cart item's quantity" do

        #         end

        #         it "should update the cart item's weight" do

        #         end

        #     end

        #     context "and the cart item has an accessory" do

        #         it "should update the cart item's quantity" do

        #         end

        #         it "should update the cart item's weight, including the accessory weight" do

        #         end

        #         it "should update the associated cart item accessory quantity" do

        #         end

        #     end
        # end

    end

    # describe "When deleting a cart item" do

    #     context "if the cart item quantity is more than 1" do

    #         context "if the cart item does not have an accessory" do
    #             let!(:cart_item) { create(:cart_item, quantity: 5)}
    #             before(:each) do
    #                 cart_item.decrement!
    #             end

    #             it "should update the cart item's quantity" do
    #                 expect(cart_item.quantity).to eq 4
    #             end

    #             it "should update the cart item's weight" do
    #                 expect(cart_item.weight).to eq (cart_item.sku.weight*4)
    #             end
    #         end

    #         context "if the cart item has an accessory" do
    #             let!(:cart_item) { create(:accessory_cart_item, quantity: 3) }
    #             before(:each) do
    #                 cart_item.decrement!
    #             end

    #             it "should update the cart item's quantity" do
    #                 expect(cart_item.quantity).to eq 2
    #             end

    #             it "should update the cart item's weight, including the accessory weight" do
    #                 expect(cart_item.weight).to eq ((cart_item.sku.weight + cart_item.cart_item_accessory.accessory.weight)*2)
    #             end

    #             it "should update the associated cart item accessory quantity" do
    #                 expect(cart_item.cart_item_accessory.quantity).to eq 2
    #             end
    #         end
    #     end

    #     context "if the cart item quantity is 1" do
    #         let!(:cart_item) { create(:cart_item, quantity: 1) }

    #         it "should destroy the cart item" do
    #             expect{
    #                 cart_item.decrement!
    #             }.to change(CartItem, :count).by(-1)
    #         end
    #     end
    # end

    # describe  "Updating quantity" do
    #     let!(:cart_item) { create(:update_cart_item_quantity) }

    #     before(:each) do
    #         cart_item.update_quantity(10, cart_item.cart_item_accessory)
    #     end
    #     it "should update the cart_item quantity" do
    #         expect(cart_item.quantity).to eq 10
    #     end
    #     context "if there is a cart_item_accessory" do

    #         it "should update the cart_item_accessory quantity" do
    #             expect(cart_item.cart_item_accessory.quantity).to eq 10
    #         end
    #     end
    # end

    # describe "Update weight" do

    #     context "without a cart_item_accessory" do
    #         let!(:cart_item) { create(:cart_item) }
            
    #         it "should calculate the weight of the cart_item" do
    #             cart_item.update_weight(12, cart_item.sku.weight, nil)
    #             expect(cart_item.weight).to eq (cart_item.sku.weight*12)
    #         end
    #     end

    #     context "with a cart_item_accessory" do
    #         let!(:cart_item) { create(:update_cart_item_weight) }

    #         it "should calculate the weight of the cart_item, including the cart_item_accessory weight" do
    #             cart_item.update_weight(12, cart_item.sku.weight, cart_item.cart_item_accessory.accessory)
    #             expect(cart_item.weight).to eq ((cart_item.sku.weight + cart_item.cart_item_accessory.accessory.weight)*12)
    #         end
    #     end
    # end
end
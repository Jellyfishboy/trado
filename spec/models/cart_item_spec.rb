require 'spec_helper'

describe CartItem do

    # ActiveRecord relations
    it { expect(subject).to belong_to(:sku) }
    it { expect(subject).to belong_to(:cart) }
    it { expect(subject).to have_one(:cart_item_accessory).dependent(:delete) }

    # Nested attributes
    it { expect(subject).to accept_nested_attributes_for(:cart_item_accessory) }

    describe "When calculating a cart item total" do
        let!(:cart_item) { build(:cart_item, price: 12, quantity: 7) }
        it "should return the sum of price multiplied by quantity" do
            expect(cart_item.total_price).to eq 84
        end
    end

    describe "When adding a new cart item" do

        context "if its a new cart item" do

            context "and the cart item does not have an accessory" do
                let(:sku) { create(:sku) }
                let!(:current_cart) { create(:cart) }
                let(:cart_item) { CartItem.increment(sku, 5, nil, current_cart) }

                it "should build a new cart item" do
                    expect{
                        CartItem.increment(sku, 5, nil, current_cart).save(validate: false)
                    }.to change(CartItem, :count).by(1)
                end

                it "should not build a new cart item accessory" do
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

        context "if its updating an existing cart item" do

            context "and the cart item does not have an accessory" do
                let!(:current_cart) { create(:cart) }
                let!(:sku) { create(:sku, weight: '4.78') }
                let!(:cart_item_1) { create(:cart_item, cart: current_cart, sku: sku, quantity: 12, weight: '57.36') }
                let!(:cart_item_2) { create(:cart_item, cart: current_cart, sku: sku, quantity: 14, weight: '189') }
                let!(:accessory) { create(:accessory, weight: '8.72') }
                let!(:cart_item_accessory) { create(:cart_item_accessory, cart_item: cart_item_2, accessory: accessory, quantity: 14) }
                let(:build_cart_item) { CartItem.increment(sku, 3, nil, current_cart).save(validate: false) }

                it "should update the correct cart item's quantity" do
                    expect{
                        build_cart_item
                    }.to change{
                        cart_item_1.reload
                        cart_item_1.quantity
                    }.from(12).to(15)
                end

                it "should not update the cart item's quantity which has an accessory association" do
                    expect(cart_item_2.quantity).to eq 14
                end
                
                it "should update the correct cart item's weight" do
                    expect{
                        build_cart_item
                    }.to change{
                        cart_item_1.reload
                        cart_item_1.weight
                    }.from(BigDecimal.new("57.36")).to(BigDecimal.new("71.7"))
                end

                it "should not update the cart item's weight which has an accessory association" do
                    expect(cart_item_2.weight).to eq BigDecimal.new("189")
                end
            end

            context "and the cart item has an accessory" do
                let!(:current_cart) { create(:cart) }
                let!(:sku) { create(:sku, weight: '4.78') }
                let!(:cart_item_1) { create(:cart_item, cart: current_cart, sku: sku, quantity: 12, weight: '57.36') }
                let!(:cart_item_2) { create(:cart_item, cart: current_cart, sku: sku, quantity: 14, weight: '189') }
                let!(:accessory) { create(:accessory, weight: '8.72') }
                let!(:cart_item_accessory) { create(:cart_item_accessory, cart_item: cart_item_2, accessory: accessory, quantity: 14) }
                let(:param) { Hash({:accessory_id => accessory.id }) }
                let(:build_cart_item) { CartItem.increment(sku, 3, param, current_cart).save(validate: false) }

                it "should update the cart item's quantity" do
                    expect{
                        build_cart_item
                    }.to change{
                        cart_item_2.reload
                        cart_item_2.quantity
                    }.from(14).to(17)
                end

                it "should update the associated cart item accessory quantity" do
                    expect{
                        build_cart_item
                    }.to change{
                        cart_item_2.cart_item_accessory.reload
                        cart_item_2.cart_item_accessory.quantity
                    }.from(14).to(17)
                end

                it "should not update the cart item's quantity which does not have an accessory association" do
                    expect(cart_item_1.quantity).to eq 12
                end

                it "should update the cart item's weight, including the accessory weight" do
                    expect{
                        build_cart_item
                    }.to change{
                        cart_item_2.reload
                        cart_item_2.weight
                    }.from(BigDecimal.new("189")).to(BigDecimal.new("229.5"))
                end

                it "should not update the cart item's weight which does not have an accessory association" do
                    expect(cart_item_1.weight).to eq BigDecimal.new("57.36")
                end

                it "should have the correct accessory assocation" do
                    expect(cart_item_2.cart_item_accessory.accessory.id).to eq accessory.id
                    expect(cart_item_2.cart_item_accessory.accessory.name).to eq accessory.name
                end
            end
        end

    end

    describe  "Updating quantity" do
        let!(:cart_item) { create(:update_cart_item_quantity) }

        before(:each) do
            cart_item.update_quantity(10, cart_item.cart_item_accessory)
        end
        it "should update the cart_item quantity" do
            expect(cart_item.quantity).to eq 10
        end
        context "if there is a cart_item_accessory" do

            it "should update the cart_item_accessory quantity" do
                expect(cart_item.cart_item_accessory.quantity).to eq 10
            end
        end
    end

    describe "Update weight" do

        context "without a cart_item_accessory" do
            let!(:cart_item) { create(:cart_item) }
            
            it "should calculate the weight of the cart_item" do
                cart_item.update_weight(12, cart_item.sku.weight, nil)
                expect(cart_item.weight).to eq (cart_item.sku.weight*12)
            end
        end

        context "with a cart_item_accessory" do
            let!(:cart_item) { create(:update_cart_item_weight) }

            it "should calculate the weight of the cart_item, including the cart_item_accessory weight" do
                cart_item.update_weight(12, cart_item.sku.weight, cart_item.cart_item_accessory.accessory)
                expect(cart_item.weight).to eq ((cart_item.sku.weight + cart_item.cart_item_accessory.accessory.weight)*12)
            end
        end
    end
end
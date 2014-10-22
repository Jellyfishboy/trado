require 'rails_helper'

describe Cart do

    # ActiveRecord relations
    it { expect(subject).to have_many(:cart_items).dependent(:delete_all) }
    it { expect(subject).to have_many(:cart_item_accessories).through(:cart_items) }
    it { expect(subject).to have_many(:skus).through(:cart_items) }
    it { expect(subject).to have_one(:order) }
    it { expect(subject).to belong_to(:estimate_delivery).class_name('DeliveryServicePrice') }

    describe "When retrieving the cart total value" do
        let!(:cart) { create(:cart) }
        let!(:cart_item_1) { create(:cart_item, price: "12", quantity: 1, cart: cart) }
        let!(:cart_item_2) { create(:cart_item, price: "6.50", quantity: 4, cart: cart) }
        let!(:cart_item_3) { create(:cart_item, price: "3.20", quantity: 2, cart: cart) }

        it "should iterate through all cart items and calculate the sum" do
            expect(cart.cart_items.count).to eq 3
            expect(cart.cart_items.sum('quantity')).to eq 7
            expect(cart.total_price).to eq BigDecimal.new("44.40")
        end
    end

    describe "When viewing a cart" do
        let(:cart) { create(:full_cart) }
        let(:calculated_cart) { cart.calculate(20.0)}

        it "should return a hash containing the correct net amount total" do
            expect(calculated_cart[:net_amount]).to eq cart.total_price
        end

        context "if the cart has no associated delivery estimate" do

            it "should return a hash containing the correct tax amount total" do
                expect(calculated_cart[:tax_amount]).to eq cart.total_price * 20.0
            end

            it "should return a hash containing the correct gross amount total" do
                expect(calculated_cart[:gross_amount]).to eq (cart.total_price + (cart.total_price * 20.0))
            end
        end

        context "if the cart has an associated delivery estimate" do
            let!(:delivery) { create(:delivery_service_price) }
            let(:cart) { create(:full_cart, estimate_delivery_id: delivery.id)}
            let(:calculated_cart) { cart.calculate(20.0) }

            it "should return a hash containing the correct tax amount total, with the delivery esimate price" do
                expect(calculated_cart[:tax_amount]).to eq (cart.total_price + cart.estimate_delivery.price) * 20.0
            end

            it "should return a hash containing the correct gross amount total, wih the delivery estimate price" do
                expect(calculated_cart[:gross_amount]).to eq (cart.total_price + cart.estimate_delivery.price + ((cart.total_price + cart.estimate_delivery.price) * 20.0))
            end
        end
    end

    # weight 22.67
    # length 67.2
    # thickness 12.34
    describe "Calculating the relevant delivery service prices for a cart" do
        let(:cart) { create(:tier_calculated_cart) }
        let!(:delivery_service) { create(:delivery_service, active: true)}
        let!(:delivery_service_price_1) { create(:delivery_service_price, active: true, min_weight: '0', max_weight: '26.75', min_length: '0', max_length: '103.23', min_thickness: '0', max_thickness: '22.71') }
        let!(:delivery_service_price_2) { create(:delivery_service_price, active: true, min_weight: '0', max_weight: '18.75', min_length: '0', max_length: '119.23', min_thickness: '0', max_thickness: '49.90') }
        let!(:delivery_service_price_3) { create(:delivery_service_price, active: true, min_weight: '22.67', max_weight: '46.75', min_length: '66.82', max_length: '201.45', min_thickness: '12.33', max_thickness: '52.62') }

        it "should update the cart with the available delivery service prices" do
            expect{
                cart.calculate_delivery_services
            }.to change{
                cart.delivery_service_prices
            }.from(nil).to([delivery_service_price_1.id,delivery_service_price_3.id])
        end
    end

    describe "During a daily scheduled task" do

        context "if the carts are more than 12 hours old" do
            let!(:cart_1) { create(:cart, updated_at: 11.hours.ago) }
            let!(:cart_2) { create(:cart, updated_at: 13.hours.ago) }
            let!(:cart_3) { create(:cart, updated_at: 28.hours.ago) }

            it "should select the correct carts" do
                expect(Cart.clear_carts).to match_array([cart_2, cart_3])
            end

            it "should remove the carts" do
                expect{
                    Cart.clear_carts
                }.to change(Cart, :count).by(-2)
            end
        end
    end
end
require 'rails_helper'

describe ApplicationController do

    describe 'current_cart' do

        context "if there is a cart_id value in the session store" do
            let!(:cart) { create(:cart) }
            before(:each) do
                session[:cart_id] = cart.id
            end

            it "should set current_cart as the associated cart item" do
                expect(subject.send(:current_cart)).to eq cart
            end
        end

        context "if there is no cart_id value in the session store" do
            let(:current_cart) { subject.send(:current_cart) }

            it "should save a new cart item to the database" do
                expect{
                    current_cart
                }.to change(Cart, :count).by(1)
            end

            it "should set the session cart_id value as the new cart item" do
                current_cart
                expect(session[:cart_id]).to eq current_cart.id
            end
        end 
    end
end
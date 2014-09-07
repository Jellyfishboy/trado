require 'rails_helper'

describe Admin::SkusController do

    store_setting
    login_admin

    describe 'GET #edit' do
        let(:product) { create(:product) }
        let(:sku) { create(:sku, product_id: product.id) }

        it "should assign the requested SKU to @form_sku" do
            xhr :get, :edit, product_id: product.id, id: sku.id
            expect(assigns(:form_sku)).to eq sku
        end

        it "should render the edit partial" do
            xhr :get, :edit, product_id: product.id, id: sku.id
            expect(response).to render_template(partial: 'admin/products/skus/_new_edit')
        end
    end

    describe 'PATCH #update' do
        let!(:product) { create(:product, active: true, single: true) }
        let!(:sku) { create(:sku, code: 'sku123', active: true, product_id: product.id) }
        let(:new_sku) { attributes_for(:sku, active: true, product_id: product.id) }
        let(:order) { create(:order) }

        context "if the sku has associated orders" do
            before(:each) do
                create(:order_item, sku_id: sku.id, order_id: order.id)
            end

            it "should set the sku as inactive" do
                expect{
                    xhr :patch, :update, product_id: product.id, id: sku.id, sku: new_sku
                    sku.reload
                }.to change{
                    sku.active
                }.from(true).to(false)
            end

            it "should assign new sku attributes to @sku" do
                xhr :patch, :update, product_id: product.id, id: sku.id, sku: new_sku
                expect(assigns(:sku).price).to eq new_sku[:price]
                expect(assigns(:sku).code).to eq new_sku[:code]
            end

            it "should assign the inactive old sku to @old_sku" do
                xhr :patch, :update, product_id: product.id, id: sku.id, sku: new_sku
                expect(assigns(:old_sku)).to eq sku
            end

            it "should assign the old_sku product_id to @sku" do
                xhr :patch, :update, product_id: product.id, id: sku.id, sku: new_sku
                expect(assigns(:sku).product_id).to eq assigns(:old_sku).product_id
            end
        end

        context "with valid attributes" do
            let!(:stock_level) { create(:stock_level, sku_id: sku.id, description: 'New stock #1') }

            context "if the sku has associated orders" do
                before(:each) do
                    create(:order_item, sku_id: sku.id, order_id: order.id)
                    create_list(:cart_item, 3, sku_id: sku.id)
                end

                it "should delete an related cart items from the database" do
                    expect{
                        xhr :patch, :update, product_id: product.id, id: sku.id, sku: new_sku
                    }.to change(CartItem, :count).by(-3)
                end

                it "should save a new sku to the database" do
                    expect {
                        xhr :patch, :update, product_id: product.id, id: sku.id, sku: new_sku
                    }.to change(Sku, :count).by(1)
                end

                it "should duplicate and save all stock level records" do
                    expect{
                        xhr :patch, :update, product_id: product.id, id: sku.id, sku: new_sku
                    }.to change(StockLevel, :count).by(1)
                end

                it "should have the correct stock level data" do
                    xhr :patch, :update, product_id: product.id, id: sku.id, sku: new_sku
                    sku = Sku.last
                    expect(sku.stock_levels.last.description).to eq 'New stock #1'
                end
            end

            context "if the sku has no associated orders" do
                let(:new_sku) { attributes_for(:sku, active: true) }

                it "should locate the requested @sku" do
                    xhr :patch, :update, product_id: product.id, id: sku.id, sku: new_sku
                    expect(assigns(:sku)).to eq(sku)
                end

                it "should update the sku in the database" do
                    xhr :patch, :update, product_id: product.id, id: sku.id, sku: attributes_for(:sku, code: 'sku234', active: true)
                    sku.reload
                    expect(sku.code).to eq('sku234')
                end

                it "should not duplicate any stock level records" do
                    expect{
                        xhr :patch, :update, product_id: product.id, id: sku.id, sku: new_sku
                    }.to_not change(StockLevel, :count)
                end

                it "should not save a new sku to the database" do
                    expect {
                        xhr :patch, :update, product_id: product.id, id: sku.id, sku: new_sku
                    }.to change(Sku, :count).by(0)
                end
            end
            
            it "should render the success partial" do
                xhr :patch, :update, product_id: product.id, id: sku.id, sku: new_sku
                expect(response).to render_template(partial: 'admin/products/skus/_update')
            end
        end
        context "with invalid attributes" do 
            let(:new_sku) { attributes_for(:invalid_sku, active: true) }
            before(:each) do
                xhr :patch, :update, product_id: product.id, id: sku.id, sku: new_sku
            end

            it "should not update the sku" do
                sku.reload
                expect(sku.code).to eq('sku123')
            end

            it "should assign the old_sku to @form_sku" do
                expect(assigns(:form_sku)).to eq sku
            end

            it "should set the old_sku as active" do
                expect(sku.active).to eq true
            end

            it "should assign the @form_sku attributes with the current params sku" do
                expect(assigns(:form_sku).attributes["price"]). to eq new_sku[:price]
                expect(assigns(:form_sku).attributes["code"]).to eq new_sku[:code]
            end
        end 
    end

    describe 'DELETE #destroy' do
        let(:product) { create(:product) }
        let(:sku) { create(:sku, active: true, product_id: product.id) }
        let(:order) { create(:order) }
        let(:cart) { create(:cart) }

        context "if the parent product has more than one SKU" do
            before(:each) do
                create(:sku, active: true, product_id: sku.product.id)
            end

            context "if the sku has associated orders" do
                before(:each) do
                    create(:order_item, order_id: order.id, sku_id: sku.id)
                end

                it "should set the sku as inactive" do
                    expect{
                        xhr :delete, :destroy, product_id: product.id, id: sku.id
                        sku.reload
                    }.to change{
                        sku.active
                    }.from(true).to(false)
                end

                it "should not delete the SKU from the database" do
                    expect{
                        xhr :delete, :destroy, product_id: product.id, id: sku.id
                    }.to change(Sku, :count).by(0)
                end
            end

            context "if the sku has no associated orders" do

                it "deletes the sku from the database"  do
                    expect {
                        xhr :delete, :destroy, product_id: product.id, id: sku.id
                    }.to change(Sku, :count).by(-1)
                end
            end

            context "if the sku has associated carts" do
                before(:each) do
                    create(:cart_item, cart_id: cart.id, sku_id: sku.id)
                end

                it "should delete all associated cart item skus from the database" do
                    expect{
                        xhr :delete, :destroy, product_id: product.id, id: sku.id
                    }.to change(CartItem, :count).by(-1)
                end
            end

            it "should render the destroy partial" do
                xhr :delete, :destroy, product_id: product.id, id: sku.id
                expect(response).to render_template(partial: 'admin/products/skus/_destroy')
            end
        end
    end
end
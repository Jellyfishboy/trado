require 'rails_helper'

describe Admin::SkusController do

    store_setting
    login_admin

    describe 'GET #new' do
        let!(:product) { create(:product, active: true) }

        it "should create a new Sku record" do
            xhr :get, :new, product_id: product.id
            expect(assigns(:form_sku)).to be_a_new(Sku)
        end

        it "should create a new SkuVariant record" do
            xhr :get, :new, product_id: product.id
            expect(assigns(:variant)).to be_a_new(SkuVariant)
        end

        it "should render the new partial" do
            xhr :get, :new, product_id: product.id
            expect(response).to render_template(partial: 'admin/products/skus/_new_edit')
        end
    end

    describe 'POST #create' do
        let!(:product) { create(:product, active: true) }

        context "with valid attributes" do

            it "should save the new sku in the database" do
                expect {
                    xhr :post, :create, product_id: product.id, sku: attributes_for(:sku)
                }.to change(Sku, :count).by(1)
            end
            it "should render the create partial"  do
                xhr :post, :create, product_id: product.id, sku: attributes_for(:sku)
                expect(response).to render_template(partial: 'admin/products/skus/_create')
            end
        end
        context "with invalid attributes" do
            let(:errors) { ["Code can't be blank"] }

            it "should not save the new sku in the database" do
                expect {
                    xhr :post, :create, product_id: product.id, sku: attributes_for(:invalid_sku)
                }.to_not change(Sku, :count)
            end

            it "should return a JSON object of errors" do
                xhr :post, :create, product_id: product.id, sku: attributes_for(:invalid_sku)
                expect(assigns(:form_sku).errors.full_messages).to eq errors
            end

            it "should return a 422 status code" do
                xhr :post, :create, product_id: product.id, sku: attributes_for(:invalid_sku)
                expect(response.status).to eq 422
            end
        end 
    end

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
        let!(:product) { create(:product, active: true) }
        let!(:sku) { create(:skip_after_stock_adjustment_sku, code: 'sku123', active: true, product_id: product.id) }
        let(:new_sku) { attributes_for(:skip_after_stock_adjustment_sku, active: true, product_id: product.id) }
        let(:order) { create(:order) }
        before(:each) do
            create(:sku_variant, sku_id: sku.id)
        end

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
            let!(:stock_adjustment) { create(:stock_adjustment, sku_id: sku.id, description: 'New stock #1') }

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

                it "should duplicate and save all stock adjustment records" do
                    expect{
                        xhr :patch, :update, product_id: product.id, id: sku.id, sku: new_sku
                    }.to change(StockAdjustment, :count).by(1)
                end

                it "should duplicate and save all sku variant records" do
                    expect{
                        xhr :patch, :update, product_id: product.id, id: sku.id, sku: new_sku
                    }.to change(SkuVariant, :count).by(1)
                end

                it "should have the correct stock adjustment data" do
                    xhr :patch, :update, product_id: product.id, id: sku.id, sku: new_sku
                    sku = Sku.last
                    expect(sku.stock_adjustments.first.description).to eq 'New stock #1'
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

                it "should not duplicate any stock adjustment records" do
                    expect{
                        xhr :patch, :update, product_id: product.id, id: sku.id, sku: new_sku
                    }.to_not change(StockAdjustment, :count)
                end

                it "should not duplicate any sku variant records" do
                    expect{
                        xhr :patch, :update, product_id: product.id, id: sku.id, sku: new_sku
                    }.to_not change(SkuVariant, :count)
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
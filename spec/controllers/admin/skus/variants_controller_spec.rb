require 'rails_helper'

describe Admin::Skus::VariantsController do

    store_setting
    login_admin

    describe 'GET #new' do
        let!(:product) { create(:product, active: true) }
        let!(:variant_type) { create(:variant_type) }

        it "should assign the associated product to @product" do
            xhr :get, :new, product_id: product.id
            expect(assigns(:product)).to eq product
        end

        it "should assign all variant types to @variant_types" do
            xhr :get, :new, product_id: product.id
            expect(assigns(:variant_types)).to match_array([variant_type])
        end

        it "should render the new partial" do
            xhr :get, :new, product_id: product.id
            expect(response).to render_template('admin/products/skus/variants/_new')
        end
    end

    describe 'POST #create' do
        let!(:product) { create(:product_sku, active: true) }
        let!(:colour_variant_type) { create(:variant_type, name: 'Colour') }
        let!(:size_variant_type) { create(:variant_type, name: 'Size') }

        context "if there are no variants in the parameters array" do

            it "should return an error" do
                xhr :post, :create, product_id: product.id, colour: '', size: ''
                expect(response.body).to eq "{\"errors\":[\"Variant options can't be blank\"]}"
            end

            it "should return a 422 status code" do
                xhr :post, :create, product_id: product.id, colour: '', size: ''
                expect(response.status).to eq 422
            end
        end

            it "should create the correct number of sku records" do
                expect{
                    xhr :post, :create, product_id: product.id, colour: 'Blue, Red, Green', size: '100g, 250g'
                }.to change(Sku, :count).by(6)
            end

            it "should create the correct number of sku variant records" do
                expect{
                    xhr :post, :create, product_id: product.id, colour: 'Blue, Red, Green', size: '100g, 250g'
                }.to change(SkuVariant, :count).by(12)
            end

            it "should have the correct data for the sku variants" do
                xhr :post, :create, product_id: product.id, colour: 'Blue, Red, Green', size: '100g, 250g'
                expect(product.variant_collection_by_type('Colour').map(&:name).uniq).to match_array(["Blue", "Green", "Red"])
                expect(product.variant_collection_by_type('Size').map(&:name).uniq).to match_array(["100g", "250g"])
            end

            it "should render the create partial" do
                xhr :post, :create, product_id: product.id, colour: 'Blue, Red, Green', size: '100g, 250g'
                expect(response).to render_template('admin/products/skus/variants/_create')
            end
    end

    describe 'POST #update' do
        let!(:product) { create(:product_sku, active: true) }
        let!(:sku) { create(:sku, active: true, product_id: product.id) }
        let!(:colour_variant_type) { create(:variant_type, name: 'Colour') }
        let!(:size_variant_type) { create(:variant_type, name: 'Size') }
        let!(:variant_500) {create(:sku_variant, name: '500g', sku_id: product.skus.first.id, variant_type_id: size_variant_type.id) }
        let!(:variant_red) { create(:sku_variant, name: 'Red', sku_id: sku.id, variant_type_id: colour_variant_type.id) }
        let!(:variant_1000) { create(:sku_variant, name: '1kg', sku_id: sku.id, variant_type_id: size_variant_type.id) }
        let!(:variant_blue) { create(:sku_variant, name: 'Blue', sku_id: product.skus.first.id, variant_type_id: colour_variant_type.id) }

        it "should remove skus which are associated with variants which need to be deleted" do
            expect{
                xhr :post, :update, product_id: product.id, colour: 'Blue', size: '500g'
            }.to change(Sku, :count).by(-1)
        end

        it "should remove variants which are not present in parameters array" do
            expect{
                xhr :post, :update, product_id: product.id, colour: 'Blue', size: '500g'
            }.to change(SkuVariant, :count).by(-2)
        end 

        it "should have the correct sku variants remaining" do
            xhr :post, :update, product_id: product.id, colour: 'Blue', size: '500g'
            expect(product.variant_collection_by_type('Colour')).to match_array([variant_blue])
            expect(product.variant_collection_by_type('Size')).to match_array([variant_500])
        end

        it "should render the update partial" do
            xhr :post, :update, product_id: product.id, colour: 'Blue', size: '500g'
            expect(response).to render_template('admin/products/skus/variants/_update')
        end
    end

    describe 'DELETE #destroy' do
        let!(:product) { create(:product_sku, active: true) }

        context "if the skus have associated orders" do
            before(:each) do
                create(:order_item, sku_id: product.skus.first.id)
            end

            it "should active archive all the associated skus" do
                expect{
                    xhr :delete, :destroy, product_id: product.id
                }.to change{
                    product.skus.first.active
                }.from(true).to(false)
            end
        end

        context "if the skus have no associated orders" do

            it "should remove the associated skus from the database" do
                expect{
                    xhr :delete, :destroy, product_id: product.id
                }.to change(Sku, :count).by(-1)
            end
        end

        it "should render the destroy partial" do
            xhr :delete, :destroy, product_id: product.id 
            expect(response).to render_template('admin/products/skus/variants/_destroy')
        end
    end
end
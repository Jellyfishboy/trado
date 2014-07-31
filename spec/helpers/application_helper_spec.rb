require 'rails_helper'

describe ApplicationHelper do

    store_setting

    describe '#category_list' do
        let!(:category_1) { create(:category, sorting: 0) }
        let!(:category_2) { create(:category, sorting: 1) }
        before(:each) do
            create(:product, category_id: category_1.id, active: true)
            create(:product, category_id: category_2.id, active: true)
        end

        it "should return a list of active categories sorted by their sorting attribute value" do
            expect(helper.category_list).to match_array([category_1, category_2])
        end
    end

    describe '#active_controller?' do
        before(:each) do
            helper.stub(:params) { { controller: 'product' } }
        end

        context "if the controller parameter equals the parameter[:controller] value" do

            it "should return the 'current' class name" do
                expect(helper.active_controller?('product')).to eq 'current'
            end
        end

        context "if the controller parameter does not equal the parameter[:controller] value" do

            it "should return nil" do
                expect(helper.active_controller?('category')).to eq nil
            end
        end
    end

    describe '#active_category?' do

        context "if params[:category_id] has a value" do    
            before(:each) do
                helper.stub(:params) { { category_id: 5 } }
            end

            context "if the id parameter equals params[:category_id]" do

                it "should return the 'active' class name" do
                    expect(helper.active_category?(5)).to eq 'active'
                end
            end

            context "if the id parameter does not equal params[:category_id]" do

                it "should return nil" do
                    expect(helper.active_category?(3)).to eq nil
                end
            end
        end

        context "if params[:id] has a value" do    
            before(:each) do
                helper.stub(:params) { { id: 7 } }
            end

            context "if the id parameter equals params[:id]" do

                it "should return the 'active' class name" do
                    expect(helper.active_category?(7)).to eq 'active'
                end
            end

            context "if the id parameter does not equal params[:id]" do

                it "should return nil" do
                    expect(helper.active_category?(10)).to eq nil
                end
            end
        end

    end

    describe '#active_page?' do
        before(:each) do
            helper.stub(:params) { { controller: 'product', action: 'show' } }
        end

        context "if the controller and action parameter equals the parameter[:controller] and params[:action] value" do

            it "should return the 'active' class name" do
                expect(helper.active_page?('product', 'show')).to eq 'active'
            end
        end

        context "if the controller and action parameter does not equal the parameter[:controller] or params[:action] value" do

            it "should return nil" do
                expect(helper.active_page?('category', 'show')).to eq nil
            end
        end
    end

    describe '#create_store_breadcrumbs' do

        it "should return an array of breadcrumb hash objects" do
            expect(helper.create_store_breadcrumbs).to eq [{:title=>"Home", :url=>"/"}]
        end
    end

    describe '#store_breadcrumb_add' do
        before(:each) do
            helper.store_breadcrumb_add('test', '/test')
        end

        it "should add a new hash object to the create_store_breadcrumbs array" do
            expect(helper.create_store_breadcrumbs).to eq [{:title=>"Home", :url=>"/"},{:title=>"test", :url=>"/test"}]
        end
    end

    describe '#create_admin_breadcrumbs' do

        it "should return an array of breadcrumb hash objects" do
            expect(helper.create_admin_breadcrumbs).to eq [{:title=>Store::settings.name, :url=>"/admin"}]
        end
    end

    describe '#breadcrumb_add' do
        before(:each) do
            helper.breadcrumb_add('new', '/new')
        end

        it "should add a new hash object to the create_admin_breadcrumbs array" do
            expect(helper.create_admin_breadcrumbs).to eq [{:title=>Store::settings.name, :url=>"/admin"},{:title=>"new", :url=>"/new"}]
        end
    end
end
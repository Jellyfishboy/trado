require 'rails_helper'

describe Admin::AttachmentsController do

    store_setting
    login_admin

    describe 'DELETE #destroy' do
        let!(:product) { create(:product) }
        let!(:attachment) { create(:product_attachment, attachable: product) }

        it "should assign the requested attachment to @attachment" do
            xhr :delete, :destroy, product_id: attachment.attachable.id, id: attachment.id
            expect(assigns(:attachment)).to eq attachment
        end

        context "if the parent item attachment count is more than one" do

            it "should destroy the attachment" do
                expect{
                    xhr :delete, :destroy, product_id: attachment.attachable.id, id: attachment.id
                }.to change(Attachment, :count).by(-1)
            end
        end
    end
end
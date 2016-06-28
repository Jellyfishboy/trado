# == Schema Information
#
# Table name: redactor_assets
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  data_file_name    :string           not null
#  data_content_type :string
#  data_file_size    :integer
#  assetable_id      :integer
#  assetable_type    :string(30)
#  type              :string(30)
#  width             :integer
#  height            :integer
#  created_at        :datetime
#  updated_at        :datetime
#

class RedactorRails::Asset < ActiveRecord::Base
  include RedactorRails::Orm::ActiveRecord::AssetBase
  delegate :url, :current_path, :size, :content_type, :filename, :to => :data
  validates_presence_of :data
end

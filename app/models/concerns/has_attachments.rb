module HasAttachments
  extend ActiveSupport::Concern

  included do
    validate :attachment_count, if: :published?, on: :create
  end

  # Calculate if a product has at least one associated attachment
  # If no associated attachments exist, return an error
  #
  def attachment_count
    if self.attachments.map(&:default_record).count == 0
      errors.add(:product, " must have at least one attachment.")
      return false
    end
  end
end
class Message
    include ActiveModel::Validations
    include ActiveModel::Conversion
    extend ActiveModel::Naming

    attr_accessor :name, :email, :website, :message

    validates :name, :message,                                              presence: true
    validates :email,                                                       presence: { message: 'is required' }, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
    validates :message,                                                     length: { maximum: 500, message: :too_long }

    def initialize(attributes = {})
        attributes.each do |name, value|
            send("#{name}=", value)
        end
    end

    def persisted?
        false
    end
end
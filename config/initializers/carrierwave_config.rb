CarrierWave.configure do |config|
    config.storage = :file
end

module Carrierwave
    module MiniMagick
        def quality(percentage)
            manipulate! do |img|
                img.quality(percentage.to_s)
                img = yield(img) if block_given?
                img
            end
        end
    end
end
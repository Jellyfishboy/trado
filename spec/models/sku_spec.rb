require 'spec_helper'

describe Sku do

    # Validation
    it "is valid with price, cost value, stock, length, weight, thickness, stock warning level, attribute value and attribute type id"
    it "is invalid without a price"
    it "is invalid without a cost value"
    it "is invalid without a stock"
    it "is invalid without a length"
    it "is invalid without a weight"
    it "is invalid without a thickness"
    it "is invalid without a stock warning level"
    it "is invalid without a attribute value"
    it "is valid with length, weight and thickness equal to or greater than 0"
    it "is invalid with length less than 0"
    it "is invalid with weight less than 0"
    it "is invalid with thickness less than 0"
    it "is valid with stock and stock warning level equal to or greater than 1"
    it "is invalid with stock less than 1"
    it "is invalid with stock warning level less than 1"
    it "is valid with stock and stock warning level as an integer"
    it "is invalid when stock is not an integer"
    it "is invalid when stock warning leve is not an integer"
    it "is valid with a unique sku"
    it "is invalid without a unique sku"
    it "is valid with a unique attribute value within the scope of it's product"
    it "is invalid without a unique attribute value within the scope of it's product"
end
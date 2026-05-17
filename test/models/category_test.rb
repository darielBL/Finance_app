require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  test "should be valid with name" do
    category = Category.new(name: "Test Category")
    assert category.valid?
  end

  test "name should be present" do
    category = Category.new(name: "")
    assert_not category.valid?
    # Aceptar cualquier mensaje de error (inglés o español)
    assert category.errors[:name].any?
  end
end
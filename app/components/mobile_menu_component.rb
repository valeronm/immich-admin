class MobileMenuComponent < ViewComponent::Base
  def initialize(image_url:, user_name: nil, user_email: nil)
    @image_url = image_url
    @user_name = user_name || "User Name"
    @user_email = user_email || "user@example.com"
  end

  private

  attr_reader :image_url, :user_name, :user_email
end

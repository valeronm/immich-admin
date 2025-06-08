module Navbar
  class ProfileMenuComponent < ViewComponent::Base
    def initialize(image_path:, user_name: nil, user_email: nil)
      @image_path = image_path
      @user_name = user_name
      @user_email = user_email
    end

    private

    attr_reader :image_path, :user_name, :user_email

    def image_url
      asset_path(image_path, skip_pipeline: true)
    end
  end
end

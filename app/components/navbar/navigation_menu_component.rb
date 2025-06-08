module Navbar
  class NavigationMenuComponent < ViewComponent::Base
    def initialize(current_controller:, mobile: false)
      @current_controller = current_controller
      @mobile = mobile
    end

    private

    attr_reader :current_controller, :mobile

    def current?(controller_name)
      current_controller == controller_name
    end
  end
end

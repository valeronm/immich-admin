module Navbar
  class NavLinkComponent < ViewComponent::Base
    def initialize(href:, text:, current: false, mobile: false)
      @href = href
      @text = text
      @current = current
      @mobile = mobile
    end

    private

    attr_reader :href, :text, :current, :mobile

    def base_classes
      %w[rounded-md px-3 py-2 font-medium]
    end

    def mobile_classes
      mobile ? %w[block text-base] : %w[text-sm]
    end

    def current_classes
      current ? %w[bg-gray-900 text-white] : %w[text-gray-300 hover:bg-gray-700 hover:text-white]
    end

    def classes
      base_classes + current_classes + mobile_classes
    end
  end
end

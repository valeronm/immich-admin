module Navbar
  class ProfileMenuLinkComponent < ViewComponent::Base
    def initialize(href:, text:, method: :get, menu_item_id: nil)
      @href = href
      @text = text
      @method = method
      @menu_item_id = menu_item_id
    end

    private

    attr_reader :href, :text, :method, :menu_item_id

    def link?
      method == :get
    end

    def classes
      "hover:bg-gray-100 hover:outline-hidden block px-4 py-2 text-sm text-gray-700 w-full text-left cursor-pointer"
    end

    def html_attributes
      {
        role: "menuitem",
        tabindex: "-1",
        id: menu_item_id,
        class: classes
      }
    end
  end
end

class MobileProfileLinkComponent < ViewComponent::Base
  def initialize(href:, text:, method: :get)
    @href = href
    @text = text
    @method = method
  end

  private

  attr_reader :href, :text, :method

  def link?
    method == :get
  end

  def classes
    "block rounded-md px-3 py-2 text-base font-medium text-gray-400 hover:bg-gray-700 hover:text-white"
  end
end

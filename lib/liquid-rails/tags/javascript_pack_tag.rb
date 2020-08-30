# frozen_string_literal: true

# Returns a JavaScript tag with the content inside.
#
# Usage:
#
# {% javascript_tag %}
#   alert('Hello Liquid Rails!');
# {% endjavascript_tag %}

module Liquid
  module Rails
    class JavascriptPackTag < ::Liquid::Tag
      include Webpacker::Helper
      include ActionView::Helpers::TagHelper

      def render(context)
        javascript_pack_tag(super, type: 'text/javascript')
      end
    end
  end
end

Liquid::Template.register_tag('javascript_pack_tag', Liquid::Rails::JavascriptPackTag)

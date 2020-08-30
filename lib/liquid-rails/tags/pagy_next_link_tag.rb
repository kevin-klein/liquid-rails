# frozen_string_literal: true

# Paginate a collection
#
# Usage:
#
# {% paginate listing.photos by 5 %}
#   {% for photo in paginate.collection %}
#     {{ photo.caption }}
#   {% endfor %}
#  {% endpaginate %}
#

class Pagy
  def to_liquid
    self
  end
end

module Liquid
  module Rails
    class PaginationParser < Parslet::Parser
      rule(:eof) { any.absent? }
      rule(:space) { match(/\s/).repeat.ignore }
      rule(:paginate_tag) { expression.as(:pagy) >> space >> expression.as(:text) >> space >> expression.as(:html_options) >> space >> eof }
      rule(:text) { (match(/\s/).absent? >> any).repeat }
      rule(:expression) { string | text }

      def string
        str("'") >> (
          str('\\') >> any | str("'").absent? >> any
        ).repeat >> str("'")
      end

      root(:paginate_tag)
    end

    class PagyNextLinkTag < ::Liquid::Tag
      include Pagy::Frontend

      def initialize(tag_name, markup, context)
        super

        @ast = PaginationParser.new.parse(markup)

        @pagy = Expression.parse(@ast[:pagy].to_s)
        @text = Expression.parse(@ast[:text].to_s)
        @html_options = Expression.parse(@ast[:html_options].to_s)
        # if markup =~ Syntax
        #   @collection_name = Regexp.last_match(1)
        #   @page_size = if Regexp.last_match(2)
        #                  Regexp.last_match(3).to_i
        #                else
        #                  25
        #   end
        #
        #   @attributes = { 'window_size' => 3 }
        #   markup.scan(Liquid::TagAttributes) do |key, value|
        #     @attributes[key] = value
        #   end
        # else
        #   raise SyntaxError, "Syntax Error in tag 'paginate' - Valid syntax: paginate [collection] by number"
        # end
      end

      def render(context)
        text = context.evaluate(@text)
        pagy = context.evaluate(@pagy)
        html_options = context.evaluate(@html_options)

        pagy_next_link(pagy, text, html_options)
      end
    end
  end
end

Liquid::Template.register_tag('pagy_next_link', Liquid::Rails::PagyNextLinkTag)

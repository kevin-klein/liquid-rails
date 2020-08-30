# frozen_string_literal: true

# Returns a Google Analytics tag.
#
# Usage:
#
# {% google_analytics_tag 'UA-XXXXX-X' %}

module Liquid
  module Rails
    class GoogleAnalyticsTag < ::Liquid::Tag
      SYNTAX = /(#{::Liquid::QuotedFragment}+)?/.freeze

      def initialize(tag_name, markup, tokens)
        match = markup =~ SYNTAX

        raise ::Liquid::SyntaxError, "Syntax Error in 'google_analytics_tag' - Valid syntax: google_analytics_tag <account_id>" unless match

        @account_id = Regexp.last_match(1).delete('\'')

        super
      end

      def render(_context)
        %{
        <script type="text/javascript">

          (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
          (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
          m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
          })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
          ga('create', '#{@account_id}', 'auto');
          ga('send', 'pageview');

        </script>
        }
      end
    end
  end
end

Liquid::Template.register_tag('google_analytics_tag', Liquid::Rails::GoogleAnalyticsTag)

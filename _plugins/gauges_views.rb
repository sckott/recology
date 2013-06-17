# Title: gauges_views.rb
# Author: Scott Chamberlain, @recology_
# Licence: CC0
# Description: Get Gaug.es analytics for a page
#
# Example use: 
#
# {{ page.url | gauges_views }}

require 'twelve'
require 'date'

module Jekyll
  module GaugesModFilter
    def gauges_views(input)
      bfg = Twelve.new('6e57f116f7933ee6c4d76efcc213081b')
      today = Date.today.to_s()
      out = bfg.gauges('4efd83a6f5a1f5158a000004').content(today)
      if h = out['content'].find { |h| h['path'] == input}
        pviews = h['views']
      else
        pviews = 0
      end
      pviews
    end
  end
end
Liquid::Template.register_filter(Jekyll::GaugesModFilter)
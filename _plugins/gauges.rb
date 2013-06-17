# ## A plugin that uses the twelve gem for the gaug.es API
# # Author: Scott Chamberlain
# # Licence: CC0
# # Date: 2013-06-15
# #
# # Installation:
# #   
# #   Install the twelve gem from: 
# #   https://github.com/jonmagic/twelve by doing 
# #   gem install twelve  
# #   Then place this script in the _plugins directory and change to 
# #   your info. 
# # 
# # Usage: 
# # 
# #  Use by invoking the liquid code: (Note: No spaces around page.url!) 
# #      {% gspageviews %}{{page.url}}{% endgspageviews %}
# #  to show the pageviews of page.url.  Update the start date below,
# #  or remove to show views in the last 30 days.  Of course the analytics
# #  data shown can be arbitrarily customized, see the garb gem repository
# #  for details.  

# require 'twelve'
# require 'date'

# module Jekyll

#   class Gauges < Generator

#     safe true
#     priority :low

#     def generate(site)

#       now = Date.today
#       last30dates = (now<<1 .. now).map{ |day| day.strftime }

#       @bfg = Twelve.new('6e57f116f7933ee6c4d76efcc213081b')
#       # today = Date.today.to_s()
#       # ago30 = Date.today-30
#       # ago30 = ago30.to_s()
#       # out = bfg.gauges('4efd83a6f5a1f5158a000004').content(today)

#       # def gaugesbydate(date)
#       #   date   
#       # end 

#       def gaugesbydate(date)
#         out = @bfg.gauges('4efd83a6f5a1f5158a000004').content(date)
#         out2 = out['content']
#         out2.map!{ |x| [x['path'],x['views']] }
#       end # end gaugesbydate

#       alldat = last30dates.map!{ |x| gaugesbydate(x) }

#       def flat_hash(hash, k = [])
#         return {k => hash} unless hash.is_a?(Hash)
#         hash.inject({}){ |h, v| h.merge! flat_hash(v[-1], k + [v[0]]) }
#       end

#       alldat # summarise data by path string
      
#     end # end generate

#   end # end class Gauges

# end # end module Jekyll
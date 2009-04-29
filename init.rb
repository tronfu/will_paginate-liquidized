# let WillPaginate play nice with Liquid
#WillPaginate.send :include, WillPaginate::Liquidized

# register a WillPaginate Liquid filter 
Liquid::Template.register_filter(WillPaginate::Liquidized::ViewHelpers)


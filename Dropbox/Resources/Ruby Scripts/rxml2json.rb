#!/usr/bin/env ruby -w

require 'rubygems'
require 'nokogiri'
require 'httparty'
require 'Pry'
require 'JSON'

def scrapeXML(host, uri, data)
    xml = Nokogiri::XML(HTTParty.get(host+uri).to_s)

    xml.css("loc").each do |sitemap|
        uri = sitemap.inner_text || ''
        uri = uri.gsub(host, '')
        uri = uri.chomp('/')

        if uri.index('.xml')
            # keep searching
            scrapeXML(host, uri, data)
        else
            # uri_pieces = uri.split('/')
            #
            # while true do
            #     piece = uri_pieces.pop()
            #     if uri_pieces.length > 1
            #         data[piece] ||= {}
            #     else
            #         data[piece] ||= []
            #     end
            #     data[piece].push(inner_node)
            # end

            if uri.index('/blog/')
                data['blog'] ||= []
                data['blog'].push(uri)
            else
                data['misc'] ||= []
                data['misc'].push(uri)
            end
        end
    end
    return data
end


# "planYour": {
#     "packages": {
#         "/packages": "packages",
#         "/packages/?tab=all&p=super_ambassador_luau": "super ambassador luau",
#

def scrapeHTML(host, uri)
    links = {}
    html = Nokogiri::HTML(HTTParty.get(host+uri).to_s)
    # sections = html.css('#menu-main-menu-1 > li')
    html.css('a').each do |link|
        text = link.inner_text
        link = link["href"]

        if link.to_s.index("#{host}#{uri}")
            links[link.gsub(host, '')] = text
        end
    end
    #
    #     sub_nodes = section.css('> ul > li')
    #     # Sub Menu
    #     if sub_nodes.any?
    #         sub_nodes.each do |sub_node|
    #             sub_title = sub_node.css('.fusion-megamenu-title ')
    #
    #             sub_sub_nodes = sub_node.css('ul li')
    #             if sub_sub_nodes.any?
    #                 if sub_title
    #                 end
    #             else
    #             end
    #         end
    #     else
    #         links[link] ||= {}
    #     end
    #
    #     links[section_text].push()
    # end
    #     .each { |e| puts e.css('a') }
    # Pry.start(binding)
    #
    # xml.css("loc").each do |sitemap|
    #     uri = sitemap.inner_text || ''
    #     uri = uri.gsub(host, '')
    #     uri = uri.chomp('/')
    # end
    links
end
# "https://harvestright.com/"
# "https://harvestright.com/how-it-works/"
# "https://harvestright.com/why-its-better/"
# "https://harvestright.com/will-it-freeze-dry/"
# "https://harvestright.com/built-to-save/"
# "https://harvestright.com/video-gallery/"
# "https://harvestright.com/blog/"
# "https://harvestright.com/faqs/"
# "https://harvestright.com/resources/"
# "https://harvestright.com/scientific/">SCIENTIFIC FREEZE DRYER</a></div></li><li class="smail_mobile_sub menu-item menu-item-type-post_type menu-item-object-page menu-item-561221 fusion-megamenu-submenu fusion-megamenu-columns-3 col-lg-4 col-md-4 col-sm-4" style="width:183.3326px;max-width:183.3326px;" data-width="183.3326"><div class="fusion-megamenu-title"><a href="https://harvestright.com/restaurant/">RESTAURANT FREEZE DRYER</a></div></li></ul></div><div style="clear:both;"></div></div></div></li><li class="distop_hide menu-item menu-item-type-custom menu-item-object-custom menu-item-563402"><a href="https://harvestright.com/scientific/" style="line-height: 63px; height: 63px;"><span class="menu-text">SCIENTIFIC FREEZE DRYER</span></a></li><li class="distop_hide menu-item menu-item-type-custom menu-item-object-custom menu-item-563403"><a href="https://harvestright.com/restaurant/" style="line-height: 63px; height: 63px;"><span class="menu-text">RESTAURANT FREEZE DRYER</span></a></li><li class="menu-item menu-item-type-custom menu-item-object-custom menu-item-has-children menu-item-279833 fusion-dropdown-menu" style=""><a href="#" aria-haspopup="true" style="line-height: 63px; height: 63px;"><span class="menu-text">Greenhouses</span></a><ul class="sub-menu"><li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-268046 fusion-dropdown-submenu"><a href="https://harvestright.com/greenhouse-why-its-better/"><span class="">Why It’s Better</span></a></li><li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-268044 fusion-dropdown-submenu"><a href="https://harvestright.com/next-level-gardening/"><span class="">Next Level Gardening</span></a></li><li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-268045 fusion-dropdown-submenu"><a href="https://harvestright.com/greenhouse-sizes/"><span class="">Sizes</span></a></li></ul></li><li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-258459"><a href="https://harvestright.com/shelters/" style="line-height: 63px; height: 63px;"><span class="menu-text">Emergency Shelters</span></a></li><li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-150479"><a href="https://harvestright.com/company/" style="line-height: 63px; height: 63px;"><span class="menu-text">Company</span></a></li><li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-150480"><a href="https://harvestright.com/store/" style="line-height: 63px; height: 63px;"><span class="menu-text">Store</span></a></li><li class="fusion-custom-menu-item fusion-menu-login-box"><a href="https://harvestright.com/my-account/" style="line-height: 63px; height: 63px;"><span class="menu-text">My Account</span></a><div class="fusion-custom-menu-item-contents"><form action="https://harvestright.com/wp-login.php" name="loginform" method="post"><p><input type="text" class="input-text" name="log" id="username" value="" placeholder="Username"></p><p><input type="password" class="input-text" name="pwd" id="password" value="" placeholder="Password"></p><p class="fusion-remember-checkbox"><label for="fusion-menu-login-box-rememberme"><input name="rememberme" type="checkbox" id="fusion-menu-login-box-rememberme" value="forever"> Remember Me</label></p><input type="hidden" name="fusion_woo_login_box" value="true"><p class="fusion-login-box-submit"><input type="submit" name="wp-submit" id="wp-submit" class="button small default comment-submit" value="Log In"><input type="hidden" name="redirect" value="/"></p></form><a class="fusion-menu-login-box-register" href="https://harvestright.com/my-account/" title="Register">Register</a></div></li><li class="fusion-custom-menu-item fusion-menu-cart fusion-main-menu-cart fusion-widget-cart-counter"><a class="fusion-main-menu-icon" href="https://harvestright.com/cart/" style="line-height: 63px; height: 63px;"><span class="menu-text"></span></a></li></ul></div>


# Grab the XML
# nodes = scrapeXML("https://harvestright.com", "/sitemap.xml", {})

# Grab the menu
nodes = scrapeHTML("https://harvestright.com", "/")
puts nodes.to_json

# if %w(y 1).include? gets.chomp.downcase
#
# else
#
# end

#!/usr/bin/env ruby
# encoding: utf-8
#
require 'mechanize'

agent = Mechanize.new
#agent.user_agent_alias = 'Windows Chrome'
#agent.pluggable_parser.default = Mechanize::Download

# 下载7z文件解压工具
## p7z=''
## agent.get('https://www.7-zip.org') do |page|
##   page.link_with(text: /Download/, href: /x64/) do |link|
##     p7z = link.click.save
##   end
## end
## # puts p7z.class
## # pp p7z
## system(p7z) # 安装

# 登录蓝奏云
page = agent.get('http://lanzou.com/u').iframe_with(src: /mydisk/).click
lz_form = page.form('user_form')
lz_form.username = ''
lz_form.password = ''
pp lz_form
puts "-----------"
pp page
lz_bt = lz_form.button_with(type: /submit/)
puts '--bt'
pp lz_bt

#subpage = agent.submit(lz_form, lz_bt)
subpage = agent.submit(lz_form,lz_bt)
puts '---subpage'
pp subpage
puts '-+-+-+-+-+-+'
subpage = agent.submit(lz_form,lz_bt)
puts '---new-subpage'
pp subpage
puts '-+-+-+-+-+-+'
#pp subpage.links[1].click.links[1].click.iframe.click
pp subpage.link_with(href: /mydisk/)
pp subpage.links[4].click
pp subpage.links[4].click.iframe_with(src: /mydisk/).click.links
new_form =  subpage.links[4].click.iframe_with(src: /mydisk/).click.link_with(text: /tools/).click.form('file_form')
newpage = agent.submit new_form
puts 'xxxxxxxxx'
pp newpage

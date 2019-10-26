#!/usr/bin/env ruby
# encoding: utf-8

# for examples
# see https://readysteadycode.com/howto-scrape-websites-with-ruby-and-watir
require 'watir'

b = Watir::Browser.new
b.goto('https://pc.woozooo.com/mydisk.php')
b.text_field(id: 'username').set 'll'
b.text_field(type: 'password').set 'pp'
b.button(id: 's3').click
puts b.window.title
puts b.text_field(id: 'username').value

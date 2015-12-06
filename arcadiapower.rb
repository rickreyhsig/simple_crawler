require 'rubygems'
require 'watir'
require 'watir-webdriver'

# Config file
cnf = YAML::load_file(File.join('./', 'config.yml'))

browser = Watir::Browser.new
browser.goto 'https://www.dom.com/residential/dominion-virginia-power'

browser.text_field(:name => 'user').set cnf['user']
browser.text_field(:name => 'password').set cnf['password']

browser.button(:name => 'main_0$signin_0$signinButton').click #Signs user in

browser.goto(browser.link(:text => 'View Past Usage').href)

browser.select_list(:name => 'SelectedStatementType').select 'Usage'

browser.button(:id => 'btnSearchSubmit').click

username = browser.span(:id => 'account-summary-info-accountname').inner_html
username = username.gsub! '<br>' , ''
username.strip!

meter_read_end_date = browser.table[1][0].text
meter_read_start_date = browser.table[2][0].text

kWh = browser.table[1][4].text

browser.select_list(:name => 'SelectedStatementType').select 'Billing and Payment'

browser.button(:id => 'btnSearchSubmit').click

bill_amount = browser.tr(:text, /#{meter_read_end_date}/).td(:index => 1).text
bill_due_date = browser.tr(:text, /#{meter_read_end_date}/).td(:index => 2).text

puts "Latest bill information for " + username +
"\nUsage: " + kWh + "kWh" +
"\nBill amount: " + bill_amount +
"\nService start date: " + meter_read_start_date +
"\nService end date: " + meter_read_end_date +
"\nBill due date: " + bill_due_date

=begin
Sample output:
--------------
Latest bill information for KYLE WILSON
Usage: 887kWh
Bill amount: $107.24
Service start date: 10/13/2015
Service end date: 11/12/2015
Bill due date: 12/08/2015
=end


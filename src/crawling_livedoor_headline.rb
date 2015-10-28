require './src/object/anemone_crawl.rb'
require 'optparse'
require 'bundler'
Bundler.require

params = ARGV.getopts('d:')
if params["d"] == nil
  puts "Error: Please set -d date option."
  exit(1)
end
if params["d"] != nil && params["d"].size != 8 
  puts "Error: -d is date. e.g. 20150214"
  exit(1)
end

my_crawl = AnemoneCrawl.new

# クローリング先のURL
my_crawl.urls.push("http://news.livedoor.com/straight_news/")

# クローリングする記事の日付
# 指定しなければ現在の日付
my_crawl.date = params["d"]

# 取得するURLのXpathを設定
y = params["d"][0..3]
m = params["d"][4..5]
d = params["d"][6..7]
my_crawl.url_xpath = "//ul[@class='straightList']//time[contains(@datetime,'"+y+"-"+m+"-"+d+"')]/.."

# セーブするファイルの名前
my_crawl.filename = "livedoor_headline"

# スクレイピング
my_crawl.scrape


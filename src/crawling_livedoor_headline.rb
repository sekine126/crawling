require './src/object/anemone_crawl.rb'
require 'bundler'
Bundler.require

my_crawl = AnemoneCrawl.new

# クローリング先のURL
my_crawl.urls.push("http://news.livedoor.com/straight_news/")

# クローリングする記事の日付
# 指定しなければ現在の日付
my_crawl.date = "20151026"

# 取得するURLのXpathを設定
my_crawl.url_xpath = "//ul[@class='straightList']//time[contains(@datetime,'2015-10-26')]/.."

# セーブするファイルの名前
my_crawl.filename = "livedoor_headline"

# スクレイピング
my_crawl.scrape


require './src/object/anemone_crawl.rb'
require 'bundler'
Bundler.require

my_crawl = AnemoneCrawl.new

# クローリング先のURL
my_crawl.urls.push("http://news.infoseek.co.jp/g/?p=1")

# クローリングする記事の日付
# 指定しなければ現在の日付
my_crawl.date = "20151026"

# クローリングする階層を設定
my_crawl.depth_limit = 100

# フォーカスクローリングのパターンを設定
my_crawl.focus_pattern = 'g\/\?p=\d+'

# 取得するURLのXpathを設定
my_crawl.url_xpath = "//ul[@class='topics-list']//p[contains(./text(),'2015年10月26日')]/../a"

# セーブするファイルの名前
my_crawl.filename = "infoseek_headline"

# クローリング
my_crawl.crawl


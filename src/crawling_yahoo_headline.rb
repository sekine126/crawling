require './src/object/anemone_crawl.rb'
require 'bundler'
Bundler.require

my_crawl = AnemoneCrawl.new

# クローリング先のURL
my_crawl.urls.push("http://news.yahoo.co.jp/flash")

# クローリングする記事の日付
# 指定しなければ現在の日付
my_crawl.date = "20151026"

# クローリングする階層を設定
my_crawl.depth_limit = 40

# フォーカスクローリングのパターンを設定
my_crawl.focus_pattern = 'flash\?p=\d+'

# 取得するURLのXpathを設定
my_crawl.url_xpath = '//ul[@class="listBd"]//a[contains(@href,'+my_crawl.date+')]'

# セーブするファイルの名前
my_crawl.filename = "yahoo_headline"

# クローリング
my_crawl.crawl


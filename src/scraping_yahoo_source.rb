require './src/object/anemone_crawl.rb'
require 'bundler'
Bundler.require

my_crawl = AnemoneCrawl.new

# スクレイピング先のURL
my_crawl.set_urls("./data/yahoo_headline_20151026.txt")

# スクレイピングする記事の日付
# 指定しなければ現在の日付
my_crawl.date = "20151026"

# 取得するURLのXpathを設定
my_crawl.url_xpath = '//div[@class="ynDetailRelArticle"]//a'

# セーブするファイルの名前
my_crawl.filename = "yahoo_source"

# スクレイピング
my_crawl.scrape


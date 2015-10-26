require './src/object/anemone_crawl.rb'
require 'bundler'
Bundler.require

my_crawl = AnemoneCrawl.new

# クローリング先のURL
my_crawl.set_urls("./data/yahoonews_headline_20151026.txt")

# クローリングする記事の日付
# 指定しなければ現在の日付
my_crawl.date = "20151026"

# スクレイピングする間隔を設定
my_crawl.delay = 3

# 取得するURLのXpathを設定
my_crawl.url_xpath = '//div[@class="ynDetailRelArticle"]//a'

# セーブするファイルの名前
my_crawl.filename = "yahoonews_source"

# スクレイピング
my_crawl.scrape


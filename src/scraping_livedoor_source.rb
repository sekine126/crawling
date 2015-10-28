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

# スクレイピング先のURL
# livedoor_headline_20xxxxxx.txtの内容は修正する必要がある
# ・topics => article
# ・?以降を削除
my_crawl.set_urls("./data/livedoor_headline_"+params["d"]+".txt")

# スクレイピングする記事の日付
# 指定しなければ現在の日付
my_crawl.date = params["d"]

# 取得するURLのXpathを設定
my_crawl.url_xpath = '//ul[@class="relatedArticleList"]//a'

# セーブするファイルの名前
my_crawl.filename = "livedoor_source"

# スクレイピング
my_crawl.scrape_w


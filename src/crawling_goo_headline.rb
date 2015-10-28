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
my_crawl.urls.push("http://news.goo.ne.jp/topstories/backnumber/all/"+params["d"]+"/")

# クローリングする記事の日付
# 指定しなければ現在の日付
my_crawl.date = params["d"]

# クローリングする階層を設定
my_crawl.depth_limit = 5

# フォーカスクローリングのパターンを設定
my_crawl.focus_pattern = '\?page=\d+'

# 取得するURLのXpathを設定
my_crawl.url_xpath = '//ul[@class="gn-news-list responsive-margin-bottom"]//a'

# セーブするファイルの名前
my_crawl.filename = "goo_headline"

# クローリング
my_crawl.crawl


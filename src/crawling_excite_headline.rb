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
my_crawl.urls.push("http://www.excite.co.jp/News/society_g/"+params["d"]+"/")
my_crawl.urls.push("http://www.excite.co.jp/News/entertainment_g/"+params["d"]+"/")
my_crawl.urls.push("http://www.excite.co.jp/News/sports_g/"+params["d"]+"/")
my_crawl.urls.push("http://www.excite.co.jp/News/column_g/"+params["d"]+"/")
my_crawl.urls.push("http://www.excite.co.jp/News/economy_g/"+params["d"]+"/")
my_crawl.urls.push("http://www.excite.co.jp/News/it_g/"+params["d"]+"/")
my_crawl.urls.push("http://www.excite.co.jp/News/world_g/"+params["d"]+"/")

# スクレイピングする記事の日付
# 指定しなければ現在の日付
my_crawl.date = params["d"]

# 取得するURLのXpathを設定
my_crawl.url_xpath = '//div[@class="newsList"]//a[contains(@href,"'+params["d"]+'")]'

# セーブするファイルの名前
my_crawl.filename = "excite_headline"

# スクレイピング
my_crawl.scrape


require 'open-uri'
require 'fileutils'
require 'bundler'
Bundler.require

# クローリング先のURL
url = 'http://news.yahoo.co.jp/flash'

# Anemoneのconfig
opts = {
  :user_agent => "TsukubaCrawler",
  :delay => 3,
  :storage => Anemone::Storage.MongoDB,
  :depth_limit => 40,
}

date = "20151026"
filename = "./data/yahoonews_headline_" + date + ".txt"

File.open(filename,"w") do |file|
  Anemone.crawl(url, opts) do |anemone|

    # 条件に一致するリンクだけを残す
    anemone.focus_crawl do |page|
      page.links.keep_if { |link|
        link.to_s.match(/flash/)
      } 
    end

    PATTERN = %r[flash\?p=\d+]
    anemone.on_pages_like(PATTERN) do |page|

      # スクレイピング
      charset = nil
      html = open(page.url) do |f|
        charset = f.charset
        f.read 
      end
      doc = Nokogiri::HTML.parse(html, nil, charset)
      doc.xpath('//p[@class="ttl"]/a[contains(@href,'+date+')]').each do |node|
        file.puts(node.attribute('href').value)
        puts node.attribute('href').value
      end
    end
  end
end

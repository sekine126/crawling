require 'open-uri'
require 'fileutils'
require 'bundler'
Bundler.require

class AnemoneCrawl

  attr_accessor :url
  attr_accessor :date
  attr_accessor :user_agent
  attr_accessor :delay
  attr_accessor :depth_limit
  attr_accessor :focus_pattern
  attr_accessor :url_xpath
  attr_accessor :filename

  def initialize()
    @url = nil
    @date = Date.today.strftime("%Y%m%d")
    @user_agent = "TsukubaCrawler"
    @delay = 3
    @depth_limit = 0
    @focus_pattern = ""
    @url_xpath = ""
    @filename = "default"
    @opts = nil
    @urls = nil
  end

  def crawl
    set_options
    @urls = []
    Anemone.crawl(@url, @opts) do |anemone|
      # 条件に一致するリンクだけを残す
      anemone.focus_crawl do |page|
        page.links.keep_if { |link|
          link.to_s.match(/#{@focus_pattern}/)
        } 
      end

      anemone.on_pages_like(/#{@focus_pattern}/) do |page|
        print "crawling url = "
        p page.url
        # スクレイピング
        charset = nil
        html = open(page.url) do |f|
          charset = f.charset
          f.read 
        end
        doc = Nokogiri::HTML.parse(html, nil, charset)
        doc.xpath(@url_xpath).each do |node|
          @urls.push(node.attribute('href').value)
          print "save url = "
          p node.attribute('href').value
        end
      end
    end
    file_save
  end

  private

  def set_options
    @opts = {
      :user_agent => @user_agent,
      :delay => @delay,
      :storage => Anemone::Storage.MongoDB,
      :depth_limit => @depth_limit,
    }
  end

  def file_save
    filename = "./data/" + @filename + "_" + date + ".txt"
    File.open(filename,"w") do |file|
      @urls.each do |u|
        file.puts(u)
      end
    end
  end

end

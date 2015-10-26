require 'open-uri'
require 'fileutils'
require 'bundler'
Bundler.require

class AnemoneCrawl

  attr_accessor :urls
  attr_accessor :date
  attr_accessor :user_agent
  attr_accessor :delay
  attr_accessor :depth_limit
  attr_accessor :focus_pattern
  attr_accessor :url_xpath
  attr_accessor :filename

  def initialize()
    @urls = []
    @date = Date.today.strftime("%Y%m%d")
    @user_agent = "TsukubaCrawler"
    @delay = 3
    @depth_limit = 0
    @focus_pattern = ""
    @url_xpath = ""
    @filename = "default"
    @opts = nil
    @get_urls = nil
  end

  def set_urls(filename)
    File.foreach(filename) do |url|
      @urls.push(url)
    end
  end

  def crawl
    set_options
    @get_urls = []
    @urls.each do |url|
      Anemone.crawl(url, @opts) do |anemone|
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
            @get_urls.push(node.attribute('href').value)
            print "save url = "
            p node.attribute('href').value
          end
        end
      end
    end
    save_file
  end

  def scrape
    set_options
    @get_urls = []
    @urls.each do |url|
      print "scraping url = "
      p url
      @get_urls.push("##")
      @get_urls.push(url)
      # スクレイピング
      charset = nil
      html = open(url) do |f|
        charset = f.charset
        f.read 
      end
      doc = Nokogiri::HTML.parse(html, nil, charset)
      doc.xpath(@url_xpath).each do |node|
        @get_urls.push(node.attribute('href').value)
        print "save url = "
        p node.attribute('href').value
      end
      sleep(@delay)
    end
    save_file
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

  def save_file
    filename = "./data/" + @filename + "_" + date + ".txt"
    File.open(filename,"w") do |file|
      @get_urls.each do |u|
        file.puts(u)
      end
    end
  end
end

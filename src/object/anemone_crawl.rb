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
    @delay = 10
    @depth_limit = 1
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
      puts "==> " + url
      count = 0
      Anemone.crawl(url, @opts) do |anemone|
        # 条件に一致するリンクだけを残す
        anemone.focus_crawl do |page|
          page.links.keep_if { |link|
            link.to_s.match(/#{@focus_pattern}/)
          } 
        end

        anemone.on_pages_like(/#{@focus_pattern}/) do |page|
          count += 1
          print "crawling...#{count} pages\r"
          do_scrape(page.url)
          STDOUT.flush
        end
      end
    end
    save_file
  end

  def scrape
    set_options
    @get_urls = []
    count = 0
    @urls.each do |url|
      count += 1
      puts "==> " + url
      print "scraping...#{get_percent(count,@urls.size)}%\r"
      @get_urls.push("##")
      @get_urls.push(url)
      do_scrape(url)
      sleep(@delay)
      STDOUT.flush
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

  def do_scrape(url)
    charset = nil
    encoded_url = URI.encode(url.to_s)
    begin
      html = open(encoded_url) do |f|
        charset = f.charset
        f.read 
      end
    rescue OpenURI::HTTPError => e
      return
    end
    doc = Nokogiri::HTML.parse(html, nil, charset)
    count = 0
    doc.xpath(@url_xpath).each do |node|
      count += 1
      @get_urls.push(node.attribute('href').value)
    end
    puts "==> get urls : " + count.to_s
  end

  def get_percent(x,y)
    (x.to_f/y*100).round
  end

end

require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper
@@all = []

  def self.scrape_index_page(index_url)
    learn = Nokogiri::HTML(open(index_url))
    learn.css("div.student-card a").each do |card|
      name = card.css("h4").text
      location = card.css("p").text
      profile_url = card.attr("href")
      student_hash = {name: name, location: location, profile_url: profile_url}
      @@all << student_hash
    end
      @@all
  end

  def self.scrape_profile_page(profile_url)
    learn = Nokogiri::HTML(open(profile_url))
    student = {}

    learn.css("social-icon-container a").each do |link|
    href = link.attr("href")
      if href.include?("twitter")
        student[:twitter] = href
      elsif href.include?("linkedin")
        student[:linkedin] = href
      elsif href.include?("github")
        student[:github] = href
      else
        student[:blog] = href
      end
    end
      student[:profile_quote] = learn.css(".vitals-text-container .profile-quote").text
      student[:bio] = learn.css(".details-container .description-holder p").text
      student
  end
end

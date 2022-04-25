require "open-uri"
require "nokogiri"

class ScrapeAllrecipesService
  def initialize(keyword)
    @keyword = keyword
  end
 
  def call
  # À FAIRE : retourner une liste de `Recipe` construites en scrapant le Web.
    names = scrap_recipe_names(@keyword)
    summaries = scrap_recipe_summaries(@keyword)
    #stars = scrap_recipe_stars(@keyword)
    #prep_times = []
    #scrap_recipe_urls(@keyword).each { |url| prep_times << scrap_recipe_prep(url) }
    recipes =[] 
    (0...5).to_a.each do |index|
      recipes << Recipe.new(names[index], summaries[index]) 
    end
    return recipes
  end

  private

  def scrap_recipe_names(word)
    base = "https://www.allrecipes.com/search/results/?search="
    url = base + word

    html_file = URI.open(url, { 'User-Agent' => 'ruby' }).read
    html_doc = Nokogiri::HTML(html_file)
    recipes_names = []

    html_doc.search(".card__title").each do |element|
      recipes_names << element.text.strip
    end
    return recipes_names[...5]
  end

  def scrap_recipe_summaries(word)
    base = "https://www.allrecipes.com/search/results/?search="
    url = base + word

    html_file = URI.open(url, { 'User-Agent' => 'ruby' }).read
    html_doc = Nokogiri::HTML(html_file)
    recipes_summaries = []

    html_doc.search(".card__summary").each do |element|
      recipes_summaries << element.text.strip
    end
    return recipes_summaries[...5]
  end

  def scrap_recipe_stars(word)
    base = "https://www.allrecipes.com/search/results/?search="
    url = base + word

    html_file = URI.open(url, { 'User-Agent' => 'ruby' }).read
    html_doc = Nokogiri::HTML(html_file)
    recipes_stars = []

    html_doc.search(".review-star-text").each do |element|
      rate = element.text.strip[9] == "." ? element.text.strip[8..10] : element.text.strip[8]
      recipes_stars << rate
    end
    return recipes_stars[...5]
  end

  def scrap_recipe_urls(word)
    base = "https://www.allrecipes.com/search/results/?search="
    url = base + word

    html_file = URI.open(url, { 'User-Agent' => 'ruby' }).read
    html_doc = Nokogiri::HTML(html_file)
    recipes_urls = []

    html_doc.search(".card__titleLink").each do |element|
      recipes_urls << element['href']
    end
    return recipes_urls[...5]
  end

  def scrap_recipe_prep(url)
    html_file = URI.open(url, { 'User-Agent' => 'ruby' }).read
    html_doc = Nokogiri::HTML(html_file)
    html_doc.search(".recipe-meta-item").search('div').each do |element|
      if element.search('div').text[0..4] == 'total'
        return element.search('div').text[6..].strip
      end
    end
  end
 end

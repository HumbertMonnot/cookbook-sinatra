require "csv"
require "nokogiri"
require_relative "recipe"

class Cookbook
  attr_reader :recipes
  
  def initialize(csv_file)
    @recipes = [] # <--- <Recipe> instances
    @csv_file = csv_file
    load_csv
  end

  def add(recipe)
    @recipes << recipe
    save_to_csv
  end

  def remove_at(index)
    @recipes.delete_at(index)
    save_to_csv
  end

  def all
    return @recipes
  end

  def mark_as_done(recipe)
    recipe.mark_as_done!
  end

  private

  def load_csv
    CSV.foreach(@csv_file) do |row|
      @recipes << Recipe.new(row[0], row[1]) #, row[2], row[3], row[4])
    end
  end

  def save_to_csv
    CSV.open(@csv_file, 'wb') do |csv|
      @recipes.each do |recipe|
        csv << [ recipe.name, recipe.description ] #, recipe.rating, recipe.done, recipe.prep_time ]
      end
    end
  end
end

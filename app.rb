require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require_relative "cookbook"
require_relative "recipe"
require_relative "scrap_all_recipe_service"
require "open-uri"
require "nokogiri"
# 192.168.1.154 
#set :bind, "0.0.0.0"

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

cookbook = Cookbook.new("recipes.csv")

get "/" do
  @recipes = cookbook.recipes
  erb :index
end

get "/new" do
  @items = [params[:name], params[:description]]
  if @items == [nil, nil]
    erb :new
  else
    recipe = Recipe.new(params[:name], params[:description])
    cookbook.add(recipe)
    redirect to('/')    
  end
end

get "/destroy" do
  @items = params[:index].to_i
  cookbook.remove_at(@items)
  redirect to('/')
end

get "/import" do
  @items = params[:name]
  if @items == nil
    erb :import
  else
    @recipes = ScrapeAllrecipesService.new(@items).call
    erb :import_kw   
  end
end

get "/import_kw" do
  recipe = Recipe.new(params[:name], params[:description])
  cookbook.add(recipe)
  redirect to('/')
end
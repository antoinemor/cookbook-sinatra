require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require_relative "cookbook"
require_relative "marmiton"
require_relative "recipe"


configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

csv_file = File.join(__dir__, 'recipes.csv')
cookbook = Cookbook.new(csv_file)

get '/' do
  erb :index
end

get '/list' do
  @recipes = cookbook.all
  erb :list
end

get '/create' do
  erb :create
end

post '/add' do
  @recipe = params
  @new_recipe = Recipe.new(@recipe[:name], @recipe[:description], @recipe[:cooking_time].to_i, @recipe[:difficulty], @recipe[:done] == "true" ? true : false)
  cookbook.add_recipe(@new_recipe)
  erb :added
end

get '/destroy' do
  erb :find_index_remove
end

post '/destroy_done' do
  cookbook.remove_recipe(params[:index].to_i - 1)
  erb :updated
end

get '/import' do
  erb :import
end

post '/import_run' do
  @mmt = Marmiton.new
  @result = @mmt.search(params[:ingredient], params[:difficulty].to_i)
  erb :import_choose
end

get '/import_done' do
  @mmt_2 = Marmiton.new
  @recipe = @mmt_2.add_info(params[:url])
  @new_recipe = Recipe.new(params[:name].gsub("+", " "), "#{@recipe[:name]} description", @recipe[:cooking_time].to_i, @recipe[:difficulty], false)
  cookbook.add_recipe(@new_recipe)
  erb :added
end

get '/mark_as_done' do
  erb :find_index_done
end

post '/mark_as_done_done' do
  cookbook.mark_as_done_recipe(params[:index].to_i - 1)
  erb :updated
end

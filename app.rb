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

get '/destroy' do
  erb :destroy
end

get '/import' do
  erb :import
end

get '/mark_as_done' do
  erb :mark_as_done
end

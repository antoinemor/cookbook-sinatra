require 'csv'

class Cookbook
  def initialize(csv_file)
    @csv_file = csv_file
    @recipes = []
    read_csv
  end

  def all
    @recipes
  end

  def add_recipe(recipe)
    @recipes << recipe
    write_csv
  end

  def remove_recipe(recipe)
    @recipes.delete_at(recipe)
    write_csv
  end

  def mark_as_done_recipe(recipe)
    @recipes[recipe].done = true
    write_csv
  end

  private

  def read_csv
    CSV.foreach(@csv_file) { |row| @recipes << Recipe.new(row.first, row[1], row[2], row[3], convert_to_boolean(row.last)) }
  end

  def write_csv
    CSV.open(@csv_file, 'wb') do |csv|
      @recipes.each { |recipe| csv << [recipe.name, recipe.description, recipe.cooking_time, recipe.difficulty, recipe.done] }
    end
  end

  def convert_to_boolean(str)
    str == "true" ? true : false
  end
end

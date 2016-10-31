class Recipe
  attr_accessor :name, :description, :cooking_time, :difficulty, :done
  def initialize(name, description, cooking_time, difficulty, done)
    @name = name
    @description = description
    @cooking_time = cooking_time
    @difficulty = difficulty
    @done = done
  end
end

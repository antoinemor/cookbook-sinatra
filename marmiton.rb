require 'open-uri'
require 'nokogiri'

class Marmiton
  def search(ingredient, difficulty_nb)
    # Translate difficulty user input into url info
    difficulty_nb == 0 ? difficulty = "" : difficulty = "&dif=#{difficulty_nb}"
    # Compile URL
    url = "http://www.marmiton.org/recettes/recherche.aspx?aqt=#{ingredient}#{difficulty}"
    # Parse with Nokogiri
    doc = Nokogiri::HTML(open(url), nil, 'utf-8')
    # Construct recipe array
    array_recipe = []
    doc.search('.m_titre_resultat > a').each { |item| array_recipe << item.text }
    end_url = doc.css('.m_titre_resultat a').map { |link| link['href'] }
    array_url = end_url.map { |el| "http://www.marmiton.org" + el }
    return [array_recipe, array_url]
  end

  def add_info(url)
    # Fetch information from recipe webpage
    ingr_doc = Nokogiri::HTML(open(url), nil, 'utf-8')
    recipe_add_info = {

      difficulty: ingr_doc.search('.m_content_recette_breadcrumb').text.match(/-\r\n.+([A-Z].+)\r/)[1],
      cooking_time: ingr_doc.search('.cooktime').text.to_i
    }
  end
end

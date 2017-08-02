#coding: UTF-8
module Kinopoisk
  class Search
    attr_accessor :query, :url

    def initialize(query)
      @query = query
      @url   = SEARCH_URL + URI.escape(query.to_s)
    end

    # Returns an array containing Kinopoisk::Movie instances
    def movies
      find_nodes_film_and_year.map{|n| new_movie n }.compact
    end

    # Returns an array containing Kinopoisk::Person instances
    def people
      find_nodes('name').map{|n| new_person n }
    end

    private

    def doc
      @doc ||= Kinopoisk.parse url
    end

    def find_nodes(type)
      doc.search ".info .name a[href*='/#{type}/']"
    end

    def find_nodes_film_and_year
      doc.search ".info .name"
    end

    def parse_id(node, type)
      node.attr('href').value.match(/\/#{type}\/(\d*)\//)[1].to_i
    end

    def new_movie(node)
      title_node = node.search("a[href*='/film/']")
      if title_node.present?
        id = parse_id(title_node, 'film')
        title = title_node.text.gsub(' (сериал)', '')
        year = node.search("span.year").text

        Movie.new id, title, year
      end
    end

    def new_person(node)
      Person.new parse_id(node, 'name'), node.text
    end
  end
end

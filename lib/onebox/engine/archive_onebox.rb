module Onebox
  module Engine
    class AudioOnebox
      include Engine

      REGEXP = /^(https?:)?\/\/archive\.org\/details\/(.+)$/
      matches_regexp REGEXP

      MEDIATYPES = %w(
        article
        audio
        collection
        data
        education
        etree
        image
        movies
        software
        texts
        web
      )

      def data
        response = Onebox::Helpers.fetch_response(url)
        html_doc = Nokogiri::HTML(response.body)

        html.css('meta')
      end

      def to_html

 

      end
    end
  end
end

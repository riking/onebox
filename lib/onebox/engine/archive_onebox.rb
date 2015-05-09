module Onebox
  module Engine
    class ArchiveOnebox
      include Engine

      REGEXP ||= /^(?:https?:)?\/\/archive\.org\/details\/(.+)$/
      matches_regexp REGEXP

      MEDIATYPES ||= %w(
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

      def item_name
        REGEXP.match(url)[1]
      end

      def make_url(content_type)
        "https://archive.org/#{content_type}/#{item_name}"
      end

      def metadata
        @metadata ||= begin
          url = make_url :metadata
          response = Onebox::Helpers.fetch_response(url)
          ::MultiJson.load(response.body) if response && response.body
        end
      end

      # lol turns out this isn't useful in a lot of cases!
      # going to need ANOTHER mediatype switch I think
      def unique_file_names
        metadata["files"].reject { |file|
          file["source"] == "metadata" || file["format"] == "Metadata"
        }.map { |file|
          File.basename file["name"]
        }.sort.uniq
      end

      def can_embed?
        case metadata["metadata"]["mediatype"]
        when "software"
          metadata["metadata"]["collection"].include? "stream_only"
        when "audio"
          true
        when "web"
          false
        else
          false
        end
      end

      def render_embed
        "<iframe src='#{make_url :embed}' width='640' height='480' frameborder=0 allowfullscreen>"
      end

      def to_html
        puts unique_file_names
        if can_embed?
          render_embed
        else

          "<div>Hi</div>"
        end
      end
    end
  end
end

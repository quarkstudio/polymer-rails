
module Polymer
  module Rails
    class Component

      ENCODING = 'UTF-8'
      XML_NODES = ['*[selected]', '*[checked]', '*[src]:not(script)']
      XML_OPTIONS = { save_with: Nokogiri::XML::Node::SaveOptions::NO_EMPTY_TAGS }

      def initialize(data)
        @doc = org.jsoup.Jsoup.parse_body_fragment(data)
        @doc.output_settings.charset(ENCODING)
      end

      def stringify
        to_html
      end

      def replace_node(node, name, content)
        node.replace_with create_node(name, content)
      end

      def stylesheets
        @doc.select("link[rel=stylesheet]").reject{|tag| is_external? tag.attr('href')}
      end

      def javascripts
        @doc.select("script[src]").reject{|tag| is_external? tag.attr('src')}
      end

      def imports
        @doc.select("link[rel=import]")
      end

    private

      def create_node(name, content)
        node = @doc.create_element(name)
        datanode = org.jsoup.nodes.DataNode.new(content, @doc.base_uri)
        node.append_child datanode
        node
      end

      def to_html
        @doc.select('body').html
      end

      def xml_nodes
        @doc.css(XML_NODES.join(','))
      end

      def is_external?(source)
        !URI(source).host.nil?
      end
    end
  end
end

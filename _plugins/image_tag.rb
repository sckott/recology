# Author: Thomas Mango
# Site: http://thomasmango.com
# License: MIT
module Jekyll
  class LinkedImageTag < Liquid::Tag
    def initialize(tag_name, path, token)
      super
      @path = path
    end

    def render(context)
      <<-EOF
      <p class="image">
        <a href="#{@path}">
          <img src="#{@path}"/>
        </a>
      </p>
      EOF
    end
  end

  class ImageTag < Liquid::Tag
    def initialize(tag_name, path, token)
      super
      @path = path
    end

    def render(context)
      <<-EOF
      <p class="image">
        <img src="#{@path}"/>
      </p>
      EOF
    end
  end
end

Liquid::Template.register_tag('linked_image', Jekyll::LinkedImageTag)
Liquid::Template.register_tag('image', Jekyll::ImageTag)
module Jekyll
  class LocalizeTag < Liquid::Tag

    def initialize(tag_name, key, tokens)
      super
      @init = false
      @key = key.strip
    end

    def render(context)
      defaultsPath = "translations/defaults.yaml"
      @lang = context.registers[:site].config['lang']
      @translations = YAML::load(File.open("translations/#{@lang}.yaml"))
      if File.exist? defaultsPath
        @defaults = YAML::load(File.open(defaultsPath))
      end
      @init = true
      
      result = @translations[@key]

      if result.nil? and defined? @defaults
        result = @defaults[@key]
      end

      if result.nil? and @key.include?("page.title")
        key = context.registers[:page]["title"]
        result = @translations[key]
      end

      "#{result}"
    end
  end

  class RtlTag < Liquid::Tag
    def render(context)
      @lang = context.registers[:site].config['lang']
      @translations = YAML::load(File.open("translations/#{@lang}.yaml"))
      rtl = @translations['rtl']
      if rtl == true
        "rtl"
      else
        "ltr"
      end
    end
  end
end

Liquid::Template.register_tag('localize', Jekyll::LocalizeTag)
Liquid::Template.register_tag('rtl', Jekyll::RtlTag)
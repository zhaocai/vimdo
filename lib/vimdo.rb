require "vimrunner"

require 'vimdo/version'
require 'vimdo/ui'
require 'yaml'

module VimDo

  class VimDoError < RuntimeError
    def self.status_code(code)
      define_method(:status_code) { code }
    end
  end

  class PathError                  < VimDoError; status_code(14) ; end
  class UndefinedCommandError      < VimDoError; status_code(15) ; end

  class << self
    attr_writer :ui, :rc

    def ui
      @ui ||= UI.new
    end

    def rc
      @rc ||= File.expand_path("~/.vimdorc")
    end

    def connect(options= {})
      server = Vimrunner::Server.new(
        # symbolize keys
        options.inject({}){ |h, (n,v)| h[n.to_sym] = v; h }
      )
      server.running? ? server.connect : server.start
    end

    def load_recipes
      if File.exists?(rc)
        settings = YAML::load( File.read(rc) )
        settings.fetch(:recipes, []).map {|f| File.expand_path(f) }.each { |rp|
          Dir[ File.join(rp, '*.vimdo') ].each { |r|
            load r
          }
        }
      end
    end

  end
end

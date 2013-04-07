require 'open3'
require "vimrunner"

require 'vimdo/version'
require 'vimdo/ui'


module VimDo

  class VimDoError < RuntimeError
    def self.status_code(code)
      define_method(:status_code) { code }
    end
  end

  class PathError           < VimDoError; status_code(14) ; end

  class << self
    attr_writer :ui

    def ui
      @ui ||= UI.new
    end

    def connect(name, options= {})
      Vimrunner::Server.new(:name => name).connect
    end

  end

end


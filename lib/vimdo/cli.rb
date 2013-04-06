require 'thor'
require "vimremote/ui"

module VimRemote

  class CLI < Thor
    include Thor::Actions

    class_option "no-color",
      :type   => :boolean,
      :banner => "Disable colorization in output"
    class_option "verbose",
      :type    => :boolean,
      :banner  => "Enable verbose output mode",
      :aliases => "-v"

    def initialize(*)
      super
      VimRemote.ui = UI::Shell.new(options)
      VimRemote.ui.level = "debug" if options["verbose"]
    end


    desc "diff", "diff in vim"
    def diff(*files)
      if files.length < 2
        puts "diff requires at least two files!"
        return
      end
      files.each do |f|
        unless File.readable?(f)
          puts "File: #{f} is not readable!"
          return
        end
      end

      # @opts[:files] = @opts[:argv].map! { |v|
      #   Shellwords.escape(File.absolute_path(v))
      # }
      # self.do_command('tabnew<Bar>edit ' + @opts[:files][0] +
      #                 '<Bar>diffsplit '  + @opts[:files][1])
    end

    desc "merge", "merge in vim"
    long_desc <<-LONGDESC
    LOCAL(= mine), MERGED(= yours), REMOTE(= merged output), [BASE(= common parent)]
    LONGDESC
    def merge(*files)
      VimRemote.ui.confirm "merge"
    end


  private
  end
end


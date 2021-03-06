require 'thor'
require "vimdo/ui"

module VimDo

  class CLI < Thor
    include Thor::Actions
    package_name "VimDo"

    class_option :name,
    :type    => :string,
    :banner  => "servername to connect",
    :default => 'VIM',
    :aliases => ["--servername","-s" ]
    class_option :executable,
    :type    => :string,
    :banner  => "specifiy vim executable",
    :aliases => "-e"
    class_option :foreground,
    :type    => :boolean,
    :banner  => "Foreground: Don't fork when starting GUI",
    :default => false,
    :aliases => "-f"
    class_option :vimrc,
    :type    => :string,
    :default => File.expand_path("~/.vimrc"),
    :banner  => "path to vimrc",
    :aliases => "-u"
    class_option :vimdorc,
    :type    => :string,
    :default => File.expand_path("~/.vimdorc"),
    :banner  => "path to vimdo rc",
    :aliases => "-c"
    class_option "no-color",
    :type   => :boolean,
    :banner => "disable colorization in output"
    class_option :verbose,
    :type    => :boolean,
    :banner  => "enable verbose output mode",
    :aliases => "-v"

    def initialize(*)
      super
      VimDo.ui = UI::Shell.new(options)
      VimDo.ui.level = "debug" if options["verbose"]

    end

    desc "commands", "execute commands in vim"
    def commands(*cmd)
      vim.normal(":<C-u>#{cmd.join(' <Bar> ')}<CR>")
    end

    desc "normal",  "switch vim to normal mode and type the given keys"
    def normal(keys = "")
      vim.normal(keys)
    end


    desc "edit",  "edit file +filename[:line]+ with Vim"
    def edit(filename)
      linenr = nil
      if /(.*):(\d+):?/.match(filename)
        filename = $1
        linenr = $2
      end 
      vim.edit(File.expand_path(filename))
      commands(linenr) if linenr
      vim.foreground
    end

    desc "diff", "diff in vim"
    def diff(from, to)
      [from, to].each do |f|
        raise PathError "#{f} is not readable!" unless File.readable?(f)
      end
      from, to = [from, to].map {|f| File.expand_path(f) }

      commands("tabedit #{path(from)}", "diffsplit #{path(to)}")
      vim.foreground
    end

    desc "diffpatch", "diffpatch in vim"
    method_option :patch, 
      :aliases  => "-p"         ,
      :required => true         ,
      :type     => :string      ,
      :desc     => "patch file"
    def diffpatch(file)
      patch = options[:patch]
      [file, patch].each do |f|
        unless File.readable?(f)
          raise PathError "#{f} is not readable!"
        end
      end
      file, patch = [file, patch].map {|f| File.expand_path(f) }

      commands("edit #{path(file)}", "vertical diffpatch #{path(patch)}")
      vim.foreground
    end



    desc "merge", "LOCAL(= mine), MERGED(= yours), REMOTE(= merged output), [BASE(= common parent)]"
    long_desc <<-LONGDESC
    LOCAL(= mine), MERGED(= yours), REMOTE(= merged output), [BASE(= common parent)]
    LONGDESC
    def merge(local, merge, remote, base = nil)

      [local, merge, remote].each do |f|
        unless File.readable?(f)
          raise PathError "#{f} is not readable!"
        end
      end
      raise PathError "#{base} is not readable!" unless File.readable?(base) or base.nil?

      local, merge, remote = [local, merge, remote].map {|f| File.expand_path(f) }

      merge_command =
      "tabnew<Bar>edit #{path(local)}" +
      "<Bar>diffsplit #{path(merge)}"  +
      "<Bar>diffsplit #{path(remote)}"

      if base
        base_split_command =
        "<Bar>diffsplit #{path(File.expand_path(base))}<Bar>wincmd J"
      else
        base_split_command = ''
      end

      switch_command = "<Bar>2wincmd w"

      commands(merge_command + base_split_command + switch_command)
      vim.foreground
    end

    desc "autocomplete", "print subcommands for shell completion"
    def autocomplete()
      raise UndefinedCommandError, "autocomplete should be intercepted."
    end

    private
    def path(p)
      Vimrunner::Path.new(p)
    end
    def vim
      @vim ||= VimDo.connect(options)
    end
  end
end


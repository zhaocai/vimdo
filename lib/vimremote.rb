require 'open3'
require 'shellwords'
require 'os'

class VimRemote

  attr_accessor :opts
  attr_reader   :errs


  def initialize(options)
    @opts = {
      :servername => '' ,
    }

    if OS.mac?
      @vim = 'mvim'
    else
      @vim = 'gvim'
    end

    @opts.merge!(options)

    @errs = {
      :no_server => "E247: no registered server named"
    }
  end


  def serverlist
    execute([executable, "--serverlist"]).split("\n")
  end


  def do_diff()
    if @opts[:argv].length < 2
      puts "diff requires two files!"
      exit(1)
    end
    @opts[:argv].each do |f|
      unless File.readable?(f)
        puts "File: #{f} is not readable!"
        exit(1)
      end
    end

    @opts[:files] = @opts[:argv].map! { |v|
      Shellwords.escape(File.absolute_path(v))
    }
    self.do_command('tabnew<Bar>edit ' + @opts[:files][0] +
                    '<Bar>diffsplit '  + @opts[:files][1])
  end

  def do_merge()
    if @opts[:argv].length < 3
      puts "merge requires 3 or 4 files:\n\t"\
        '$LOCAL(= mine) $MERGED(= yours) '\
        '$REMOTE(= merged output) [$BASE(= common parent)]'

      exit(1)
    end

    @opts[:argv].each do |f|
      unless File.readable?(f)
        puts "File: #{f} is not readable!"
        exit(1)
      end
    end

    @opts[:files] = @opts[:argv].map! { |v|
      Shellwords.escape(File.absolute_path(v))
    }

    merge_command =
      'tabnew<Bar>edit ' + @opts[:files][0] +
      '<Bar>diffsplit '  + @opts[:files][1] +
      '<Bar>diffsplit '  + @opts[:files][2]

    if @opts[:files].length >= 4
      base_split_command =
        "<Bar>diffsplit #{@opts[:files][3]}<Bar>wincmd J"
    else
      base_split_command = ''
    end

    switch_command = "<Bar>2wincmd w"

    self.do_command(merge_command + base_split_command + switch_command)

  end

  def do_command(command=@opts[:argv].join("\t"))
    server_opt = ''
    unless @opts[:servername].empty?
      server_opt = "--servername #{@opts[:servername]}"
    end

    c = "#{@opts[:vim]} #{server_opt} --remote-send ':<C-u>#{command}<CR>'"
    stdin, stdout, stderr = Open3.popen3(c)
    if stderr.readlines.join("\n").start_with?(@errs[:no_server])
      p %Q{#{@opts[:vim]} --servername #{@opts[:servername]} && #{c}}
    end
  end

end


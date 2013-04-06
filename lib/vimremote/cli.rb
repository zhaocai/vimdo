require 'thor'

module VimRemote

  class CLI < Thor

    def initialize(*)
      super
      the_shell = (options["no-color"] || (not STDOUT.tty?) ? Thor::Shell::Basic.new : shell)
      VimRemote.ui = UI::Shell.new(the_shell)
      VimRemote.ui.debug! if options["verbose"]
    end

    desc "recent", "print recent tags"
    method_option :format,
      :aliases      => "-f"                  ,
      :lazy_default => nil                   ,
      :type         => :string               ,
      :desc         => "print as yaml/plist"
    def recent
      tags = OpenMetaPrefs.recentTags

      puts_to(options[:format], tags)
    end

    desc "clone", "clone openmeta tags and rating"
    method_option :from,
      :aliases  => "-f",
      :required => true,
      :type     => :string,
      :desc     => "clone openmeta tags and rating from the FILE [required]"
    def clone(*files)
      unless File.exist?(from_file)
        raise Openmeta::PathError, "#{from_file} does not exist!"
      end

      files.each { |file|
        tags = Openmeta.get_tags(from_file)
        rating = Openmeta.get_rating(from_file)

        Openmeta.set_tags(tags, file) unless tags.empty?
        Openmeta.set_rating(rating, file) unless rating == 0.0
      }
    end

    desc "get", "get openmeta tags and rating"
    method_option :format,
      :aliases      => "-f"                  ,
      :lazy_default => nil                   ,
      :type         => :string               ,
      :desc         => "print as yaml/plist"
    def get(*files)
      files.each { |file|
        tags = {
          :tags => Openmeta.get_tags(file),
          :rating => Openmeta.get_rating(file)
        }
        puts_to(options[:format], tags)
      }
    end

    desc "clear", "clear openmeta tags and rating"
    def clear(*files)
      files.each { |file|
        Openmeta.set_tags([], file)
        Openmeta.set_rating(0.0, file)
      }
    end


    desc "set", "set openmeta tags, use ',' to separate multiple tags"
    method_option :tag,
      :aliases      => "-t"       ,
      :lazy_default => ''         ,
      :type         => :string    ,
      :desc         => "set tags, use ',' to separate multiple tags"
    def set(*files)
      files.each { |file|
        tags = options[:tag].split(',')
        Openmeta.set_tags(tags, file)
      }
    end

    desc "add", "add openmeta tags, use ',' to separate multiple tags"
    method_option :tag,
      :aliases      => "-t"       ,
      :lazy_default => ''         ,
      :type         => :string    ,
      :desc         => "add tags, use ',' to separate multiple tags"
    def add(*files)
      add_tags = options[:tag].split(',')
      files.each { |file|
        tags = add_tags
        existing_tags = Openmeta.get_tags(file)
        # union
        tags |= existing_tags if existing_tags

        unless tags.eql? existing_tags
          Openmeta.set_tags(tags, file)
        end
      }
    end

    desc "remove", "remove openmeta tags, use ',' to separate multiple tags"
    method_option :tag,
      :aliases      => "-t"       ,
      :lazy_default => ''         ,
      :type         => :string    ,
      :desc         => "remove tags, use ',' to separate multiple tags"
    def remove(*files)
      tags = options[:tag].split(',')
      files.each { |file|
        # duplicate a frozen array
        existing_tags = Openmeta.get_tags(file).dup
        unless existing_tags.empty?
          existing_tags.delete_if { |t| tags.include?(t) }
          Openmeta.set_tags(existing_tags, file)
        end
      }
    end

    desc "rate", "set openmeta rating"
    method_option :rate,
      :aliases      => "-r"       ,
      :lazy_default => 0.0        ,
      :type         => :numeric   ,
      :desc         => "set rating"
    def rate(*files)
      files.each { |file|
        if options[:rate] > 5.0
          raise RangeError, "rating is between [0.0 - 5.0]"
        end
        Openmeta.set_rating(options[:rate], file)
      }
    end

  private
    def puts_to(format, data)
      unless format
        puts data
      else
        require 'yaml' if format == 'yaml'
        to_format = "to_#{format}"

        begin
          puts data.send(to_format)
        rescue NoMethodError
          raise Openmeta::NoMethodError, "#{to_format} has not implemented!"
        end
      end

    end
  end
end


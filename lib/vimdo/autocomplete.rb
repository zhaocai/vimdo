require "vimdo/cli"
require "autocompletion"

require "awesome_print"

module VimDo

  def self.autocomplete(words)
    subcommands = VimDo::CLI.tasks.keys
    global_options = VimDo::CLI.class_options.values.map { |v| v.switch_name }

    if words.empty?
      puts AutoCompletion.words(subcommands + global_options).complete()
    elsif words.length == 1
      puts AutoCompletion.words(subcommands).complete(words[0])
    else
      options = global_options
      current_task = VimDo::CLI.tasks[words.shift] 
      if current_task && ! current_task.options.empty?
        options << current_task.options.values.map { |v| v.switch_name }
      end
      options = options.flatten.delete_if { |o| words.include? o }
      puts AutoCompletion.words(options.flatten).complete(words[-1])
    end
  end
end


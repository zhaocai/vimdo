# vimdo

* home  :: http://zhaocai.github.com/vimdo
* rdoc  :: http://rubydoc.info/gems/vimdo/
* code  :: https://github.com/zhaocai/vimdo
* bugs  :: https://github.com/zhaocai/vimdo/issues


## DESCRIPTION:

Vimdo is a ruby gem to automate tasks with vim remote servers.
Predefined tasks include diff, merge, etc.  You can define your own recipes
to run tasks with Vim. For example, you can define `DirDiff` recipe:

```ruby
module VimDo
  class CLI < Thor

    desc "dirdiff", "directory diff in vim"
    def dirdiff(from, to)
      [from, to].each do |f|
        unless File.directory?(f)
          raise PathError "#{f} is not directory!"
        end
      end

      from, to = [from, to].map {|f| File.expand_path(f) }
      commands(%Q{exec 'DirDiff ' fnameescape("#{from}") fnameescape("#{to}")})
    end

  end
end

```

Then run `vimdo dirdiff path/to/a path/to/b` from the command line or other tools


## INSTALLATION:

* `[sudo] macgem install vimdo`



## COMMAND LINE INTERFACE:

### VimDo commands:
      vimdo commands        # execute commands in vim
      vimdo diff            # diff in vim
      vimdo edit            # edit file +filename+ with Vim
      vimdo help [COMMAND]  # Describe available commands or one specific command
      vimdo merge           # LOCAL(= mine), MERGED(= yours), REMOTE(= merged output), [BASE(= common parent)]
      vimdo normal          # switch vim to normal mode and type the given keys

### Options:
      -s, [--servername=servername to connect]
						       # Default: VIM
      -e, [--executable=specifiy vim executable]
      -u, [--vimrc=specifiy vimrc]
						       # Default: ~/.vimdorc
	  [--no-color=disable colorization in output]
      -v, [--verbose=enable verbose output mode]

## RECIPES:

The path to search for recipes is defined in `~/.vimdorc` in yaml format.

```yaml
---
:recipes :
  - ~/.vimdo/recipes/

```



## KNOWN ISSUE:


## DEVELOPERS:

After checking out the source, run:

  $ rake newb

This task will install any missing dependencies, run the tests/specs,
and generate the RDoc.

## LICENSE:

Copyright (c) 2013 Zhao Cai <caizhaoff@gmail.com>

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option)
any later version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program. If not, see <http://www.gnu.org/licenses/>.




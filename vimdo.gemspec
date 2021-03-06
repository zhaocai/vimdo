# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "vimdo"
  s.version = "1.2.0.20130421120240"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Zhao Cai"]
  s.cert_chain = ["/Users/zhaocai/.gem/gem-public_cert.pem"]
  s.date = "2013-04-21"
  s.description = "Vimdo is a ruby gem to automate tasks with vim remote servers.\nPredefined tasks include diff, merge, etc.  You can define your own recipes\nto run tasks with Vim. For example, you can define `DirDiff` recipe:\n\n```ruby\nmodule VimDo\n  class CLI < Thor\n\n    desc \"dirdiff\", \"directory diff in vim\"\n    def dirdiff(from, to)\n      [from, to].each do |f|\n        unless File.directory?(f)\n          raise PathError \"\#{f} is not directory!\"\n        end\n      end\n\n      from, to = [from, to].map {|f| File.expand_path(f) }\n      commands(%Q{exec 'DirDiff ' fnameescape(\"\#{from}\") fnameescape(\"\#{to}\")})\n    end\n\n  end\nend\n\n```\n\nThen run `vimdo dirdiff path/to/a path/to/b` from the command line or other tools"
  s.email = ["caizhaoff@gmail.com"]
  s.executables = ["vimdo"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt"]
  s.files = ["Gemfile", "Gemfile.lock", "History.txt", "Manifest.txt", "README.md", "Rakefile", "bin/vimdo", "completion/bash/vimdo", "completion/zsh/_vimdo", "lib/vimdo.rb", "lib/vimdo/autocomplete.rb", "lib/vimdo/cli.rb", "lib/vimdo/friendly_error.rb", "lib/vimdo/ui.rb", "lib/vimdo/version.rb", "vimdo.gemspec"]
  s.homepage = "http://zhaocai.github.com/vimdo"
  s.licenses = ["GPL-3"]
  s.rdoc_options = ["--main", "README.md"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "vimdo"
  s.rubygems_version = "2.0.3"
  s.signing_key = "/Users/zhaocai/.gem/gem-private_key.pem"
  s.summary = "Vimdo is a ruby gem to automate tasks with vim remote servers"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<vimrunner>, [">= 0.3.0"])
      s.add_runtime_dependency(%q<thor>, [">= 0.18.0"])
      s.add_runtime_dependency(%q<autocompletion>, [">= 0.0.3"])
      s.add_development_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_development_dependency(%q<rake>, [">= 10.0.0"])
      s.add_development_dependency(%q<hoe>, [">= 0"])
      s.add_development_dependency(%q<hoe-gemspec>, [">= 0"])
      s.add_development_dependency(%q<hoe-git>, [">= 0"])
      s.add_development_dependency(%q<hoe-version>, [">= 0"])
      s.add_development_dependency(%q<awesome_print>, [">= 0"])
    else
      s.add_dependency(%q<vimrunner>, [">= 0.3.0"])
      s.add_dependency(%q<thor>, [">= 0.18.0"])
      s.add_dependency(%q<autocompletion>, [">= 0.0.3"])
      s.add_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_dependency(%q<rake>, [">= 10.0.0"])
      s.add_dependency(%q<hoe>, [">= 0"])
      s.add_dependency(%q<hoe-gemspec>, [">= 0"])
      s.add_dependency(%q<hoe-git>, [">= 0"])
      s.add_dependency(%q<hoe-version>, [">= 0"])
      s.add_dependency(%q<awesome_print>, [">= 0"])
    end
  else
    s.add_dependency(%q<vimrunner>, [">= 0.3.0"])
    s.add_dependency(%q<thor>, [">= 0.18.0"])
    s.add_dependency(%q<autocompletion>, [">= 0.0.3"])
    s.add_dependency(%q<rdoc>, ["~> 4.0"])
    s.add_dependency(%q<rake>, [">= 10.0.0"])
    s.add_dependency(%q<hoe>, [">= 0"])
    s.add_dependency(%q<hoe-gemspec>, [">= 0"])
    s.add_dependency(%q<hoe-git>, [">= 0"])
    s.add_dependency(%q<hoe-version>, [">= 0"])
    s.add_dependency(%q<awesome_print>, [">= 0"])
  end
end

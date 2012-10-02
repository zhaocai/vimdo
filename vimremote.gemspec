# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "vimremote"
  s.version = "1.0.1.20121002144314"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Zhao Cai"]
  s.date = "2012-10-02"
  s.description = "control vim remote server with useful commands"
  s.email = ["caizhaoff@gmail.com"]
  s.executables = ["vimremote"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  s.files = [".autotest", "History.txt", "Manifest.txt", "README.txt", "Rakefile", "bin/vimremote", "lib/vimremote.rb", "test/test_vimremote.rb", ".gemtest"]
  s.homepage = "https://github.com/zhaocai/vimremote"
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "vimremote"
  s.rubygems_version = "1.8.24"
  s.summary = "control vim remote server with useful commands"
  s.test_files = ["test/test_vimremote.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<minitest>, ["~> 3.3"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.10"])
      s.add_development_dependency(%q<hoe>, ["~> 3.0"])
    else
      s.add_dependency(%q<minitest>, ["~> 3.3"])
      s.add_dependency(%q<rdoc>, ["~> 3.10"])
      s.add_dependency(%q<hoe>, ["~> 3.0"])
    end
  else
    s.add_dependency(%q<minitest>, ["~> 3.3"])
    s.add_dependency(%q<rdoc>, ["~> 3.10"])
    s.add_dependency(%q<hoe>, ["~> 3.0"])
  end
end

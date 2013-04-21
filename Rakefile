# -*- ruby -*-

require 'rubygems'
require 'hoe'

Hoe.plugin :bundler
Hoe.plugin :gemspec
Hoe.plugin :git
Hoe.plugin :test
Hoe.plugin :version

Hoe.spec 'vimdo' do

  developer('Zhao Cai', 'caizhaoff@gmail.com')
  license 'GPL-3'

  extra_deps << ['vimrunner', '>= 0.3.0']
  extra_deps << ['thor', '>= 0.18.0']
  extra_deps << ['autocompletion', '>= 0.0.3']

  extra_dev_deps << ['rake', '>= 10.0.0']
  extra_dev_deps << ['hoe'] << ['hoe-gemspec'] << ['hoe-git'] << ['hoe-version']
  extra_dev_deps << ['awesome_print']
  # extra_dev_deps << ['rspec', '>= 2.13']
  # extra_dev_deps << ['guard'] << ['guard-rspec'] << ['terminal-notifier-guard'] << ['growl']
end

%w{major minor patch}.each { |v|
  desc "Bump #{v.capitalize} Version"
  task "bump:#{v}", [:message] => ["version:bump:#{v}"] do |t, args|
    m = args[:message] ? args[:message] : "[release] bump version to #{ENV["VERSION"]}"
    sh "git commit -am '#{m}'"
  end
}

# vim: syntax=ruby

require 'rubygems'
require 'rake'
require 'spec/rake/spectask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "activetiger"
    gem.summary = %Q{Easy integration with Tiger Payment Solutions}
    gem.description = %Q{ActiveTiger allows you to simply add payment processing to your application using Tiger Payment Solutions}
    gem.email = "development@inventables.com"
    gem.homepage = "http://github.com/drewolson/activetiger"
    gem.authors = ["Drew Olson"]
    gem.add_development_dependency "rspec"
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

task :spec => :check_dependencies

Spec::Rake::SpecTask.new do |t|
  t.warning = true
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "activetiger #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

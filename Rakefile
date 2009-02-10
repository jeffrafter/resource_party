require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "resource_party"
    s.summary = "Simplified resource interaction using HTTParty"
    s.email = "jeff@baobabhealth.org"
    s.homepage = "http://github.com/jeffrafter/resource_party"
    s.description = "Simple wrapper for HTTParty for basic operations with a restful resource"
    s.authors = ["Jeff Rafter"]
    s.add_dependency "jnunemaker-httparty"
    s.files =  FileList["[A-Z]*", "{lib,test}/**/*"] 
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'resource_party'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :default => :test

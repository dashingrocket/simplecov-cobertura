require 'bundler/gem_tasks'
require 'rake/testtask'
require 'ci/reporter/rake/test_unit'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/*_test.rb']
end

desc 'Run tests'
task :default => ['ci:setup:testunit', :test]
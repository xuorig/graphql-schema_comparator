#!/usr/bin/env rake
require "bundler/gem_tasks"

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.test_files = FileList[
    'test/lib/graphql/schema_comparator/*/*_test.rb',
    'test/lib/graphql/schema_comparator/*_test.rb',
    'test/lib/graphql/*_test.rb'
  ]
  t.verbose = true
end

task :default => :test

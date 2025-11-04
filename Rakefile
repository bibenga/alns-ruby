# frozen_string_literal: true

require 'rake/testtask'

Rake::TestTask.new do |t|
  # t.libs << 'lib'
  t.pattern = 'test/**/test_*.rb'
  t.verbose = true
end

desc 'Run tests'
task default: :test

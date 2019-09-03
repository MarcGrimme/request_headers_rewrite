# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rdoc/task'
require 'rubycritic/rake_task'
require 'rubycritic_small_badge'

# Add default task. When you type just rake command this would run.
# Travis CI runs this. Making this run spec
desc 'Default: run specs.'
task default: :spec

# Defining spec task for running spec
desc 'Run specs'
RSpec::Core::RakeTask.new('spec') do |spec|
  # Pattern filr for spec files to run. This is default btw.
  spec.pattern = './spec/**/*_spec.rb'
end

# Run the rdoc task to generate rdocs for this gem
RDoc::Task.new do |rdoc|
  require File.expand_path('lib/request_headers_rewrite/version', __dir__)
  version = RequestHeadersRewrite::VERSION

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "release_headers_rewrite #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

RubyCriticSmallBadge.configure do |config|
  config.minimum_score = ENV.fetch('RUBYCRITICLIMIT', 90.0)
end
RubyCritic::RakeTask.new do |task|
  task.options = %(--custom-format RubyCriticSmallBadge::Report
--minimum-score #{RubyCriticSmallBadge.config.minimum_score}
--format html --format console)
  task.paths = FileList['lib/**/*.rb']
end

desc 'Code coverage detail'
task :coverage do
  ENV['COVERAGE'] = 'true'
  Rake::Task['spec'].execute
end

desc 'Console for checking things'
task :console do
  require 'irb'
  require 'irb/completion'
  ARGV.clear
  IRB.start
end

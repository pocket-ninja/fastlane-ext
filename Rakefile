require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rubocop/rake_task'
require_relative 'lib/fastlane_craft/version'

task default: 'test'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/fastlane_craft/*_test.rb']
end

RuboCop::RakeTask.new(:lint) do |t|
  t.options = %w[--display-cop-names]
end

desc 'deploy if there are no stoppers'
task :deploy_if_needed do
  tags = `git tag`.lines.map(&:strip)
  last_commit_msg = `git log -1 --pretty=%B`
  version = FastlaneCraft::VERSION
  stop_keywords = ['STOP', 'WIP', 'WAIT', version]
  exit(0) if stop_keywords.any? { |k| last_commit_msg.include?(k) }
  exit(0) if tags.include?(version)

  Rake::Task['deploy'].execute
end

desc 'auto-deploy'
task :deploy do
  %w[push_gem add_tag bump_version push_branch].each do |t|
    Rake::Task[t].execute
  end
end

desc 'bump version'
task :bump_version do
  cmd = 'gem bump --version patch --commit'
  raise "Version bumping failed! Command execution error: '#{cmd}'" unless system(cmd)
end

desc 'add tag to the latest commit'
task :add_tag do
  cmd = "git tag #{FastlaneCraft::VERSION}"
  raise "Tag creation failed! Command execution error: '#{cmd}'" unless system(cmd)
end

desc 'push repo to github'
task :push_branch do
  cmd = 'git push origin HEAD:master --tags'
  raise "Pushing failed! Command execution error: '#{cmd}'" unless system(cmd)
end

desc 'push gem to rubygems.org'
task :push_gem do
  cmd = 'gem release'
  raise "Release failed! Command execution error: '#{cmd}'" unless system(cmd)
end

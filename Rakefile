require 'rake/testtask'

task :default => [:test]

desc "Unit tests"
task :test do
  Rake::TestTask.new do |t|
    t.libs << "test"
    t.test_files = FileList['test/test*.rb']
    t.verbose = false
  end
end

namespace :test do
  desc "C0 test coverage"
  task :coverage do
    rm_rf "coverage"
    rcov = "rcov -x rcov\.rb --text-summary -Ilib"
    system("#{rcov} test/test_*.rb")
  end
end

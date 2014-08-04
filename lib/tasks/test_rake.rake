namespace :test do
  Rails::TestTask.new(lib: "test:prepare") do |t|
    t.pattern = 'test/lib/**/*_test.rb'
  end
  Rails::TestTask.new(repositories: "test:prepare") do |t|
    t.pattern = 'test/repositories/*_test.rb'
  end
end

Rake::Task[:test].enhance ['test:lib']
Rake::Task[:test].enhance ['test:repositories']
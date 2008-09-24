PKG_FILES = ["Rakefile", "lib/jacker.rb"]

Gem::Specification.new do |s|
  s.name = 'jacker'
  s.version = "1.1"
  s.summary = 'Very simple job tracker'
  s.description = <<-EOF
Jacker is a very simple job tracker.
EOF
  s.files = PKG_FILES
  s.require_path = 'lib'
  s.bindir = 'bin'
  s.executables = ['jacker']
  s.default_executable = 'jacker'
#  s.add_dependency 'sqlite3'
  
  s.has_rdoc = false
  
  s.author = 'Scott Barron'
  s.email = 'scott@elitists.net'
  s.homepage = 'http://github.com/rubyist/jacker'
end

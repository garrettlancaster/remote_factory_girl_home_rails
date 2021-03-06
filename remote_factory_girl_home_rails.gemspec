$:.push File.expand_path("../lib", __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "remote_factory_girl_home_rails"
  s.version     = "1.0.0"
  s.authors     = ["Travis Douce"]
  s.email       = ["travisdouce@gmail.com"]
  s.homepage    = "https://github.com/tdouce/remote_factory_girl_home_rails"
  s.summary     = ""
  s.description = ""

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", ">= 3.2.18"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'rspec-rails'
end

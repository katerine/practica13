# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ull-etsii-alu4321-quiz/version"

Gem::Specification.new do |s|
  s.name        = "ull-etsii-alu4321-quiz"
  s.version     = Ull::Etsii::Alu4321::Quiz::VERSION
  s.authors     = ["katerine"]
  s.email       = ["katerine_cardona@hotmail.com"]
  s.homepage    = ""
  s.summary     = %q{ hacer cuestionarios}
  s.description = %q{ redatar cuestionarios}

  s.rubyforge_project = "ull-etsii-alu4321-quiz"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "guard"
  gem.add_development_dependency "guard-rspec"
  gem.add_development_dependency "rdoc"
  gem.add_development_dependency "colorize"
end

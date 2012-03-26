# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name = %q{guidestar-ruby}
  s.summary = %q{A ruby wrapper around the Guidestar API}
  s.description = %q{A ruby wrapper around the Guidestar API}
  s.homepage = %q{http://github.com/geminisbs/guidestar-ruby}
  s.version = File.read(File.join(File.dirname(__FILE__), 'VERSION'))
  s.authors = ["Mauricio Gomes"]
  s.email = "mgomes@geminisbs.com"

  s.add_dependency "nokogiri", "~> 1.4.3.1"
  s.add_dependency "rest-client", "~> 1.6.0"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

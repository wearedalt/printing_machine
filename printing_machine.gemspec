# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)

require "printing_machine/version"

Gem::Specification.new do |s|
  s.name        = 'printing_machine'
  s.version     = PrintingMachine::VERSION
  s.authors     = ['Mateusz KONIKOWSKI', 'Yann IRBAH']
  s.email       = ['mkonikowski@siliconsalad.com', 'yirbah@siliconsalad.com']
  s.homepage    = 'http://www.siliconsalad.com'
  s.summary     = "Simple interface for PDF Generation"
  s.description = %q{
                      PrintingMachine is a YAML based declarative interface for generating your PDFs.
                      Validations and transformations included.
                    }

  s.rubyforge_project = "printing_machine"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency('prawn', '1.0.0.rc2')
  s.add_dependency('barby')
end

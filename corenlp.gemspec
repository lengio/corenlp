# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'corenlp/version'

Gem::Specification.new do |spec|
  spec.name          = "corenlp"
  spec.version       = Corenlp::VERSION
  spec.licenses      = ['MIT']
  spec.description   = 'Corenlp is a Ruby gem that uses the Stanford CoreNLP Java tools to parse text.'
  spec.authors       = ["Lengio Corporation"]
  spec.homepage      = "http://leng.io/"
  spec.email         = ["engineering@leng.io"]
  spec.summary       = %q{Corenlp is a Ruby gem that uses the Stanford CoreNLP Java tools to parse text.}
  spec.files         = Dir['lib/**/*'] + Dir['test/**/*'] + ['README.md']
  spec.test_files    = ["test"]
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "nokogiri", "1.6.1"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "minitest"
end

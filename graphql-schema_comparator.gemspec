# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'graphql/schema_comparator/version'

Gem::Specification.new do |spec|
  spec.name          = "graphql-schema_comparator"
  spec.version       = GraphQL::SchemaComparator::VERSION
  spec.authors       = ["Marc-Andre Giroux"]
  spec.email         = ["mgiroux0@gmail.com"]

  spec.summary       = %q{Compare GraphQL schemas and get the changes involved.}
  spec.description   = %q{GraphQL::SchemaComparator compares two GraphQL schemas givent their IDL and returns a list of changes.}
  spec.homepage      = "http://mgiroux.me"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "graphql", "~> 1.6"

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "pry-byebug"
end

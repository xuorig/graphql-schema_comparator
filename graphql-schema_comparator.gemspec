# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'graphql/schema_comparator/version'

Gem::Specification.new do |spec|
  spec.name          = "graphql-schema_comparator"
  spec.version       = GraphQL::SchemaComparator::VERSION
  spec.authors       = ["Marc-Andre Giroux"]
  spec.email         = ["mgiroux0@gmail.com"]
  spec.summary       = %q{Compare GraphQL schemas and get the changes that happened.}
  spec.description   = %q{GraphQL::SchemaComparator compares two GraphQL schemas given their SDL and returns a list of changes.}
  spec.homepage      = "https://github.com/xuorig/graphql-schema_comparator"
  spec.license       = "MIT"
  spec.metadata         = {
    "homepage_uri"    => "https://github.com/xuorig/graphql-schema_comparator",
    "changelog_uri"   => "https://github.com/xuorig/graphql-schema_comparator/blob/master/CHANGELOG.md",
    "source_code_uri" => "https://github.com/xuorig/graphql-schema_comparator",
    "bug_tracker_uri" => "https://github.com/xuorig/graphql-schema_comparator/issues",
  }
  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = "bin"
  spec.executables   = ["graphql-schema", "schema_comparator"]
  spec.require_paths = ["lib"]

  spec.add_dependency "graphql", ">= 1.10", "< 3.0"
  spec.add_dependency "thor", ">= 0.19", "< 2.0"
  spec.add_dependency "bundler", ">= 1.14"

  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.10"
  spec.add_development_dependency "pry-byebug", "~> 3.4"
end

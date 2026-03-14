# frozen_string_literal: true

require_relative 'lib/legion/extensions/qualia/version'

Gem::Specification.new do |spec|
  spec.name          = 'lex-qualia'
  spec.version       = Legion::Extensions::Qualia::VERSION
  spec.authors       = ['Esity']
  spec.email         = ['matthewdiverson@gmail.com']
  spec.summary       = 'Subjective phenomenal experience simulation for LegionIO agents'
  spec.description   = 'Models qualia — the subjective phenomenal qualities of experience ' \
                       'with vividness, valence, texture, and modality for the LegionIO architecture'
  spec.homepage      = 'https://github.com/LegionIO/lex-qualia'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.4'

  spec.metadata = {
    'homepage_uri'          => spec.homepage,
    'source_code_uri'       => spec.homepage,
    'documentation_uri'     => "#{spec.homepage}/blob/origin/README.md",
    'changelog_uri'         => "#{spec.homepage}/blob/origin/CHANGELOG.md",
    'bug_tracker_uri'       => "#{spec.homepage}/issues",
    'rubygems_mfa_required' => 'true'
  }

  spec.files = Dir.chdir(__dir__) { `git ls-files -z`.split("\x0") }
  spec.require_paths = ['lib']
end

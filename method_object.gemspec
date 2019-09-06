Gem::Specification.new do |s|
  s.name        = 'method_object'
  s.version     = '1.0.0'
  s.authors     = %w[Bukowskis]
  s.summary     = 'Combining the method object pattern with DRY initialization'
  s.homepage    = 'https://github.com/bukowskis/method_object'

  s.files = Dir['{lib}/**/*', 'README.md']
  s.test_files = Dir['spec/**/*']
  s.license = 'MIT'

  s.add_dependency 'dry-initializer'

  s.add_development_dependency 'rspec-core'
  s.add_development_dependency 'rspec-expectations'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rubocop-rspec'
end

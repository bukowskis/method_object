Gem::Specification.new do |s|
  s.name        = 'method_object'
  s.version     = '1.0.0'
  s.authors     = %w[Bukowskis]
  s.summary     = 'Module for creating method objects / service classes'
  s.description = 'Module for creating method objects / service classes'

  s.metadata['allowed_push_host'] = 'none'

  s.files = Dir['{lib}/**/*', 'README.md']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'dry-initializer'

  s.add_development_dependency 'rspec-core'
  s.add_development_dependency 'rspec-expectations'
end

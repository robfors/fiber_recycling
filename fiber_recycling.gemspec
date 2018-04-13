Gem::Specification.new do |s|
  s.name        = 'fiber_recycling'
  s.version     = '0.1.1'
  s.date        = '2018-04-11'
  s.summary     = 'Recycles old Fibers for performance'
  s.description = 'Duck type for Fiber that will reuse old native Fibers after they have finished executing their block. Reusing old Fibers will offer a small performance gain.'
  s.authors     = 'Rob Fors'
  s.email       = 'mail@robfors.com'
  s.files       = Dir.glob("{lib,spec}/**/*") + %w(LICENSE README.md)
  s.homepage    = 'https://github.com/robfors/fiber_recycling'
  s.license     = 'MIT'
  s.add_runtime_dependency 'quack_pool', '~> 0.0'
  s.add_runtime_dependency 'thread_root_fiber', '~> 1.0'
end

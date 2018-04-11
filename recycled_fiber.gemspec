Gem::Specification.new do |s|
  s.name        = 'fiber_recycling'
  s.version     = '0.0.0'
  s.date        = '2018-04-10'
  s.summary     = 'Recycles old Fibers for performance'
  s.description = 'Ducktype for Fiber that will reuse old native Fibers after they have finished executing their block. Reusing old Fibers will will offer a small performance gain.'
  s.authors     = 'Rob Fors'
  s.email       = 'mail@robfors.com'
  s.files       = ['lib/fiber_recycling.rb']
  s.homepage    = 'https://github.com/robfors/fiber_recycling'
  s.license     = 'MIT'
end

Gem::Specification.new do |s|
  s.name        = 'recycled_fiber'
  s.version     = '0.0.0'
  s.date        = '2018-04-10'
  s.summary     = 'Recycles old Fibers'
  s.description = 'Ducktype for Fiber that will reuse old native Fibers after they have finished executing their block.'
  s.authors     = 'Rob Fors'
  s.email       = 'mail@robfors.com'
  s.files       = ['lib/recycled_fiber.rb']
  s.homepage    = 'https://github.com/robfors/recycled_fiber'
  s.license     = 'MIT'
end

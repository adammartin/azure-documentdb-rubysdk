version = File.read(File.expand_path('../VERSION', __FILE__)).strip
lib = File.expand_path('../lib', __FILE__)
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |s|
  s.name          = 'azure-documentdb-sdk'
  s.version       = version
  s.required_ruby_version = '>= 2.1.0'
  s.date          = '2015-08-12'
  s.summary       = "A sdk to start interaction with document db"
  s.description   = "Lets interact with azure document db!  This is a beta version of the ruby azure sdk."
  s.authors       = ["Adam Martin"]
  s.email         = 'ebondark.od@gmail.com'
  s.require_paths = 'lib'
  s.files         = Dir.glob("lib/**/*") + %w(LICENSE README.md)
  s.homepage      =
    'https://github.com/adammartin/azure-documentdb-rubysdk'
  s.license       = 'MIT'
end
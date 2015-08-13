version = File.read(File.expand_path('../VERSION', __FILE__)).strip

Gem::Specification.new do |s|
  s.name          = 'azure-documentdb-sdk'
  s.version       = version
  s.date          = '2015-08-12'
  s.summary       = "A sdk to start interaction with document db"
  s.description   = "Lets interact with azure document db!"
  s.authors       = ["Adam Martin"]
  s.email         = 'ebondark.od@gmail.com'
  s.require_paths = ['lib']
  s.files         = ["lib/**/*.rb"]
  s.homepage      =
    'https://github.com/adammartin/azure-documentdb-rubysdk'
  s.license       = 'MIT'
end
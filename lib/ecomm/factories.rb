ecomm_root = File.dirname(File.dirname(File.dirname(__FILE__)))

Dir[File.join(
  ecomm_root, 'spec', 'factories', 'shareable', '**', '*.rb'
)].each { |file| require(file) }

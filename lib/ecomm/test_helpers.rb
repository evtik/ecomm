ecomm_root = File.dirname(File.dirname(File.dirname(__FILE__)))

Dir[File.join(ecomm_root, 'spec', 'helpers', '**', '*.rb')].each do |file|
  require(file)
end

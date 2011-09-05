Dir[File.join(Rails.root, 'lib', 'extensions/*.rb')].each do |file|
  require file
end

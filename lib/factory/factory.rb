module Factory

  def self.save(model, attributes = {})
    record = build(model, attributes)
    record.save
    record
  end

end  

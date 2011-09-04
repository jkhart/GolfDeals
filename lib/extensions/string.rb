class String

  def ownerize
    self + (self.ends_with?("s") ? "'" : "'s")
  end
  
end

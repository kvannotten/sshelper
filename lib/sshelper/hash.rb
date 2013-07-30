class Hash
  def method_missing method
    self[method] || self[method.to_s] || super
  end
end
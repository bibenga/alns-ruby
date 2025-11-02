EPSILON = 1e-9 

def is_close(a, b, epsilon = EPSILON)
  (a - b).abs <= epsilon
end

def weighted_random_index(rnd, weights)
  if weights.empty?
    raise "Invalid weights: Array is empty"
  end
  if weights.size == 1
    return 0
  end

  total_sum = weights.sum
  adjusted_value = rnd.rand * total_sum 
  
  weights.each_with_index do |weight, index|
    adjusted_value -= weight
    
    if adjusted_value <= 0 || is_close(adjusted_value, 0)
      return index
    end
  end

  raise "Arithmetic error: sum=#{total_sum}, adjusted_value=#{adjusted_value}, weights=#{weights.inspect}"
end
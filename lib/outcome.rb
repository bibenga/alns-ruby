module Outcome
  BEST   = 0
	BETTER = 1
	ACCEPT = 2
	REJECT = 3

  def self.to_s(value)
    case value
    when BEST   then "BEST"
    when BETTER then "BETTER"
    when ACCEPT then "ACCEPT"
    when REJECT then "REJECT"
    else 
      raise ArgumentError, "Invalid outcome: #{value}"
    end
  end
end

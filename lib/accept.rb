class Accept
  def accept?(rnd, best, current, candidate)
    raise NotImplementedError
  end
end

class HillClimbing < Accept
  def accept?(rnd, best, current, candidate)
    return candidate.objective <= current.objective
  end
end
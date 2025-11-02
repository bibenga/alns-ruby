require_relative "outcome"
require_relative "statistics"
require_relative "result"

class ALNS
  attr_reader :rnd, :listener, :destroy_operators, :repair_operators

  def initialize(rnd=nil)
    @rnd = rnd ? rnd : Random.new
    @listener = nil
    @destroy_operators = []
    @repair_operators = []
  end

  def listener=(op)
    @listener = op
  end

  def add_destroy_operator(op)
    @destroy_operators << op
  end

  def add_repair_operator(op)
    @repair_operators << op
  end

  def iterate(initial_solution, select, accept, stop)
    if @destroy_operators.length == 0 || @repair_operators.length == 0
  		raise ArgumentError, "Missing destroy or repair operators."
    end

  	curr = initial_solution
	  best = initial_solution

  	stats = Statistics.new(@destroy_operators.length, @repair_operators.length)

		stats.collect_objective(Time.new, initial_solution.objective)

    while !stop.done?(@rng, best, curr)
      d_idx, r_idx = select.select(@rnd, best, curr)

      destroy_op = @destroy_operators[d_idx]
		  repair_op = @repair_operators[r_idx]

      destroyed = destroy_op.call(curr, @rnd)
      cand = repair_op.call(destroyed, @rnd)

      best, curr, outcome = eval_cand(accept, best, curr, cand)

      select.update(cand, d_idx, r_idx, outcome)

  		# stats.IterationCount += 1
			stats.collect_objective(Time.new, curr.objective)
	  	stats.collect_operators(d_idx, r_idx, outcome)
    end

    return Result.new(best, stats)
  end


  def eval_cand(accept, best, curr, cand)
  	outcome = determine_outcome(accept, best, curr, cand)

    @listener&.call(outcome, cand)

    case outcome
    when Outcome::BEST
      return cand, cand, outcome
    when Outcome::REJECT
      return best, curr, outcome, nil
    else
      return best, cand, outcome, nil
    end
  end

  def determine_outcome(accept, best, curr, cand)
    outcome = Outcome::REJECT

    if accept.accept?(@rnd, best, curr, cand)
      outcome = Outcome::ACCEPT

      if cand.objective < curr.objective
        outcome = Outcome::BETTER
      end
    end

    if cand.objective < best.objective 
      outcome = Outcome::BEST
    end

    return outcome
  end
end
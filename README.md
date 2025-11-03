# ALNS in Ruby 

This is a **partial port/adaptation** of the Python library [N-Wouda/ALNS](https://github.com/N-Wouda/ALNS) to the **ruby** programming language.  

The original implementation can be found here: [N-Wouda/ALNS](https://github.com/N-Wouda/ALNS).

## Overview
- Implements core components of the ALNS metaheuristic: **destroy operators**, **repair operators**, **acceptance criteria**, and the **operator selection mechanism**.
- Can be used to solve complex combinatorial optimization problems such as TSP, VRP, and others, similar to the Python version.

## Install:
```shell
gem install alns
```

## Exmaple
```ruby
init_sol = NewMyProblemState.new

select = ALNS::NewRouletteWheel.new([3, 2, 1, 0.5], 0.8, 2, 2)
accept = ALNS::HillClimbing.new
stop = ALNS::MaxIterations.new(100_000)

solver := ALNS::Iterator.new

solver.on_outcome do |outcome, cand|
end

solver.add_destroy_operator do |state, rnd|
  # ...
end
solver.add_destroy_operator do |state, rnd|
  # ...
end

solver.add_repair_operator do |state, rnd|
  # ...
end

solver.add_repair_operator do |state, rnd|
  # ...
end

result = alns.iterate(init_sol, select, accept, stop)
best = res.best_state

# do something with the best solution..
```

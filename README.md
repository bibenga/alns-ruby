# ALNS in Ruby 

This is a **partial port/adaptation** of the Python library [N-Wouda/ALNS](https://github.com/N-Wouda/ALNS) to the **ruby** programming language.  

The original implementation can be found here: [N-Wouda/ALNS](https://github.com/N-Wouda/ALNS).

## Overview
- Implements core components of the ALNS metaheuristic: **destroy operators**, **repair operators**, **acceptance criteria**, and the **operator selection mechanism**.
- Can be used to solve complex combinatorial optimization problems such as TSP, VRP, and others, similar to the Python version.

## Install
```shell
gem install alns
```

## Exmaple
```ruby
solver = ALNS::Solver.new

init_sol = make_initial_solution(solver.rnd)

solver.on_outcome do |outcome, cand|
  # do something; for example, you could log it
end

solver.add_destroy_operator do |state, rnd|
  # clone the state and destroy it
end

solver.add_repair_operator do |state, rnd|
  # fix destroyed state
end

select = ALNS::Select::NewRouletteWheel.new([3, 2, 1, 0.5], 0.8, 2, 2)
accept = ALNS::Accept::HillClimbing.new
stop = ALNS::Stop::MaxIterations.new(100_000)

result = alns.iterate(init_sol, select, accept, stop)
# do something with the result
```

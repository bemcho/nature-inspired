
#
#Ruby code translation of http://www.cleveralgorithms.com/nature-inspired/stochastic/adaptive_random_search.html
#

using StatsBase: sample, Random

globalBest = Dict(:cost => rand(1.0:0.1:5), :vector => [])

function objective_function(vector)
    return sum(vector.^2)
end

function random_vector(searchSpace::AbstractArray)
    return [sample(searchSpace[i], 1)[1] for i in 1:first(size(searchSpace))]
end

function take_step(searchSpace, current, step_size)
    position = []
    for i in 1:length(current)
        minVal = min(searchSpace[i][1], current[i] - step_size)
        maxVal = max(searchSpace[i][2], current[i] + step_size)
        push!(position, rand(minVal:maxVal))
    end
    return position
end

function take_steps(bounds, current, step_size, big_stepsize, costFunc = objective_function, takeStepFunc = take_step)
    step, big_step = Dict(), Dict() 
    step[:vector] = takeStepFunc(bounds, current[:vector], step_size)
    step[:cost] = costFunc(step[:vector])
    big_step[:vector] = takeStepFunc(bounds, current[:vector], big_stepsize)
    big_step[:cost] = costFunc(big_step[:vector])
    return step, big_step
end


function large_step_size(iter, step_size, s_factor, l_factor, iter_mult)
    if iter > 0 && mod(iter, iter_mult) == 0
        return step_size * l_factor
    end
    return step_size * s_factor
end


function search(max_iter, bounds, init_factor, s_factor, l_factor, iter_mult, max_no_impr, randSampleFunc = random_vector, costFunc = objective_function)
    step_size =  s_factor * init_factor
    current, count = Dict(), 0
    current[:vector] = randSampleFunc(bounds)
    current[:cost] = costFunc(current[:vector])
  
    for iter in 1:max_iter
        big_stepsize = large_step_size(iter, step_size, s_factor, l_factor, iter_mult)
        step, big_step = take_steps(bounds, current, step_size, big_stepsize)
        if step[:cost] <= current[:cost] || big_step[:cost] <= current[:cost]
            if big_step[:cost] <= step[:cost]
                step_size, current = big_stepsize, big_step
            else
                current = step
            end
            count = 0
        else
            count += 1
            if count >= max_no_impr
                step_size = (step_size / s_factor)
            end
            count = 0
        end
        println(" > iteration=$(iter + 1), best=$(current[:cost])")
    end
    return current
end

# problem configuration
problem_size = 2
bounds = [collect(-5.0:0.1:5.0) for i in 1:problem_size]
# algorithm configuration
max_iter = 1000
init_factor = 0.05
s_factor = 1.3
l_factor = 3.0
iter_mult = 10
max_no_impr = 30
# execute the algorithm
function test()
    best = search(max_iter, bounds, init_factor, s_factor, l_factor, iter_mult, max_no_impr)
    if best[:cost] < globalBest[:cost]
        global globalBest = best
    end
    println("Done.\n Best Solution: c=$(best[:cost]), v=$(best[:vector])\n GlobalBestScoreForAllRuns: c=$(globalBest[:cost]),v=$(globalBest[:vector]) ")
end
test()
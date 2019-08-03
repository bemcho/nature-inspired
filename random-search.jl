using StatsBase: sample 

globalBest = Dict(:cost => rand(0.1:0.1:1), :vector => [])

function objective_function(vector)
    return sum(vector.^2)
end

function random_vector(searchSpace::AbstractArray)
    return [sample(searchSpace[i],1)[1] for i in 1:first(size(searchSpace))]
end

function search(search_space, max_iter)
    best = nothing
    for iter in 1:max_iter
        candidate = Dict()
        candidate[:vector] = random_vector(search_space)
        candidate[:cost] = objective_function(candidate[:vector])
        if (best === nothing || candidate[:cost] < best[:cost]) 
            best = candidate
            if best[:cost] < globalBest[:cost]
                global globalBest = best
            end
        end
        println(" > iteration=$(iter + 1), best=$(best[:cost])")
    end
    return best
end

# problem configuration
problem_size = 2
search_space = [collect(-5.0*i:0.1/i^2:5.0*i) for i in 1:problem_size]
# algorithm configuration
max_iter = 100
# execute the algorithm
best = search(search_space, max_iter)
println("Done.\n Best Solution: c=$(best[:cost]), v=$(best[:vector])\n GlobalBestScoreForAllRuns: c=$(globalBest[:cost]),v=$(globalBest[:vector]) ")

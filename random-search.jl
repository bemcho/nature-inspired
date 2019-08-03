using StatsBase

function objective_function(vector)
    return sum(vector.^2)
end

function random_vector(searchSpace::AbstractArray)
    return rand(minimum(searchSpace)[1]:0.1:maximum(searchSpace[1]), 2)
end

function search(search_space, max_iter)
    best = nothing
    for iter in 1:max_iter
        candidate = Dict()
        candidate[:vector] = random_vector(search_space)
        candidate[:cost] = objective_function(candidate[:vector])
        if (best === nothing || candidate[:cost] < best[:cost]) best = candidate end
        println(" > iteration=$(iter + 1), best=$(best[:cost])")
    end
    return best
end

# problem configuration
problem_size = 2
search_space = [[x for x in -5.0:0.1:5.0],[x for x in -5.0:0.1:5.0]]
# algorithm configuration
max_iter = 1000
# execute the algorithm
best = search(search_space, max_iter)
println("Done.\n Best Solution: c=$(best[:cost]), v=$(best[:vector])")

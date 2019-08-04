#
#Ruby code translation of http://www.cleveralgorithms.com/nature-inspired/stochastic/iterated_local_search.html
#
using StatsBase: sample

function euc_2d(c1, c2)
    round(sqrt((c1[1] - c2[1])^2 + (c1[2] - c2[2])^2))
end

function travel_cost(permutation, cities)::Int
    distance = 0
    permLen = length(permutation)
    for i in 1:permLen
        c2 = (i == permLen) ? permutation[1] : permutation[i + 1]
        distance += round(euc_2d(cities[permutation[i]], cities[c2]))
    end
    return distance
end

function random_permutation(cities)
    perm = collect(1:length(cities))
    permSize = length(perm)
    for i in 1:permSize
        r = rand(1:(permSize - i == 0 ? 1 : permSize - i)) + (i == permSize ? permSize - 1 : i)
        perm[r], perm[i] = perm[i], perm[r]
    end
    return perm
end

function stochastic_two_opt(permutation)
    perm = permutation[:]
    permSize = length(perm)
    c1, c2 = rand(1:permSize), rand(1:permSize)
    exclude = [c1]
    push!(exclude, ((c1 == 1) ? permSize : c1 - 1))
    push!(exclude, ((c1 == permSize + 1) ? 1 : c1 + 1))
    while c2 in exclude
        c2 = rand(1:permSize)
        c1 = c2
        if c2 < c1
            c2 = c1 
        end
        perm[c1:c2] = reverse(perm[c1:c2])
    end
    return perm
end

function local_search(best, cities, max_no_improv)
    count = 0
    while count <= max_no_improv
        candidate = Dict(:vector => stochastic_two_opt(best[:vector]), :cost => 7542)
        candidate[:cost] = travel_cost(candidate[:vector], cities)
        count = (candidate[:cost] < best[:cost]) ? 0 : count + 1
        if candidate[:cost] < best[:cost]
            best = candidate 
        end
    end
    return best
end

function double_bridge_move(perm)
    permSize = length(perm)
    permSizeQuarter = floor(Int, permSize / 4)
    pos1 =  rand(1:permSizeQuarter)
    pos2 = pos1  + rand(1:permSizeQuarter)
    pos3 = pos2  + rand(1:permSizeQuarter)
    p1 = vcat(perm[1:pos1], perm[pos3:permSize])
    p2 = vcat(perm[pos2:pos3], perm[pos1:pos2])
    return vcat(p1, p2)
end

function perturbation(cities, best)
    candidate = Dict()
    candidate[:vector] = double_bridge_move(best[:vector])
    candidate[:cost] = travel_cost(candidate[:vector], cities)
    return candidate
end

function search(cities, max_iterations, max_no_improv)
    best = Dict()
    best[:vector] = random_permutation(cities)
    best[:cost] = travel_cost(best[:vector], cities)
    best = local_search(best, cities, max_no_improv)
    for iter in 1:max_iterations
        candidate = perturbation(cities, best)
        candidate = local_search(candidate, cities, max_no_improv)
        if candidate[:cost] < best[:cost]
            best = candidate 
        end
        println(" > iteration $iter, best=$(candidate[:cost])")
    end
    return best
end

  # problem configuration
berlin52 = [[565,575],[25,185],[345,750],[945,685],[845,655],
   [880,660],[25,230],[525,1000],[580,1175],[650,1130],[1605,620],
   [1220,580],[1465,200],[1530,5],[845,680],[725,370],[145,665],
   [415,635],[510,875],[560,365],[300,465],[520,585],[480,415],
   [835,625],[975,580],[1215,245],[1320,315],[1250,400],[660,180],
   [410,250],[420,555],[575,665],[1150,1160],[700,580],[685,595],
   [685,610],[770,610],[795,645],[720,635],[760,650],[475,960],
   [95,260],[875,920],[700,500],[555,815],[830,485],[1170,65],
   [830,610],[605,625],[595,360],[1340,725],[1740,245]]
  # algorithm configuration
max_iterations = 100
max_no_improv = 50
  # execute the algorithm
globalBest = Dict(:cost => 50000, :vector => [])
function test()
    best = search(berlin52, max_iterations, max_no_improv)
    if best[:cost] < globalBest[:cost]
        global globalBest = best
    end
    println("Done.\n Best Solution: c=$(best[:cost]), v=$(best[:vector])\n GlobalBestScoreForAllRuns: c=$(globalBest[:cost]),v=$(globalBest[:vector]) ")
end
test()

function onemax(vector)
    return count(i->(i == '1'), vector)
end

function random_bitstring(num_bits)
    return rand("10", num_bits)
end

function random_neighbor(bitstring)
    mutant = bitstring[:]
    pos = rand(1:length(bitstring))
    mutant[pos] = (mutant[pos] == '1') ? '0' : '1'
    return mutant
end

function search(max_iterations, num_bits, randSampleFunc = random_bitstring, randNeighborFunc = random_neighbor, costFunc = onemax)
    candidate = Dict()
    candidate[:vector] = randSampleFunc(num_bits)
    candidate[:cost] = costFunc(candidate[:vector])
    for iter in 1:max_iterations
        neighbor = Dict()
        neighbor[:vector] = randNeighborFunc(candidate[:vector])
        neighbor[:cost] = costFunc(neighbor[:vector])
        if neighbor[:cost] >= candidate[:cost]
            candidate = neighbor
        end
        println(" > iteration $iter, best=$(candidate[:cost])")
        if candidate[:cost] == num_bits
            break
        end
    end
    return candidate
end

  # problem configuration
num_bits = 64
  # algorithm configuration
max_iterations = 500
  # execute the algorithm
globalBest = Dict(:cost => rand(1:num_bits), :vector => [])
function test()
    best = search(max_iterations, num_bits)
    if best[:cost] > globalBest[:cost]
        global globalBest = best
    end
    println("Done.\n Best Solution: c=$(best[:cost]), v=$(best[:vector])\n GlobalBestScoreForAllRuns: c=$(globalBest[:cost]),v=$(globalBest[:vector]) ")
end
test()
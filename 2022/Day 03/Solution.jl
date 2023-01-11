# Here we construct the string "abc...zABC...Z" and then search it for
# the given character. By construction, its index is its priority
priority(c) = findfirst(c, join('a':'z') * join('A':'Z'))

function day3(part2)
    Σ = 0
    open(raw"input.txt") do file
        while !eof(file)
            backpack = readline(file)
            if !part2
                numitems = length(backpack)÷2
                pocket1, pocket2 = first(backpack, numitems), last(backpack, numitems)
                common = only(pocket1 ∩ pocket2)
            else
                elf2, elf3 = readline(file), readline(file)
                common = only(backpack ∩ elf2 ∩ elf3)
            end
            Σ += priority(common)
        end
    end
    return Σ
end
# . after the name of a function is called "broadcasting" and allows functions defined
# for scalar values to act over vectors or other iterables. For example, here `day3` is
# defined as expecting a scalar input: `part2` but we're passing a range (consisting of
# two elements, false and true). This is a very powerful technique in Julia and means that
# although multiple dispatch allows us to define both scalar and vector versions of our
# functions we very rarely need to.
day3.(false:true)
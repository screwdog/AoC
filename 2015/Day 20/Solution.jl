function sumDivisors(n)
    Σ = n + 1
    for i ∈ 2:round(Int, sqrt(n))
        if mod(n, i) == 0
            Σ += i
            i^2 ≠ n && (Σ += n÷i)
        end
    end
    return Σ
end

function presents(n, part2=false)
    part2 || return 10*sumDivisors(n)

    Σ = n
    for i ∈ 2:50
        mod(n, i) == 0 && (Σ += n÷i)
    end
    return 11*Σ
end

function day20(part2)
    MIN_PRESENTS = 29_000_000
    for i ∈ 1:MIN_PRESENTS
        presents(i, part2) ≥ MIN_PRESENTS && return i
    end
    return nothing
end
day20.(false:true)
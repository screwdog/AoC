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

function day20p1()
    MIN_PRESENTS = 29_000_000÷10
    for i ∈ 1:MIN_PRESENTS
        sumDivisors(i) ≥ MIN_PRESENTS && return i
    end
    return nothing
end

function day20p2()
    
end
@time day20p1()
#day20.(false:true)
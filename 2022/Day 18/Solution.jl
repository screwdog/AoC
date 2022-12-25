using Underscores
include("Data.jl")
include("Solids.jl")

isvalid(p, volume) = all(p .∈ axes(volume))
isvalid(i, j, k, volume) = isvalid((i,j,k), volume)

function countVoids(i, j, k, volume)
    Σ = 0
    isvalid(i-1,j,k, volume) && volume[i-1,j,k] && (Σ += 1)
    isvalid(i+1,j,k, volume) && volume[i+1,j,k] && (Σ += 1)
    isvalid(i,j-1,k, volume) && volume[i,j-1,k] && (Σ += 1)
    isvalid(i,j+1,k, volume) && volume[i,j+1,k] && (Σ += 1)
    isvalid(i,j,k-1, volume) && volume[i,j,k-1] && (Σ += 1)
    isvalid(i,j,k+1, volume) && volume[i,j,k+1] && (Σ += 1)
    return 6 - Σ
end

function day18(part2, test=false)
    volume = getVolume(test)
    part2 && solidify!(volume)
    @_ volume                               |>
        Iterators.product(axes(__)...)      |>
        collect                             |>
        filter(volume[_...], __)            |>
        sum(countVoids(_..., volume), __)
end
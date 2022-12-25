function readdata(test=false)
    inputfile = test ? "test.txt" : "input.txt"
    @_ read(inputfile, String)  |>
        eachmatch(r"(\d+)", __) |>
        first.(__)              |>
        parse.(Int, __)         |>
        reshape(__, 3, :)
end

function gridExtents(data)
    xs, ys, zs = extrema(data, dims=(2,))
    return (range(xs...), range(ys...), range(zs...))
end

function makeVolume!(data, volume, origin)
    for p ∈ eachcol(data)
        (x, y, z) = p .- origin
        volume[x,y,z] = true
    end
end

function getVolume(test=false)
    inputdata = readdata(test)
    rs = gridExtents(inputdata)

    volume = fill(false, length.(rs))
    origin = first.(rs) .- 1

    makeVolume!(inputdata, volume, origin)
    return volume
end
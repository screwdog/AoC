"""
Convenience functions to create helpful files: transforms.txt and
moleule.txt which translate the input into the corresponding numerical
representation used internally. To help while debugging.
"""

using Underscores
include(raw"..\Types.jl")
include(raw"..\Input.jl")

transform2text(t::Transform) = "$(from(t)) => $(to(t))"

function maketransformfile(transformtext, transforms)
    maxlength = maximum(length, transformtext)
    text = map(*,
        rpad.(transformtext, maxlength + 2),
        transform2text.(transforms)
    )
    open("transforms.txt", "w") do file
        println.(file, text)
    end
end

function makemoleculefile(moleculetext, molecule)
    elements = splitElements(moleculetext)
    text = map(*,
        rpad.(elements, 2 + 2),
        string.(molecule)
    )
    open("molecule.txt", "w") do file
        println.(file, text)
    end
end

function makefiles()
    lines = readlines("input.txt")
    transformtext, moleculetext = lines[1:end-2], lines[end]
    transforms, molecule = readdata("input.txt")
    maketransformfile(transformtext, transforms)
    makemoleculefile(moleculetext, molecule)
    return nothing
end
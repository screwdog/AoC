changeprefix(molecule, prefixlength, atom) = pushfirst!(molecule[prefixlength+1:end], atom)

selectfirsts(transforms, from, to) = Iterators.filter(c -> first.(c) == [from, to], eachcol(transforms))
selectany(transforms, to) = Iterators.filter(c -> first(c[T_TO]) == to, eachcol(transforms))

function partialtransform(transform, molecule, from, overlap)
    # applies transform to the prefix of molecule up to the point
    # overlap, adding the rest of the transform to from (without it's
    # initial atom)

    # returns (new_molecule, new_from)
    return (molecule[overlap+1:end], append!(transform[T_TO][overlap+1:end], from[2:end]))
end

selectfrom(transforms, from) = Iterators.filter(c -> first(c[T_FROM]) == from, eachcol(transforms))
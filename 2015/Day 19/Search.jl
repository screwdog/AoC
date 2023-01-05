const MAX_TRANSFORMS = 10_000

const PP_OVERLAP = 1
const PP_NUMTRANS = 2
const P_OVERLAP = 1
const P_FROM = 2
const P_NUMTRANS = 3

PartPrefix = Tuple{Int, Int}
Prefix = Tuple{Int, Int, Int}
prefix(p::PartPrefix, from) = Prefix(p[PP_OVERLAP], from, p[PP_NUMTRANS])

function findoverlaps(transform, molecule)
    length(transform[T_TO]) > length(molecule) && return Int[]
    return 1:findlast(map(==, transform[T_TO], molecule))
end

function prefixes(transforms, molecule, from, maxtransforms)
    maxtransforms ≥ 1               || return PartPrefix[]
    length(from) < length(molecule) || return PartPrefix[]

    prefs = PartPrefix[]
    possibles = selectfirsts(transforms, from[1], molecule[1])
    for transform ∈ possibles
        overlaps = findoverlaps(transform, molecule)
        for overlap ∈ overlaps
            newmolecule, newfrom = partialtransform(transform, molecule, from, overlap)
            if newfrom == Int[]
                push!(prefs, (overlap, 1))
            else
                newprefs = prefixes(transforms, newmolecule, newfrom, maxtransforms-1)
                map!(p -> p .+ (overlap, 1), newprefs)
                append!(prefs, newprefs)
            end
        end
    end
    return prefs
end

function prefixes(transforms, molecule)
    prefs = Prefix[]
    possibles = selectany(transforms, molecule[1])
    for transform ∈ possibles
        overlaps = findoverlaps(transform, molecule)
        for overlap ∈ overlaps
            newmolecule, from = partialtransform(transform, molecule, Int[], overlap)
            append!(prefs, prefix(prefixes(transforms, newmolecule, from, MAX_TRANSFORMS), transform[T_FROM]))
        end
    end
    return prefs
end

function mintransforms(transforms, molecule, target, maxtransforms=MAX_TRANSFORMS)
    maxtransforms ≥ 1 || return maxtransforms + 1
    possibles = prefixes(transforms, molecule)
    best = maxtransforms + 1
    for (prefixlength, atom, numtransforms) ∈ possibles
        if prefixlength < length(molecule)
            newMolecule = changeprefix(molecule, prefixlength, atom)
            extratransforms = mintransforms(transforms, newMolecule, target, best)
        else
            extratransforms = atom == target ? 0 : best - numtransforms
        end
        best = min(best, numtransforms + extratransforms)
    end
    return best
end

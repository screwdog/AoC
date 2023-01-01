function categorySet(cat, items)
    itemSets = subsets(length(items[cat]), CAT_RANGE[cat])
    return [items[cat][ss] for ss ∈ itemSets]
end

function allItemSets(items)
    @_ items |>
        categorySet.(C_WEAPON:C_RING, Ref(__)) |>
        Iterators.product(__...) |>
        collect |>
        map(vcat(_...), __)
end
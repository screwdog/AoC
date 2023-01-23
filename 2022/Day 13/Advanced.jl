module Advanced
using Underscores
# A simpler approach that uses Julia's built-in parser to process the input.
function readdata()
    @_ readlines("input.txt")   |>
        filter(!isempty, __)    |>
        # eval ∘ Meta.parse is a convenient (but inefficient) way of converting
        # the input into Julia vectors
        Meta.parse.(__)         |>
        eval.(__)
end

# returns an Int of the number at the start of the given string
function numprefix(str)
    i = findfirst(!isdigit, str)
    i === nothing && (i = length(str) + 1)
    return parse(Int, str[1:i-1])
end

ispacketless(ps) = ispacketless(ps...)
# This is a non-recursive implementation of the packet comparison algorithm
# that works directly on the input strings without any preprocessing. While
# it may be more efficient, the amount of comments needed to explain it
# suggest it is hardly "simpler" and likely such an approach would be harder
# to maintain.
function ispacketless(p1, p2)
    i, j = 1, 1
    while i ≤ length(p1) && j ≤ length(p2)
        if p1[i] ≠ p2[j]
            chars = [p1[i], p2[j]]
            # whitespace excluded, there are four possible types of characters
            # where the two strings can differ: '[', ']', ',', and at a digit.
            # This gives 4x4 = 16 combinations, but since the first three must
            # differ that's 16 - 3 = 13.
            
            # Also, we can't have one string be ',' and the other '[', since a
            # comma can only follow a digit, and a '[' can't directly follow a
            # digit. This leaves 13 - 2 = 11 possibilities to consider.

            # Cases:
            #   | [ ] , 0
            # --+--------
            # [ | x a x d
            # ] | a x a a
            # , | x a x b
            # 0 | d a b c

            # If one is a closing bracket this means that packet is ending.
            # This packet is shorter and therefore less. This is case (a) in
            # the grid.
            ']' ∈ chars && return p1[i] == ']'

            # From here, at least one of the packets is at a digit.

            # If one is a digit and the other is a comma, then since they have
            # agreed to this point, one has just finished a number and the
            # other is continuing the number. The one that has finished (ie has
            # the comma) is a smaller number and is the lesser packet. This is
            # case (b) in the grid.
            ',' ∈ chars && return p1[i] == ','

            # If both are digits, then the smaller number is the lesser packet.
            # This is case (c) in the grid.
            all(isdigit, chars) && return numprefix(p1[i:end]) < numprefix(p2[j:end])

            # If one is a digit and the other is an open bracket, then by the
            # rules of the comparison algorithm we need to treat the digit as
            # if it's a vector. This is case (d) in the grid.

            # We count the number of excess open brackets, and use the sign of
            # `brackets` to indicate which packet has had its number promoted.
            brackets = 0
            while '[' ∈ chars
                if p1[i] == '['
                    i += 1
                    chars[1] = p1[i]
                    brackets += 1
                else
                    j += 1
                    chars[2] = p2[j]
                    brackets -= 1
                end
            end
            # There are two possibilities for what follows the open brackets,
            # either a number or a close bracket. A close bracket means that
            # packet is less than the one with the number, as does having a
            # smaller number.
            ']' ∈ chars && return p1[i] == ']'
            #n1, n2 = numprefix.((p1[i:end], p2[j:end]))
            n1 = numprefix(p1[i:end])
            n2 = numprefix(p2[j:end])
            n1 ≠ n2 && return n1 < n2

            # Since both numbers are the same we skip both of them.
            i += length(string(n1))
            j += length(string(n2))

            # If the number in the packet with excess brackets is not now
            # followed by at least the same number of close brackets, then that
            # packet is greater.
            if brackets > 0
                # p1 has the excess brackets
                while i ≤ length(p1) && p1[i] == ']'
                    i += 1
                    brackets -= 1
                end
            else
                # p2 has the excess brackets
                while j ≤ length(p2) && p2[j] == ']'
                    j += 1
                    brackets += 1
                end
            end

            # If we didn't find enough brackets, then that packet is greater.
            brackets ≠ 0 && return brackets < 0

            # We found enough brackets, so to this point both packets compare
            # as equivalent.
        end
        # We only get here if the packets are equivalent so far, either because
        # they are identical, or they are considered equivalent when comparing
        # numbers to vectors.
        i += 1
        j += 1
    end
    # We should only reach here if the packets are identical. This function
    # returns true only when p1 < p2, so we return false.
    return false
end

findpacket(packet, packets) = findfirst((==)(packet), packets)
function day13()
    packets = @_ readlines("input.txt") |> filter(!isempty, __)
    dividers = ["[[2]]", "[[6]]"]
    return (
        @_ packets                          |>
            Iterators.partition(__, 2)      |>
            ispacketless.(__)               |>
            findall                         |>
            sum
    ,
        @_ packets                          |>
            append!(__, dividers)           |>
            sort!(__, lt=ispacketless)      |>
            findpacket.(dividers, Ref(__))  |>
            prod
    )
end
end;
Advanced.day13()
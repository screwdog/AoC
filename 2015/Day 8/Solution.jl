function day8()
    p1diff, p2diff = 0, 0
    open(pwd()*"\\input.txt") do file
        while !eof(file)
            line = readline(file)
            unescape = replace(line,
                "\"" => "",
                "\\\\" => "A",
                "\\\"" => "B",
                r"\\x[0-9a-f]{2}" => s"C")
            escape = "\"" * replace(line,
                "\"" => "\\\"",
                "\\" => "\\\\"
                ) * "\""
            p1diff += length(line) - length(unescape)
            p2diff += length(escape) - length(line)
        end
    end
    return (p1diff, p2diff)
end

day8()
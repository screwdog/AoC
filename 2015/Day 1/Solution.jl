 read(raw"C:\Users\rayha\Desktop\AoC\2015\Day 1\input.txt") |>
    s -> transcode(String, s) |>
    collect |>
    l -> map(c -> c == '(' ? 1 : -1, l) |>
    cumsum |>
    l -> (l[end], findfirst((==)(-1), l))
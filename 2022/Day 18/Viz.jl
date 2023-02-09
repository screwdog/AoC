using Meshes, MeshViz
import GLMakie as Mke

data = Day18.droplet(Day18.Grid)

colours = replace(data, false => :black, true => :orange)
alpha = replace(data, false => 0.05, true => 0.5)
grid = CartesianGrid(size(data)...)

viz(grid, color = vec(colours), alpha = vec(alpha))

# flutter_chain_reaction

Chain Reaction In Flutter

I will be describing the rules of the two-player (Red and Green) game but this could be generalized to any number of players.

The gameplay takes place in an m×n board. The most commonly used size of the board is 9×6.
For each cell in the board, we define a critical mass. The critical mass is equal to the number of orthogonally adjacent cells. That would be 4 for usual cells, 3 for cells in the edge and 2 for cells in the corner.
All cells are initially empty. The Red and the Green player take turns to place "orbs" of their corresponding colors. The Red player can only place an (red) orb in an empty cell or a cell which already contains one or more red orbs. When two or more orbs are placed in the same cell, they stack up.
When a cell is loaded with a number of orbs equal to its critical mass, the stack immediately explodes. As a result of the explosion, to each of the orthogonally adjacent cells, an orb is added and the initial cell looses as many orbs as its critical mass. The explosions might result in overloading of an adjacent cell and the chain reaction of explosion continues until every cell is stable.
When a red cell explodes and there are green cells around, the green cells are converted to red and the other rules of explosions still follow. The same rule is applicable for other colors.
The winner is the one who eliminates every other player's orbs.
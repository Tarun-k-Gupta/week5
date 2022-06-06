pragma circom 2.0.3;

function getMaze() {
    var maze[25] = [
        0, 0, 0, 1, 1,
        1, 1, 0, 0, 1,
        0, 1, 0, 0, 0,
        0, 0, 1, 1, 0,
        0, 0, 0, 0, 0
    ];
    return maze;
} 

// created sample 5x5 maze for testing, 1's represent maze blocks and 0's represent free space.
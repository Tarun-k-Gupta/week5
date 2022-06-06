pragma circom 2.0.3;

include "getMaze.circom";
include "circomlib/comparators.circom";
include "circomlib/poseidon.circom";

template Maze() {
    
    // Public Inputs are the x and y coordinates and the move input which is as follows:
    /*
    0 - up
    1 - down
    2 - right
    3 - left
    */
    signal input move;
    signal input x;
    signal input y;
    signal input hash;
    signal output pubHash;

    var maze[25] = getMaze();
    var pos = x + 5*(4 - y);        // function to get index in 1 dimensional array from x and y coordinates.

    component c[4];
    component j;
    component m;
    
    if(move == 0){                  // generating constraints to check if a move is valid
        j = LessThan(4);
        j.in[0] <== y;
        j.in[1] <== 4;
        j.out === 1;
        var pos1 = x + 5*(4 - (y + 1));
        maze[pos1] === 0;
    }

    if(move == 1){
        c[1] = GreaterThan(32);
        c[1].in[0] <== y;
        c[1].in[1] <== 0;
        c[1].out === 1;
        var pos2 = x + 5*(4 - (y - 1));
        maze[pos2] === 0;                   // if 0 is present, move is valid as it is not interfering with the maze.
    }

    if(move == 2){
        m = LessThan(32);
        m.in[0] <== x;
        m.in[1] <== 4;
        m.out === 1;
        var pos3 = (x + 1) + 5*(4 - y);
        maze[pos3] === 0;
    }

    if(move == 3){
        c[3] = GreaterThan(32);
        c[3].in[0] <== x;
        c[3].in[1] <== 0;
        c[3].out === 1;
        var pos4 = (x - 1) + 5*(4 - y);
        maze[pos4] === 0;
    }

    component poseidon = Poseidon(3);       // constraint to check whether the public hash matches with the hash generated from coordinates.
    poseidon.inputs[0] <== x;
    poseidon.inputs[1] <== y;
    poseidon.inputs[2] <== move;
    pubHash <== poseidon.out;
    hash === pubHash;

}

component main{public [hash]} = Maze();
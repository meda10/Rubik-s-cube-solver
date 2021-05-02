# FLP - Rubik's cube
##### Author: Petr Medek (xmedek07)

## Build and Run
Program is build using command `make`. The project is compiled using the `swipl` compiler.

```bash
$ ./flp20-log
```

## Description
Program reads rubik's cube configuration from STDIN saves it into internal representation. 
Program uses Depth first search algorithm with maximum depth of `27` to find solution. The minimal number of 
quarter turns to solve any instance of the Rubik's Cube is 26, we need to add 1 as starting 
combination so depth is `26 + 1 = 27`. Resulting steps that lead to solution
are printed to STDOUT.

## Warning
Program can take more time to find solution for difficult configurations.

## Tests
Directory `test` contains test files for `flp20-log`

| Test  | Time |
| ------------- | ------------- |
| 0.in  | 1s  |
| 1.in  | 1s  |
| 2.in  | 1s  |
| 3.in  | 1s  |
| 4.in  | 8s  |
| 5.in  | ∞ |
| 6.in  | ∞ |
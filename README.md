# FLP - Rubik's cube
##### Author: Petr Medek (xmedek07)

## Build and Run
Program is build using command `make`. The project is compiled using the `swipl` compiler.

```bash
$ ./flp20-log
```

## Description
Program reads rubik's cube configuration from STDIN saves it into internal representation. 
Program uses Depth first search algorithm with maximum depth of 8 to find solution (program 
takes long time to find solution for more than 6 steps). Resulting steps that lead to solution
are printed to STDOUT.

## Tests
Directory `test` contains test files for `flp20-log`
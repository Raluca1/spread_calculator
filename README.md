# Spread Calculator

## Description and technical choices
`spread_to_benchmark_calculator.rb` and  `spread_to_curve_calculator.rb` scripts take as input a .csv file containig a list of bonds.

Sample .csv file

    bond,type,term,yield
    C1,corporate,10.3 years,5.30%
    C2,corporate,15.2 years,8.30%
    G1,government,9.4 years,3.70%
    G2,government,12 years,4.80%
    G3,government,16.3 years,5.50%

As the input file is read line by line, the progress is printed to stderr. If an error is encountered, and a `Bond` object can not be created, the line is skipped.

`spread_to_benchmark_calculator.rb` calculates the yield spread (return) between each corporate bond and its government bond benchmark and prints the result to the stdout.

`spread_to_curve_calculator.rb` calculates the yield spread to curve for each corporate bond and prints the result to the stdout.

`BondList` is an Array of `Bond` objects. The bonds can be easily sorted in corporate and government bonds based on the `type` attribute.

`spread_to_benchmark` and `spread_to_curve` methods of `BondList` first separate the list of bonds in corporate and government. For each corporate bond, the government bond list is iterated to produce the desired outcome in form of an array of hashes.

Example of return value for `spread_to_benchmark`

    [
        { :bond=>"C1", :benchmark=>"G1", :spread_to_benchmark=>0.16E1 }, 
        { :bond=>"C2", :benchmark=>"G2", :spread_to_benchmark=>0.15E1 }, 
        { :bond=>"C3", :benchmark=>"G3", :spread_to_benchmark=>0.2E1 }, 
        { :bond=>"C4", :benchmark=>"G3", :spread_to_benchmark=>0.29E1 }, 
        { :bond=>"C5", :benchmark=>"G4", :spread_to_benchmark=>0.9E0 }, 
        { :bond=>"C6", :benchmark=>"G5", :spread_to_benchmark=>0.18E1 }, 
        { :bond=>"C7", :benchmark=>"G6", :spread_to_benchmark=>0.25E1 }
    ]

This result can be converted to a nice csv string by utility method `spread_to_benchmark_to_s` to be printed to stdout or used in tests.

    bond,benchmark,spread_to_benchmark
    C1,G1,1.60%
    C2,G2,1.50%
    C3,G3,2.00%
    C4,G3,2.90%
    C5,G4,0.90%
    C6,G5,1.80%
    C7,G6,2.50%

Example of return value for `spread_to_curve`

    [
        { :bond=>"C1", :spread_to_curve=>0.122E1 }, 
        { :bond=>"C2", :spread_to_curve=>0.298E1 }
    ]

As above, this result can be converted to a csv string by utility method `spread_to_curve_to_s`.

    bond,spread_to_curve
    C1,1.22%
    C2,2.98%

## How to run the scripts

1) First challenge: spread to benchmark

    ruby spread_to_benchmark_calculator.rb in_filename.csv

   Example

    ruby spread_to_benchmark_calculator.rb in1.csv
    ruby spread_to_benchmark_calculator.rb in1.csv > out1.csv

2) Second challenge: spread to curve

    ruby spread_to_curve_calculator.rb in_filename.csv
  
   Example
 
    ruby spread_to_curve_calculator.rb in2.csv
    ruby spread_to_curve_calculator.rb in2.csv > out2.csv

A couple of sample input files can be found in the root directory.

## Library dependencies

Only ruby standard library has been used (notably, bigdecimal, csv, and minitest/autorun for unit tests)

## Code documentation

Documentation is available through standard RDoc and can be generated using the command

    rdoc -x /\.csv$/ -x README.md

For convenience, pre-generated docs are included in `doc` folder (open locally `doc/index.html` after checking out the code).

## How to run tests
    ruby tests.rb

## Given more time, I would

*   Do better and more tests, improve code coverage
*   Do more validations and error handling for the procedures that do the calculations so the preconditions are not necessary anymore
*   In case of a more complex problem:
    + extract utility methods from `BondList`: reading of a csv file, and also the result string convertors
    + extract linear interpolation method from `Bond`
*   Evaluate the appropriate underlying data types (e.g. BigDecimal, float)
*   Profile critical paths for performance optimization using the built in Benchmark module
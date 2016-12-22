require_relative 'bond.rb'
require_relative 'bond_list.rb'

# This Ruby script takes as input a .csv file containig a list of bonds.
# It calculates the yield spread (return) between each corporate bond and 
# its government bond benchmark and prints the result to the stdout.
# 
# As the input file is read line by line, the progress is printed to stderr.  
# If an error is encountered, and a +Bond+ object can not be created, 
# the line is skipped.
#
# Further description of the functionality can be found at 
# https://gist.github.com/apotapov/3118c573df2a4ac7a93f00cf39ea620a
# This is Challenge#1.
# 
# How to use the script:
#    ruby spread_to_benchmark_calculator.rb input_filename.csv
#
# Author:: Raluca Metiu 

class SpreadToBenchmarkCalculator
  begin
    bonds = BondList.new
    bonds.read_from_file(ARGV[0])
    result = bonds.spread_to_benchmark

    puts bonds.spread_to_benchmark_to_s(result)

  rescue => e
    STDERR.puts %q(
      Usage:
        ruby yield_spread_calculator.rb input_filename.csv
    )
    puts e.message
    puts e.backtrace
  end
end

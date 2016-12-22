require 'csv'
require_relative 'bond.rb'

# +BondList+ encapsulates a list of bonds.  
# +read_from_file+ method is used to read bonds from a .csv file and
# populate the list.
# 
# Sample of .csv file:
#    bond,type,term,yield
#    C1,corporate,10.3 years,5.30%
#    C2,corporate,15.2 years,8.30%
#    G1,government,9.4 years,3.70%
#    G2,government,12 years,4.80%
#    G3,government,16.3 years,5.50%
#
# === Challenge #1
#
# +spread_to_benchmark+ calculates the yield spread of each corporate bond to its benchmark. 
# The result is an array of hashes with keys +:bond+, +:benchmark+, +:spread_to_benchmark+.
# This result can be converted into a string by the utility method +spread_to_benchmark_to_s+ 
# to be printed to stdout or used in testing.
#
# Sample usage:
#    bonds = BondList.new
#    bonds.read_from_file("in1.csv")
#    result = bonds.spread_to_benchmark
#    puts bonds.spread_to_benchmark_to_s(result)
#
# === Challenge #2
#
# +spread_to_curve+ calculates the spread to curve for each corporate bond.
# The result is an array of hashes with keys +:bond+, +:spread_to_curve+.
# This result can be converted into a string by the utility method +spread_to_curve_to_s+ 
# to be printed to stdout or used in testing.
#
# Sample usage:
#    bonds = BondList.new
#    bonds.read_from_file("in2.csv")
#    result = bonds.spread_to_curve
#    puts bonds.spread_to_curve_to_s(result)
#
# ===
#
# Further description of the functionality can be found at:
# https://gist.github.com/apotapov/3118c573df2a4ac7a93f00cf39ea620a
#
# Author:: Raluca Metiu 

class BondList < Array

  # Reads a .csv file, and tries to build an +Bond+ instance from each line and append it to this +BondList+. 
  # If an error is encountered trying to build a +Bond+ object, the respective line is skipped.  
  def read_from_file(file_name)
    STDERR.puts "Start reading bond list..."

    CSV.foreach(file_name, headers: true) do |line|
      begin
        id     = line[0]
        type   = line[1]
        term   = line[2].chomp(' years')
        _yield = line[3].chomp('%')
        bond = Bond.new id, type, term, _yield
        self << bond
        STDERR.puts bond.inspect
      rescue Exception => e
        STDERR.puts "Bond initialization failed for line: #{line}. This line is skipped."
        STDERR.puts e.message
      end
    end

    STDERR.puts "End reading bond list\n\n"
  end


  # Calculates the yield spread of each corporate bond to its benchmark. 
  # The result is an array of hashes with keys +:bond+, +:benchmark+, +:spread_to_benchmark+.
  def spread_to_benchmark
    result = []
    corporate_bonds  = bonds_of_type Bond::CORPORATE_TYPE
    government_bonds = bonds_of_type Bond::GOVERNMENT_TYPE

    corporate_bonds.each do |cb|
      gb = cb.bond_with_min_term_difference(government_bonds)
      result_item = {}
      result_item[:bond] = cb.id
      result_item[:benchmark] = gb.id
      result_item[:spread_to_benchmark] = cb.spread_to_benchmark(gb)
      result.push result_item
    end
    result
  end 

  # Utility method to convert the result of +spread_to_benchmark+ to string
  def spread_to_benchmark_to_s(spread_to_benchmark_result)
    result = "bond,benchmark,spread_to_benchmark\n"
    spread_to_benchmark_result.each do |r|
      result += "#{r[:bond]},#{r[:benchmark]},#{sprintf("%.2f", r[:spread_to_benchmark])}%\n"
    end
    result
  end


  # Calculates the spread to curve for each corporate bond.
  # The result is an array of hashes with keys +:bond+, +:spread_to_curve+.
  def spread_to_curve
    result = []
    corporate_bonds  = bonds_of_type(Bond::CORPORATE_TYPE)
    government_bonds = bonds_of_type(Bond::GOVERNMENT_TYPE).sort_by{ |b| b.term }

    corporate_bonds.each do |cb|
      result_item = {}
      result_item[:bond] = cb.id
      result_item[:spread_to_curve] = cb.spread_to_curve(government_bonds)
      result.push result_item
    end
    result
  end

  # Utility method to convert the result of +spread_to_curve+ to string
  def spread_to_curve_to_s(spread_to_curve_result)
    result = "bond,spread_to_curve\n"
    spread_to_curve_result.each do |r|
      result += "#{r[:bond]},#{sprintf("%.2f", r[:spread_to_curve])}%\n"
    end
    result
  end



  private def bonds_of_type(type) 
    select { |b| b.type == type }
  end

end


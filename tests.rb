require_relative "bond_list.rb"
require 'minitest/autorun'
 
# +Tests+ class builds a couple of test bond lists.
# The expected result of calculating spread to benchmark or spread to curve 
# is also declared as a multiline string.
#
# The expected result is compared against the actual result. 
class Tests < Minitest::Test

  def test_spread_to_benchmark
    t_spread_to_benchmark @bonds1, @spread_to_benchmark_result1
    t_spread_to_benchmark @bonds3, @spread_to_benchmark_result3
  end
 
  def test_spread_to_curve
    result      = @bonds2.spread_to_curve
    result_to_s = @bonds2.spread_to_curve_to_s result
    assert_equal @spread_to_curve_result2.strip, result_to_s.strip    
  end


  private def setup_bonds1
    @bonds1 = BondList.new
    @bonds1 << Bond.new( 'C1', 'corporate',  '10.3 years', '5.30%' ) <<
               Bond.new( 'G1', 'government', '9.4 years',  '3.70%' ) <<
               Bond.new( 'G2', 'government', '12 years',   '4.80%' )

    @spread_to_benchmark_result1 = %q(
bond,benchmark,spread_to_benchmark
C1,G1,1.60%
    )
  end

  private def setup_bonds2
    @bonds2 = BondList.new
    @bonds2 << Bond.new( 'C1', 'corporate',  '10.3 years', '5.30%' ) <<
               Bond.new( 'C2', 'corporate',  '15.2 years', '8.30%' ) <<
               Bond.new( 'G1', 'government', '9.4 years',  '3.70%' ) <<
               Bond.new( 'G2', 'government', '12 years',   '4.80%' ) <<
               Bond.new( 'G3', 'government', '16.3 years', '5.50%' )

    @spread_to_curve_result2 = %q(
bond,spread_to_curve
C1,1.22%
C2,2.98%
    )
  end


  private def setup_bonds3
    @bonds3 = BondList.new
    @bonds3 << Bond.new( 'C1', 'corporate',  '1.3 years',  '3.30%'  ) <<
               Bond.new( 'C2', 'corporate',  '2.0 years',  '3.80%'  ) <<
               Bond.new( 'C3', 'corporate',  '5.2 years',  '5.30%'  ) <<
               Bond.new( 'C4', 'corporate',  '9.0 years',  '6.20%'  ) <<
               Bond.new( 'C5', 'corporate',  '10.1 years', '6.40%'  ) <<
               Bond.new( 'C6', 'corporate',  '16.0 years', '9.30%'  ) <<
               Bond.new( 'C7', 'corporate',  '22.9 years', '12.30%' ) <<
               Bond.new( 'G1', 'government', '0.9 years',  '1.70%'  ) <<
               Bond.new( 'G2', 'government', '2.3 years',  '2.30%'  ) <<
               Bond.new( 'G3', 'government', '7.8 years',  '3.30%'  ) <<
               Bond.new( 'G4', 'government', '12 years',   '5.50%'  ) <<
               Bond.new( 'G5', 'government', '15.1 years', '7.50%'  ) <<
               Bond.new( 'G6', 'government', '24.2 years', '9.80%'  ) 

    @spread_to_benchmark_result3 = %q(
bond,benchmark,spread_to_benchmark
C1,G1,1.60%
C2,G2,1.50%
C3,G3,2.00%
C4,G3,2.90%
C5,G4,0.90%
C6,G5,1.80%
C7,G6,2.50%
    )
  end

  def setup
    setup_bonds1
    setup_bonds3

    setup_bonds2
  end

  private def t_spread_to_benchmark(bonds, expected_result)
    result      = bonds.spread_to_benchmark
    result_to_s = bonds.spread_to_benchmark_to_s result
    assert_equal expected_result.strip, result_to_s.strip
  end
  
end
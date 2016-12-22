require 'bigdecimal'

# +Bond+ holds the attributes of a bond.
# See below how to initialize and use a +Bond+ object.
#
# Author:: Raluca Metiu 

class Bond 
  # Utility constant (value 'corporate') designating a corporate bond
  CORPORATE_TYPE  = 'corporate'
  # Utility constant (value 'government') designating a government bond
  GOVERNMENT_TYPE = 'government'

  # Is a string
  attr_reader :id
  # Is 'corporate' or 'government'
  attr_reader :type
  # Is a positive BigDecimal
  attr_reader :term
  # Is a BigDecimal
  attr_reader :yield
  
  # The initialization fails with +ArgumentError+ if either of the following:
  # * +id+ is not a string
  # * +type+ is not 'corporate' or 'government'
  # * +term+ can not be converted to a BigDecimal or is a negative number
  # * +_yield+ can not be converted to a BigDecimal
  def initialize(id, type, term, _yield)
    unless id && id.is_a?(String)
      raise ArgumentError.new("Bond id must be a string (#{id.inspect})")
    end 
    unless [CORPORATE_TYPE, GOVERNMENT_TYPE].include?(type)
      raise ArgumentError.new("Unknown bond type (#{type.inspect})")
    end    
    unless !!BigDecimal(term) && BigDecimal(term) > 0
      raise ArgumentError.new("Bond term must be positive (#{term.inspect})")
    end
    unless !!BigDecimal(_yield)
      raise ArgumentError.new("Bond yield must be a number (#{_yield.inspect}")
    end
    @id    = id
    @type  = type
    @term  = BigDecimal(term)
    @yield = BigDecimal(_yield)
  end


  # Returns the current bond yield spread to its benchmark +bond+.
  def spread_to_benchmark(bond) 
    (@yield - bond.yield).abs
  end

  # Returns the bond from +bonds+ with the term closest to 
  # term attribute of this instance.
  #
  # +bonds+ - array of government bonds.
  def bond_with_min_term_difference(bonds)
    diff, index = bonds.map{ |b| term_difference(b) }.each_with_index.min
    bonds[index]
  end

  # Returns the the current bond spread to curve.  
  #
  # Assumptions: 
  # * <b>+bonds+ are ordered ascending by their terms</b>
  # * <b>There is at least one government bond with the term smaller than all the terms of corporate bonds</b> 
  # * <b>There is at least one government bond with the term bigger than all the terms of corporate bonds</b> 
  #
  # +bonds+ - array of government bonds, ordered ascending by their terms
  def spread_to_curve(bonds)

    # find the closest bond0 and bond1 from param bonds with 
    # bond0.term < self.term < bond1.term
    bond0 = bonds.first
    bond1 = bonds.last

    bonds.drop(1).each do |b|
      if b.term < self.term
        bond0 = b
      else 
        bond1 = b
        break
      end
    end 

    yield_spread_to_curve(bond0, bond1)
  end



  private def term_difference(bond)
    (@term - bond.term).abs
  end

  # Assumption: x0 < x < x1
  private def linear_interpolation(x0, y0, x1, y1, x)
    y0 + (x - x0) * (y1 - y0) / (x1 - x0)
  end

  private def yield_spread_to_curve(bond0, bond1)
    interpolated_yield = linear_interpolation(
                            bond0.term, bond0.yield, 
                            bond1.term, bond1.yield,
                            self.term)
    (self.yield - interpolated_yield).abs
  end

end


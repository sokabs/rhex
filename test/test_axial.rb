require_relative 'test_helper'

class TestAxial < Minitest::Test #:nodoc:

  def setup
    @h = Hex::Axial.new( 15, 15 )
  end

  def test_creation
    assert_equal( Hex::Axial.new( 15, 15 ).class, Hex::Axial )
  end

  def test_equality
    assert_equal( @h, Hex::Axial.new( 15, 15 ) )
  end

  def test_nearest_hex
    near = Hex::Axial.new( 15, 16 )
    far = Hex::Axial.new( 18, 18 )
    assert_equal( near, @h.nearest_hex( [ near, far  ] ) )
  end

  def test_distance
    assert_equal( 1, @h.distance( Hex::Axial.new( 15, 16 ) ) )
    assert_equal( 2, @h.distance( Hex::Axial.new( 15, 17 ) ) )
    assert_equal( 4, @h.distance( Hex::Axial.new( 17, 17 ) ) )
    assert_equal( 2, @h.distance( Hex::Axial.new( 17, 13 ) ) )
    assert_equal( 3, @h.distance( Hex::Axial.new( 18, 12 ) ) )
  end

  def test_hex_surrounding_hex?
    assert( @h.hex_surrounding_hex?( Hex::Axial.new( 15, 16 ) ) )
    refute( @h.hex_surrounding_hex?( Hex::Axial.new( 15, 17 ) ) )
    assert( @h.hex_surrounding_hex?( Hex::Axial.new( 14, 15 ) ) )
    refute( @h.hex_surrounding_hex?( Hex::Axial.new( 14, 14 ) ) )
  end

  def test_get_surrounding_hexs
    assert_includes( @h.get_surrounding_hexs, Hex::Axial.new( 15, 16 ) )
  end

  def test_to_cube
    c = @h.to_cube
    assert_equal( c.class, Hex::Cube )
    assert_equal( 15, c.x )
    assert_equal( 15, c.z )
    assert_equal( -30, c.y )
    d = c.to_axial
    assert_equal( @h, d )
  end

end
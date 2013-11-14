require 'fast_spec_helper'
require 'structural'

describe Structural do
  Point = Structural.new(:x, :y)

  it "creates a simple struct with the given methods" do
    point = Point.new(1, 2)

    expect(point.x).to eq(1)
    expect(point.y).to eq(2)
  end

  it "requires all arguments to be present" do
    expect { Point.new }.to raise_error(ArgumentError, "Expected 2 arguments, got 0")
  end

  it "can be given default values for arguments"
  it "is immutable"
  it "can be copied"
  it "can have more than one attribute changed per copy"
  it "raises an exception if the same argument is given twice"
end

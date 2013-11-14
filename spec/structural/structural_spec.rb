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

  it "can be given default values for arguments" do
    xpoint_class = Point.with_defaults(y: 1)
    point = xpoint_class.new(2)

    expect(point.x).to eq(2)
    expect(point.y).to eq(1)
  end

  it "does not assign default values if nil is explicitly given" do
    xpoint_class = Point.with_defaults(y: 1)
    point = xpoint_class.new(2, nil)

    expect(point.y).to eq(nil)
  end

  it "is immutable" do
    point = Point.new(1, 2)

    expect(point.respond_to?(:x=)).to be_falsey
    expect { point.instance_variable_set(:"@x", 3) }.to raise_error(RuntimeError)
  end

  it "can be copied" do
    point = Point.new(1, 2)
    new_point = point.copy(y: 3)

    expect(new_point.x).to eq(1)
    expect(new_point.y).to eq(3)
  end

  it "can have more than one attribute changed per copy" do
    point = Point.new(1, 2)
    new_point = point.copy(x: 3, y: 4)

    expect(new_point.x).to eq(3)
    expect(new_point.y).to eq(4)
  end

  it "checks equality based on its attributes" do
    p1 = Point.new(1, 2)
    p2 = Point.new(1, 2)
    p3 = Point.new(1, 3)

    expect(p1).to eq(p2)
    expect(p1).not_to eq(p3)
  end

  it "does not recurse infinitely" do
    p1 = Point.new(1, 2)
    recursive = p1.copy(x: p1)

    expect(recursive).to eq(recursive)
    expect(recursive).not_to eq(p1)
  end

  it "defines its hash code in terms of its attributes" do
    p1 = Point.new(1, 2)
    p2 = Point.new(1, 2)
    p3 = Point.new(1, 4)

    expect(p1.hash).to eq(p2.hash)
    expect(p1.hash).not_to eq(p3.hash)
  end
end

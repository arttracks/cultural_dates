require 'test_helper'
include CulturalDates

describe CulturalInterval do

  describe "Basic Functionality" do

    it "has a class parse method" do
      CulturalInterval.must_respond_to "parse"
    end

    it "the class parse method returns a CulturalInterval object" do
      CulturalInterval.parse("1990").must_be_kind_of CulturalInterval
    end
  end

  describe "Basic Parsing" do

    before do
      @val = CulturalInterval.parse("1990")
    end

    it "has standard x_ot_x methods" do
      %w{botb bote eotb eote}.each {|n|  @val.must_respond_to n}
    end

    it "responds to date methods with a CulturalDate" do
      @val.botb.must_be_instance_of CulturalDate
      @val.eotb.must_be_instance_of CulturalDate
    end

    it "responds to a single date method as expected" do
      @val.botb.to_s.must_equal "1990"
      @val.eotb.to_s.must_equal "1990"
      @val.bote.to_s.must_be_nil
      @val.eote.to_s.must_be_nil
    end

    it "has a possible interval" do
      @val.must_respond_to :possible_interval
      @val.possible_interval.must_be_kind_of EDTF::Interval
      @val.possible_interval.edtf.must_equal "1990-01-01/unknown"
    end

    it "has a definite interval" do
      @val.must_respond_to :definite_interval
      @val.definite_interval.must_be_kind_of EDTF::Interval
      @val.definite_interval.edtf.must_equal  "1990-12-31/1990-12-31"
    end

    it "has a begin interval" do
      @val.must_respond_to :beginning_interval
      @val.must_respond_to :begin_interval
      @val.must_respond_to :beginning
      @val.begin_interval.must_be_kind_of EDTF::Interval
      @val.begin_interval.edtf.must_equal  "1990-01-01/1990-12-31"
    end

    it "has a end interval" do
      @val.must_respond_to :ending_interval
      @val.must_respond_to :end_interval
      @val.must_respond_to :ending
      @val.end_interval.must_be_kind_of EDTF::Interval
      @val.end_interval.edtf.must_equal  "1990-12-31/unknown"
    end

  end
end
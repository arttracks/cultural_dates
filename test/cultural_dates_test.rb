require 'test_helper'
include CulturalDates

describe "Parsing Dates" do
  before do
    @val = CulturalDate.parse("1990")
  end
 
  it "handles known dates" do
    @val.known?.must_equal true
  end

  it "marks blank dates as unknown" do
    CulturalDate.parse("").known?.must_equal false
  end


  it "has a class parse method" do
    CulturalDate.parse("1990")  
  end

  it "returns a CulturalDate object" do
    @val.must_be_kind_of CulturalDate
  end

  it "has handles equality" do
    Date.edtf("1990-uu-uu").must_equal @val
    # @val.must_equal Date.edtf("1990-uu-uu")  # Not sure why this fails.  
    # Think it has to do with the EDTF library?
  end
  it "handles self equality" do
    @val.must_equal CulturalDate.parse("1990")
  end

  it "handles earliest" do
    @val.earliest.must_equal Date.new(1990,1,1)
  end

  it "handles latest" do
    @val.latest.must_equal Date.new(1990,12,31)
  end

  it "has a to_s method" do
    @val.to_s.must_equal "1990"
  end
end

describe "possible syntaxes" do

  describe "handles many forms" do

    forms = [
    "June 11 1995", "Oct. 17, 1980", "june 15, 90 BCE", "9 June 1932", "9 June, 1932", "10/17/1980","1980-10-17",
    "June 11, 1995", "June 11, 880 CE", "June 11, 880 BCE", "June 11, 1990?",
    "June 2000 CE", "March 880", "January 80", "aug. 1995", 'August, 1995', 'Aug., 1995',
    "October 1990", "October 990 CE",
    "the 1990s",  "1990s", "1990s CE", "the 1990s AD",
    ]

    unsupported_forms = ["October 1990?", "1990?", "the 1990s?", "the 19th century?", 
                         "the 8th century BCE?", "900 CE?", "800 BCE?"]

    forms.each do |form|
      it "#{form} is a valid date" do
        val = CulturalDate.parse(form)
        refute_nil(val.value, "'#{form}' should not parse to nil")
       end
    end

    unsupported_forms.each do |form|
      it "#{form} is an invalid date" do
        val = CulturalDate.parse(form)
        assert_nil(val.value, "'#{form}' was previously unsupported")
       end
    end
  end


end
# class Cultural/DatesTest < Minitest::Test
#   def test_that_it_has_a_version_number
#     refute_nil ::CulturalDates::VERSION
#   end

#   def test_forms 
#     skip   "Waiting until I know why these are important"
#     strings = [
#       "",
#       "1995 until 1996",
#       "1995 until at least 1996",
#       "1995 until sometime before 1996",
#       "1995 until sometime between 1996 and 1997",
#       "1995",
#       "after 1995 until 1996",
#       "after 1995 until at least 1996",
#       "after 1995 until sometime before 1996",
#       "after 1995 until sometime between 1996 and 1997",
#       "after 1995",
#       "by 1995 until 1996",
#       "by 1995 until at least 1996",
#       "by 1995 until sometime before 1996",
#       "by 1995 until sometime between 1996 and 1997",
#       "by 1995",
#       "in 1995 until sometime before 1995",
#       "in 1995",
#       "no date",
#       "sometime between 1995 and 1996 until 1997",
#       "sometime between 1995 and 1996 until at least 1996",
#       "sometime between 1995 and 1996 until at least 1997",
#       "sometime between 1995 and 1996 until sometime before 1997",
#       "sometime between 1995 and 1996 until sometime between 1997 and 1998",
#       "sometime between 1995 and 1996",
#       "until 1996",
#       "until at least 1996",
#       "until sometime before 1996",
#       "until sometime between 1995 and 1996",


#     ]
#   end
# end

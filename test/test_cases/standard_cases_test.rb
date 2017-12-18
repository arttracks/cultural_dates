require "json"
require_relative "../test_helper.rb"

describe "Timespan Test Cases" do
  Dir.glob("../edtf_test_cases/tests/timespan_tests/**/*.json") do |test_case_file| 

    test_case = JSON.parse(File.read(test_case_file))
    test_case["human"].each do |language, value|

      debug = value == "in 1980 until no later than 1990"
      val = CulturalInterval.parse(value, debug)

      describe "The test case \"#{test_case["description"]}\" in #{language}" do

        it "is parses" do
          val.must_be_instance_of CulturalInterval
        end

        it "has the correct earliest value" do
          if test_case["earliest_possible_day"].nil? 
            val.earliest.must_be_nil
          else
            val.earliest.to_s.must_equal test_case["earliest_possible_day"]
          end
        end
        
        it "has the correct latest value" do 
          if test_case["latest_possible_day"].nil? 
            val.latest.must_be_nil
          else
            val.latest.to_s.must_equal test_case["latest_possible_day"]
          end
        end

        it "has the correct earliest definite value" do
          if test_case["earliest_definite_day"].nil? 
            val.earliest_definite.must_be_nil
          else
            val.earliest_definite.to_s.must_equal test_case["earliest_definite_day"]
          end
        end
        
        it "has the correct latest definite value" do 
          if test_case["latest_definite_day"].nil? 
            val.latest_definite.must_be_nil
          else
            val.latest_definite.to_s.must_equal test_case["latest_definite_day"]
          end
        end

        it "has the correct EDTF value" do
          if test_case["edtf"].nil? 
            val.to_edtf.must_be_nil
          else
            val.to_edtf.must_equal test_case["edtf"]
          end
        end

        it "has the correct definite EDTF value" do
          next unless test_case.keys.include? "edtf_definite"
          if test_case["edtf_definite"].nil? 
            val.to_edtf.must_be_nil
          else
            val.to_definite_edtf.must_equal test_case["edtf_definite"]
          end
        end


        it "roundtrips to a string" do
          if pref_term = test_case.dig("preferred_human",language)
            val.to_s.must_equal pref_term
          elsif test_case["preferred_human"] && test_case["preferred_human"][language].nil?
            val.to_s.must_be_nil
          else
            val.to_s.must_equal value
          end
        end

      end
    end
  end

end

##########################################

describe "Date Test Cases" do

  Dir.glob("../edtf_test_cases/tests/date_tests/**/*.json") do |test_case_file| 

    test_case = JSON.parse(File.read(test_case_file))

    test_case["human"].each do |language, value|
      val = CulturalDate.parse(value)
      describe "The test case \"#{test_case["description"]}\" in #{language}" do
        
        it "is parses" do
          val.must_be_instance_of CulturalDate
        end
        
        it "has the correct earliest value" do
          if test_case["earliest_possible_day"].nil? 
            val.earliest.must_be_nil
          else
            val.earliest.to_s.must_equal test_case["earliest_possible_day"]
          end
        end
        
        it "has the correct latest value" do 
          if test_case["latest_possible_day"].nil? 
            val.latest.must_be_nil
          else
            val.latest.to_s.must_equal test_case["latest_possible_day"]
          end
        end
        
        it "has the correct EDTF value" do
          if test_case["edtf"].nil? 
            val.to_edtf.must_be_nil
          else
            val.to_edtf.must_equal test_case["edtf"]
          end
        end

        it "roundtrips to a string" do
          if pref_term = test_case.dig("preferred_human",language)
            val.to_s.must_equal pref_term
          elsif test_case["preferred_human"] && test_case["preferred_human"][language].nil?
            val.to_s.must_be_nil
          else
            val.to_s.must_equal value
          end
        end
      end
    end
  end
end
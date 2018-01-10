require "./spec_helper"

describe Aha do
  it "sam" do
    matcher = Aha::SAM.compile %w(我 我是 是中)
    STDERR.puts "compile finish"
    matched = [] of Tuple(Int32, Int32)
    matcher.match("我是中国人") do |hit|
      matched << ({hit.end, hit.value})
    end
    matched.should eq([{3, 2}, {2, 1}, {1, 0}])
  end

  # it "sam save load" do
  #   matcher = Aha::SAM.compile %w(我 我是 是中)
  #   matcher.save("aha.bin")
  #   machter = Aha::SAM.load("aha.bin")
  #   matched = [] of Tuple(Int32, Int32)
  #   matcher.match("我是中国人") do |hit|
  #     matched << ({hit.end, hit.value})
  #   end
  #   matched.should eq([{3, 2}, {2, 1}, {1, 0}])
  # end
end

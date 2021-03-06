# aha

useful data structure for string processing.

ahocorasick automaton based on cedar which is a high performance double array trie. 

suffix automaton

bk-tree

symspell, efficient fuzzy matching, better than bk-tree

wumanber, a string matching algorithm

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  aha:
    github: chenkovsky/aha
```

## Usage

```crystal
require "aha"
it "save load" do
    matcher = Aha::AC.compile %w(我 我是 是中)
    matcher.save("aha.bin") # serialize automata into file
    machter = Aha::AC.load("aha.bin") # load automata from file
    matched = [] of Tuple(Int32, Int32)
    matcher.match("我是中国人") do |hit|
      matched << ({hit.end, hit.value})
    end
    matched.should eq([{1, 0}, {2, 1}, {3, 2}])
end

  it "sam" do
    matcher = Aha::SAM.compile %w(我 我是 是中)
    matched = [] of Tuple(Int32, Int32)
    matcher.match("我是中国人") do |hit|
      matched << ({hit.end, hit.value})
    end
    matched.should eq([{1, 0}, {2, 1}, {3, 2}])
  end

  it "sam save load" do
    matcher = Aha::SAM.compile %w(我 我是 是中)
    matcher.save("aha.bin")
    machter = Aha::SAM.load("aha.bin")
    matched = [] of Tuple(Int32, Int32)
    matcher.match("我是中国人") do |hit|
      matched << ({hit.end, hit.value})
    end
    matched.should eq([{1, 0}, {2, 1}, {3, 2}])
  end
  it "bk tree" do
    tree = Aha::BKTree.compile(["ab", "bc", "abc"])
    key_dist_arr = [] of Tuple(String, Int32)
    tree.match("abc", 0) do |key, dist|
      key_dist_arr << ({key, dist})
    end
    key_dist_arr.should eq([{"abc", 0}])
    key_dist_arr.clear
    tree.match("abc", 1) do |key, dist|
      key_dist_arr << ({key, dist})
    end
    key_dist_arr.sort.should eq([{"ab", 1}, {"abc", 0}, {"bc", 1}])
  end

  it "symspell" do
    matcher = Aha::SymSpell.compile %w(ruby rb Ruby)
    matcher.size.should eq(3)
    matcher.match("ruby", 0).map { |x| x.term }.should eq(["ruby"])
    matcher.match("rub", 0).map { |x| x.term }.should eq([] of String)
    matcher.match("rub", 1).map { |x| x.term }.sort.should eq(["rb", "ruby"])
    matcher.match("rub", 2).map { |x| x.term }.sort.should eq(["Ruby", "rb", "ruby"])
    matcher.match("rub", 2, false).map { |x| x.term }.sort.should eq(["rb", "ruby"])
  end

  it "symspell save load" do
    matcher = Aha::SymSpell.compile %w(ruby rb Ruby)
    matcher.save("sym.bin")
    matcher = Aha::SymSpell.load("sym.bin")
    matcher.size.should eq(3)
    matcher.match("ruby", 0).map { |x| x.term }.should eq(["ruby"])
    matcher.match("rub", 0).map { |x| x.term }.should eq([] of String)
    matcher.match("rub", 1).map { |x| x.term }.sort.should eq(["rb", "ruby"])
    matcher.match("rub", 2).map { |x| x.term }.sort.should eq(["Ruby", "rb", "ruby"])
    matcher.match("rub", 2, false).map { |x| x.term }.sort.should eq(["rb", "ruby"])
  end

  it "cedar match" do
    trie = Aha::CedarBig.new
    ids = %w(Ruby ruby rub).map do |s|
      trie.insert s
    end

    ans = [{0, 4, "Ruby"}, {8, 11, "rub"}]
    ms = [] of Tuple(Int32, Int32, String)
    trie.match_longest("Ruby on rub", false) do |m|
      ms << {m.start, m.end, trie[m.value]}
    end
    ms.should eq(ans)
  end

  it "cedar match ignore case" do
    trie = Aha::CedarBig.new
    ids = %w(Ruby ruby rub).map do |s|
      trie.insert s
    end

    ans = [{0, 4, "Ruby"}, {8, 12, "ruby"}]
    ms = [] of Tuple(Int32, Int32, String)
    trie.match_longest("Ruby on ruby", true) do |m|
      ms << {m.start, m.end, trie[m.value]}
    end
    ms.sort.should eq(ans)
  end

  it "cedar gsub" do
    trie = Aha::CedarBig.new
    ids = %w(Ruby ruby rub).map do |s|
      trie.insert s
    end
    str = trie.gsub("Ruby on ruby rub", true) do |m|
      case trie[m.value]
      when "ruby"
        "crystal"
      when "Ruby"
        "Crystal"
      else
        "Unknown"
      end
    end

    str.should eq("Crystal on crystal Unknown")
  end

  it "cedar sep match" do
    trie = Aha::CedarBig.new
    ids = %w(Ruby ruby rub).map do |s|
      trie.insert s
    end

    ans = [{0, 4, "Ruby"}, {20, 24, "ruby"}]
    ms = [] of Tuple(Int32, Int32, String)
    trie.match_longest("Ruby rRuby on rubyx ruby", true, sep: [' ']) do |m|
      ms << {m.start, m.end, trie[m.value]}
    end
    ms.sort.should eq(ans)
  end

  it "cedar sep gsub" do
    trie = Aha::CedarBig.new
    ids = %w(Ruby ruby rub).map do |s|
      trie.insert s
    end
    s = trie.gsub("Ruby rRuby on rubyx ruby", true, sep: [' ']) do |m|
      case trie[m.value]
      when "ruby"
        "crystal"
      when "Ruby"
        "Crystal"
      else
        "Unknown"
      end
    end
    s.should eq("Crystal rRuby on rubyx crystal")
  end
```


## Development

TODO: Write development instructions here

## Contributing

1. Fork it ( https://github.com/chenkovsky/aha/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [chenkovsky](https://github.com/chenkovsky) chenkovsky - creator, maintainer

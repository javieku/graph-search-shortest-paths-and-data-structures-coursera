class SearchIndex

  def initialize data
    @index ={}
    @data = data
    for number in @data
       @index[number] = true
    end
  end

  def look_up t  
    for x in @data do
      y = t - x
      if (@index[y] && x != y) 
        return true
      end
    end  
    return false
  end
end

class BruteForce
  def look_up t  
    for x in @data do
      for y in @data do      
        if ( x + y == t && x != y) 
          return true
        end
      end
    end  
    return false
  end
end

def load_file file_path
  input = []
  File.open(file_path, "r") do |f|
    f.each_line do |line|
      input.push(line.to_i) 
    end
  end
  return input
end

def main
  start = Time.now
  puts "Starting algorithm"
 
  input = load_file("simple-data1.txt")
  puts "File read " +  (Time.now - start).to_s
 
  index = SearchIndex.new(input)
  puts "Index created " +  (Time.now - start).to_s

  counter = 0
  (-10000..10000).each do |t|
    counter += 1 if index.look_up(t)
  end
  puts "Numbers in [-10000, 10000] calculated in " +  (Time.now - start).to_s
  puts counter
end

main
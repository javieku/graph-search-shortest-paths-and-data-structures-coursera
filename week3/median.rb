require_relative 'heap.rb' 

class RunningMedian

  attr_accessor :total_sum

  def initialize
    @total_sum = 0
    @min_heap = MinHeap.new()
    @max_heap = MaxHeap.new()
  end

  def median number    
    if( @max_heap.empty? || number < @max_heap.max )
      @max_heap.push(number)
    else 
      @min_heap.push(number)
    end

    adjust_heaps_size(@max_heap, @min_heap)

    median = @max_heap.size < @min_heap.size ? @min_heap.min : @max_heap.max;

    @total_sum += median 
  end

  private
  def adjust_heaps_size(max_heap, min_heap)
    if ((max_heap.size - min_heap.size).abs >= 2)
      if (max_heap.size < min_heap.size)
        max_heap.push(min_heap.pop())
      else
        min_heap.push(max_heap.pop())
      end
    end
  end
end

def next_number
  File.open("Median.txt", "r") do |f|
    f.each_line do |line|
      number = line.to_i
      yield number
    end
  end
end

def main
  start = Time.now
  algorithm = RunningMedian.new
  puts "Starting algorithm"

  next_number{ |number| algorithm.median(number) }

  puts "Sum of the Median calculated in " +  (Time.now - start).to_s
  puts "Total result: " + algorithm.total_sum.to_s
  puts "Last four digits: " + (algorithm.total_sum%10000).to_s
end

main
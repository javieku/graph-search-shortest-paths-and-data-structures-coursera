require 'singleton'

class Edge
  attr_reader :successor_name
  attr_reader :predecessor_name
  attr_reader :weight
  def initialize(predecessor_name, successor_name, weight)
    @predecessor_name = predecessor_name
    @successor_name = successor_name
    @weight = weight
  end
  def to_s
    "(N: " + @successor_name + " W: " + @weight.to_s + ")"
  end
end

class Node
    attr_reader :name
    attr_reader :successors
  
    def initialize(name)
      @name = name
      @successors = []
    end
  
    def add_edge(successor)
      @successors << successor
    end

    def remove_edge(name)
      @successors -= [name]
    end

    def n_of_edges
      @successors.length
    end

    def sample
      @successors.sample(1).first
    end

    def [](position)
      @successors[position]
    end

    def include?(name)
      @successors.include?(name)
    end

    def select_candidates(explored)
      return @successors.select {|item|
                  !explored.include?(item.successor_name)
             }
    end

    def to_s
      "#{@name} -> [#{@successors.join(' ')}]"
    end
end

class Graph
    attr_reader :nodes
    
    def initialize
      @nodes = {}
    end
  
    def add_node(node)
      @nodes[node.name] = node if !@nodes.include?(node.name)
    end

    def remove_node(node_name)
      @nodes.delete(node_name)
    end

    def add_edge(edge)
      @nodes[edge.predecessor_name].add_edge(edge)
    end
  
    def [](name)
      @nodes[name]
    end

    def empty?
      @nodes.length == 0
    end

    def n_of_nodes
      @nodes.length
    end

    def to_s
      "Graph"
    end
end

class DijktraAlgorithm
  def initialize
    @shortest_path = {}
  end

  def execute graph, initial_node
    graph.nodes.each do |node|
      @shortest_path[node.first] = 0.0
    end
    
    explored = [initial_node]
    while(explored.length != graph.nodes.size)
      # dijkstra greedy criterion
      edge = select_minimun_edge(graph, explored)

      @shortest_path[edge.successor_name] = @shortest_path[edge.predecessor_name] +  edge.weight
      explored.push(edge.successor_name)
    end
  end

  def to_s 
    result = ""
    @shortest_path.each do |item|
      result += "--[#{item[1]}]--> #{item[0]}  # "
    end
    result
  end

  def result_for nodes 
    result = ""
    nodes.each do |node|
      result += "--[#{@shortest_path[node]}]--> #{node}  # "
    end
    result
  end

private
  def select_minimun_edge graph, explored
    candidates = []
    explored.each do |node|
      candidate = graph.nodes[node].select_candidates(explored)
      candidates.push(candidate) if (candidate != nil)    
    end

    candidates.flatten!
    
    return candidates.min_by do |edge|
      @shortest_path[edge.predecessor_name] + edge.weight
    end
  end
end

class GraphLoader
  include Singleton
  def read_graph
    graph = Graph.new
    File.open("dijktraData.txt", "r") do |f|
        f.each_line do |line|
          edges = line.split(/\s/).reject(&:empty?)
          node_name = edges[0]
          edges.shift
          graph.add_node(Node.new(node_name))
          edges.each do |edge|
            graph.add_edge(read_edge(node_name,edge))
          end
        end
      end
    return graph
  end

private  
  def read_edge node_name, edge_s
    edge = edge_s.split(',')
    other_node_name = edge[0]
    weight = edge[1]
    Edge.new(node_name, other_node_name, weight.to_f)
  end
end

def main
  start = Time.now
  graph = GraphLoader.instance.read_graph
  puts "Graph loaded in memory " +  (Time.now - start).to_s
  start = Time.now
  puts "Starting Dijkstra's algorithm"
  dijkstra = DijktraAlgorithm.new
  initial_node = "1"
  dijkstra.execute(graph, initial_node) 
  puts "Dijkstra's took " +  (Time.now - start).to_s
  puts "Dijkstra's result from #{initial_node} to"
  puts dijkstra.result_for(["7","37","59","82","99","115","133","165","188","197"])
end

main
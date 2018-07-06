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

    def rename_nodes(hash)
      new_succesors = []
      @successors.each do |current_name|
        new_succesors.push(hash[current_name])
      end
      return new_succesors 
    end

    def to_s
      "#{@name} -> [#{@successors.join(' ')}]"
    end
end

class Graph

    def initialize
      @nodes = {}
    end
  
    def add_node(node)
      @nodes[node.name] = node if !@nodes.include?(node.name)
    end

    def remove_node(node_name)
      @nodes.delete(node_name)
    end
  
    def add_edge(predecessor_name, successor_name)
      @nodes[predecessor_name].add_edge(successor_name)
    end

    def rename_nodes(hash)
      new_nodes = {}
      hash.each do |old_name, new_name|
        new_succesors = @nodes[old_name].rename_nodes hash
        new_node = Node.new(new_name)
        new_succesors.each do |successor|
          new_node.add_edge(successor)
        end
        new_nodes[new_name] = new_node         
      end
      @nodes = new_nodes
    end

    def reverse_edges
      new_nodes = {}
      @nodes.each do |node_name, node|
        for i in 0...node.n_of_edges
          if (new_nodes.include?(node[i]))
            new_nodes[node[i]].add_edge(node_name)
          else
            aux = Node.new(node[i])
            aux.add_edge(node_name)
            new_nodes[node[i]] = aux;
          end
        end
      end
      @nodes = new_nodes
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

class DFSAlgorithm

  attr_accessor :finishing_time, :strong_components_length

  def initialize
    @finishing_time = {}
    @leaders = {}
    @explored = {}
    @current_time = 0
    @strong_components_length = []
  end

  def execute graph
    @finishing_time = {}
    @leader = {}
    @explored = {}
    @current_time = 0
    @strong_components_length = []
    for i in graph.n_of_nodes.downto(1)
      if !@explored.include?(i.to_s)
          s = i.to_s;
          t0 = @current_time
          dfs(graph, i.to_s, s)
          @strong_components_length.push(@current_time - t0)
      end
    end
  end

private
  def dfs graph, node_name, s
    @explored[node_name] = true
    @leader[node_name] = s
    node = graph[node_name]
    for i in 0...node.n_of_edges
      if !@explored.include?(node[i])
        dfs(graph, node[i], s)
      end
    end
    @current_time += 1
    @finishing_time[node_name] = @current_time.to_s;
  end
end

def read_graph
  graph = Graph.new
  File.open("SCC.txt", "r") do |f|
      f.each_line do |line|
          edge = line.split(/\s/).reject(&:empty?)
          node_name = edge[0]
          other_node_name = edge[1]
          graph.add_node(Node.new(node_name))
          graph.add_node(Node.new(other_node_name))
          graph.add_edge(node_name, other_node_name)
      end
  end
  return graph
end

def kosaraju
  start = Time.now
  puts "Starting algorithm"
  graph = read_graph
  puts "Graph loaded in memory " +  (Time.now - start).to_s
  start = Time.now
  dfs = DFSAlgorithm.new
  dfs.execute(graph) 
  puts "First dfs executed " +  (Time.now - start).to_s
  start = Time.now
  graph.rename_nodes(dfs.finishing_time)
  puts "Renamed nodes according to times " +  (Time.now - start).to_s
  start = Time.now
  graph.reverse_edges
  puts "Reverse edges " +  (Time.now - start).to_s
  start = Time.now
  dfs.execute(graph)
  puts "Second dfs executed " +  (Time.now - start).to_s
  puts dfs.strong_components_length.sort
end

kosaraju
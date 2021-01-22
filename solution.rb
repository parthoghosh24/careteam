=begin

Problem Statement

https://gist.github.com/adrianob/acf5125fe071963f9f2f62234c90f94a
=end

class Graph
    attr_accessor :adjacency_list, :visited
    def initialize()
        @adjacency_list = {}
        @visited = {}
    end

    def add_edge(from,to)
        @adjacency_list.key?(from) ? @adjacency_list[from] << to : @adjacency_list[from]=[to]
        @visited[from] = false
    end
end

def build_graph(matrix)
    graph = Graph.new
    row_length = matrix.length-1
    col_length = matrix[0].length-1
    (0..matrix.length-1).each do |row|
        (0..matrix[0].length-1).each do |col|
            # 4 neighbors of matrix[row][col]
            # [row-1][col], [row][col-1], [row][col+1], [row+1][col]
            graph.add_edge([row,col],[row-1,col]) if(row-1 >=0 && row-1 <=row_length && col >=0 && col <=col_length)
            graph.add_edge([row,col],[row,col-1]) if(row >=0 && row <=row_length && col-1 >=0 && col-1 <=col_length)
            graph.add_edge([row,col],[row,col+1]) if(row >=0 && row <=row_length && col+1 >=0 && col+1 <=col_length)
            graph.add_edge([row,col],[row+1,col]) if(row+1 >=0 && row+1 <=row_length && col >=0 && col <=col_length)
        end
    end
    graph
end

def find_group_by_bfs(graph,matrix)
    group = [0,0] # First element is group '1' and second is for group '0'
    
    graph.adjacency_list.keys.each do |target|
        queue = Queue.new
        # calculate groups for 1
        if matrix[target[0]][target[1]] == 1 && !graph.visited[target]
            graph.visited[target] = true if !graph.visited[target]
            graph.adjacency_list[target].each do |neighbor|
                queue.push(neighbor) if matrix[neighbor[0]][neighbor[1]] !=0  && !graph.visited[neighbor]
            end
            
            while !queue.empty?
                coord = queue.pop
                graph.visited[coord] = true if !graph.visited[coord]
                graph.adjacency_list[coord].each do |neighbor|
                    queue.push neighbor if !graph.visited[neighbor] && matrix[neighbor[0]][neighbor[1]] !=0  
                end
            end
            group[0]+=1
        # calculate groups for 0
        elsif matrix[target[0]][target[1]] == 0 && !graph.visited[target]
            graph.visited[target] = true if !graph.visited[target]
            graph.adjacency_list[target].each do |neighbor|
                queue.push(neighbor) if matrix[neighbor[0]][neighbor[1]] !=1  && !graph.visited[neighbor]
            end
            
            while !queue.empty?
                coord = queue.pop
                graph.visited[coord] = true if !graph.visited[coord]
                graph.adjacency_list[coord].each do |neighbor|
                    queue.push neighbor if !graph.visited[neighbor] && matrix[neighbor[0]][neighbor[1]] !=1  
                end
            end
            group[1]+=1
        end
    end
    group
end

def find_groups(matrix)
    graph = build_graph matrix
    find_group_by_bfs graph, matrix
end

#test cases

puts find_groups([[1,0,1,1],[0,1,0,0],[1,0,1,1],[1,0,0,0]]).to_s

puts find_groups([[0,0,1,1],[0,0,1,0],[1,0,0,1],[1,1,1,0]]).to_s

puts find_groups([[1,0,0,0],[0,1,0,0],[0,0,0,0],[1,1,1,1]]).to_s

puts find_groups([[1,0],[0,1]]).to_s

puts find_groups([[1,0],[0,0]]).to_s
class Node

    attr_accessor :data, :left_node, :right_node

    def initialize(data)
        @data = data
        @left_node = nil
        @right_node = nil
    end
end

class Tree

    attr_reader :root, :data

    def initialize(array)
        @data = array.sort.uniq
        @root = build_tree(data)
    end

    def build_tree(array)
    
        return nil if array.empty?
        mid = (array.size - 1) / 2
        root = Node.new(array[mid])

        root.left_node = build_tree(array[0...mid])
        root.right_node = build_tree(array[(mid+1)..-1])

        root
    end

    def insert(value, node = root)
        return "Number exists in tree" if value == node.data

        if value < node.data
            node.left_node.nil? ? node.left_node = Node.new(value) : insert(value, node.left_node)
        else
            node.right_node.nil? ? node.right_node = Node.new(value) : insert(value, node.right_node)
        end
    end

    def delete(value, node = root)
        return node if node.nil?

        if value < node.data
            node.left_node = delete(value, node.left_node)
        elsif value > node.data
            node.right_node = delete(value, node.right_node)
        else
            return node.right_node if node.left_node.nil?
            return node.left_node if node.left_node.nil?

            leftmost_node = leftmost_leaf(node.right_node)
            node.data = leftmost_node.data
            node.right_node = delete(leftmost_node.data, node.right_node)
        end
        node
    end

    def find(value, node = root)

        return node if value == node.data || node.nil?
        
        if value < node.data
            return find(value, node.left_node)
        else
            return find(value, node.right_node)
        end
    end

    def level_order(node = root)

        return node if node.data == nil
        queue = []
        queue.push(node)

        while !queue.empty?
            current_node = queue.shift
            print "#{current_node.data}"
            queue.push(current_node.left_node) if current_node.left_node != nil
            queue.push(current_node.right_node) if current_node.right_node != nil
            queue.shift
        end
    end

    def inorder(node = root)
        return if node.nil?

        inorder(node.left_node)
        print "#{node.data}"
        inorder(node.right_node)
    end

    
    def preorder(node = root)
        return if node.nil?

        print "#{node.data}"
        preorder(node.left_node)
        preorder(node.right_node)
    end

    def postorder(node = root)
        return if node.nil?

        postorder(node.left_node)
        postorder(node.right_node)
        print "#{node.data}"
    end

    def height(node = root)
        unless node.nil? || node == root
            node = (node.instance_of?(Node) ? find(node.data) : find(node))
        end

        return -1 if node.nil?

        [height(node.left_node), height(node.right_node)].max + 1
    end

    def depth(node = root, parent = root, edges = 0)
        return 0 if node == parent
        return -1 if parent.nil?

        if node < parent.data
            edges += 1
            depth(node, parent.left_node, edges)
        elsif node > parent.data
            edges += 1
            depth(node, parent.right_node, edges)
        else
            edges
        end
    end

    def balanced?(node = root)
        return true if node.nil?

        left_height = height(node.left_node)
        right_height = height(node.right_node)

        return true if (left_height - right_height).abs <= 1 && balanced?(node.left_node) && balanced?(node.right_node)
        false
    end

    def rebalance
        self.data = inorder_array()
        self.root = build_tree(data)
    end

    def pretty_print(node = @root, prefix = '', is_left = true)
        pretty_print(node.right_node, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_node
        puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
        pretty_print(node.left_node, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_node
    end

    private
    def leftmost_leaf(node)
        node = node.left_node until node.left_node.nil?
        node
    end

    def inorder_array(node = root, array = [])
        unless node.nil?
            inorder_array(node.left_node, array)
            array << node.data
            inorder_array(node.right_node, array)
        end
        array
    end
end

array = Array.new(15) { rand(1..100) }
bst = Tree.new(array)
puts bst.balanced?
# bst.level_order
# bst.preorder
# bst.postorder
# bst.inorder

# bst.insert(105)
# bst.insert(200)
# bst.insert(120)

# puts bst.balanced?
# bst.rebalance

bst.pretty_print
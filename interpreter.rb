require_relative 'keywords.rb'
require_relative 'parser.rb'


#####
# 	Interpreter
#####

class NodeVisitor
	
	def genericVisit(node)
		raise "No visit_#{node.class.name} method"
	end
end

class Interpreter < NodeVisitor
	attr_accessor :parser

	GLOBAL_SCOPE = {}

	def initialize(parser)
		@parser = parser
	end

	def visit(node)
		methodName = 'visit_' + node.class.name
		begin
			visitor = self.send(methodName, node)
		rescue 
			genericVisit(node)
		end
		return visitor
	end

	def visit_BinOp(node)
		if node.op.type == Keywords::PLUS
			if node.left.token.type == Keywords::STRING or node.right.token.type == Keywords::STRING or visit(node.left).is_a? String or visit(node.right).is_a? String
				ret = "#{visit(node.left)}#{visit(node.right)}"
			else
				ret = visit(node.left) + visit(node.right)
			end
			return ret
		elsif node.op.type == Keywords::MINUS
			return visit(node.left) - visit(node.right)
		elsif node.op.type == Keywords::MULT
			return visit(node.left) * visit(node.right)
		elsif node.op.type == Keywords::DIV
			return visit(node.left) / visit(node.right)
		elsif node.op.type == Keywords::MOD
			return visit(node.left) % visit(node.right)
		elsif node.op.type == Keywords::LESST
			return visit(node.left) < visit(node.right)
		elsif node.op.type == Keywords::GREATERT
			return visit(node.left) > visit(node.right)
		elsif node.op.type == Keywords::LTOEQ
			return visit(node.left) <= visit(node.right)
		elsif node.op.type == Keywords::GTOEQ
			return visit(node.left) >= visit(node.right)
		elsif node.op.type == Keywords::EQ
			return visit(node.left) == visit(node.right)
		elsif node.op.type == Keywords::DNEQ
			return visit(node.left) != visit(node.right)
		end	
	end

	def visit_UnaryOp(node)
		op = node.op.type

		if op == Keywords::PLUS
			return +visit(node.expr)
		elsif op == Keywords::MINUS
			return -visit(node.expr)
		elsif op == Keywords::NOT
			return !visit(node.expr)
		end
	end

	def visit_Print(node)
		puts visit(node.statement)
	end

	def visit_Num(node)
		return node.value
	end

	def visit_Str(node)
		return node.value
	end

	def visit_Assign(node)
		varName = node.left.value
		GLOBAL_SCOPE[varName] = visit(node.right)
	end

	def visit_Var(node)
		varName = node.value
		val = GLOBAL_SCOPE[varName]

		if val == nil
			raise "Variable #{varName} is undefined"
		else 
			return val
		end
	end

	def visit_Compound(node)
		for child in node.children do
			visit(child)
		end
	end

	# TODO: remove visit when creating function calls
	def visit_Block(node)
		GLOBAL_SCOPE[node.name.value] = node.compoundStatement
		visit(node.compoundStatement)
	end

	def visit_NoOp(node)
	end

	def interpret
		tree = @parser.parse()
		visit = visit(tree)
		return visit
	end
end
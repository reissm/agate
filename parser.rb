require_relative 'keywords.rb'
require_relative 'lexer.rb'

#####
# 	Parser
#####

class AST
end

class BinOp < AST
	attr_accessor :left
	attr_accessor :op
	attr_accessor :right

	def initialize(left, op, right)
		@left = left
		@op = op
		@right = right
	end	
end

class UnaryOp < AST
	attr_accessor :token
	attr_accessor :op
	attr_accessor :expr

	def initialize(op, expr)
		@token = op
		@op = op
		@expr = expr
	end
end

class Print < AST
	attr_accessor :token
	attr_accessor :value

	def initialize(token)
		@token = token
		@value = token.value
	end
end

class Num < AST
	attr_accessor :token
	attr_accessor :value

	def initialize(token)
		@token = token
		@value = token.value
	end
end

class Str < AST
	attr_accessor :token
	attr_accessor :value

	def initialize(token)
		@token = token
		@value = token.value
	end
end

class Compound < AST
	attr_accessor :children

	def initialize()
		@children=[]
	end
end

class Assign < AST
	attr_accessor :left
	attr_accessor :op
	attr_accessor :right
	attr_accessor :token

	def initialize(left, op, right)
		@left = left
		@token = op
		@op = op
		@right = right
	end
end

class Var < AST
	attr_accessor :token
	attr_accessor :value

	def initialize(token)
		@token = token
		@value = token.value
	end
end

class Block < AST
	attr_accessor :compoundStatement

	def initialize(compoundStatement)
		@compoundStatement = compoundStatement
	end
end

class NoOp < AST
end

class Parser
	attr_accessor :lexer
	attr_accessor :currentToken

	def initialize(lexer)
		@lexer = lexer
		@currentToken = lexer.getNextToken()
	end

	def error
		raise 'Invalid syntax'
	end

	def eat(tokenType)
		# puts "#{@currentToken.to_s}"
		if @currentToken.type == tokenType
			@currentToken = @lexer.getNextToken()
		else
			error()
		end
	end

	def empty
		return NoOp.new()
	end

	def factor
		token = @currentToken
		if token.type == Keywords::PLUS
			eat(Keywords::PLUS)
			node = UnaryOp.new(token, factor())
			return node
		elsif token.type == Keywords::MINUS
			eat(Keywords::MINUS)
			node = UnaryOp.new(token, factor())
			return node
		elsif token.type == Keywords::INTEGER
			eat(Keywords::INTEGER)
			return Num.new(token)
		elsif token.type == Keywords::STRING
			eat (Keywords::STRING)
			return Str.new(token)
		elsif token.type == Keywords::OPAREN
			eat(Keywords::OPAREN)
			node = expr()
			eat(Keywords::CPAREN)
			return node
		else
			node = variable()
			return node
		end
	end

	def term
		node = factor()

		while [Keywords::MULT, Keywords::DIV].include? @currentToken.type
			token = @currentToken
			if token.type == Keywords::MULT
				eat(Keywords::MULT)
			elsif token.type == Keywords::DIV
				eat(Keywords::DIV)
			end

			node = BinOp.new(node, token, factor())
		end

		return node
	end

	def expr
		node = term()

		while [Keywords::PLUS, Keywords::MINUS].include? @currentToken.type
			token = @currentToken
			if token.type == Keywords::PLUS
				eat(Keywords::PLUS)
			elsif token.type == Keywords::MINUS
				eat(Keywords::MINUS)
			end

			node = BinOp.new(node, token, term())
		end

		return node
	end

	def print
		eat(Keywords::PRINT)
		node = Print.new(@currentToken)
		eat(Keywords::STRING)
		return node
	end

	def variable
		node = Var.new(@currentToken)
		eat(Keywords::ID)
		return node
	end

	def assignmentStatement
		left = variable()
		token = @currentToken
		eat(Keywords::ASSIGN)
		right = expr()
		node = Assign.new(left, token, right)
		return node
	end

	def statement
		if @currentToken.type == Keywords::FUNCTION
			node = compoundStatement()
		elsif @currentToken.type == Keywords::VAR
			eat(Keywords::VAR)
			node = assignmentStatement()
		elsif @currentToken.type == Keywords::ID
			node = assignmentStatement()
		elsif @currentToken.type == Keywords::PRINT
			node = print()
		else
			node = empty()
		end
		return node
	end

	def statementList
		node = statement()

		results = []
		results << node

		while @currentToken.type == Keywords::SEMI do
			eat(Keywords::SEMI)
			results.push(statement())
		end

		if @currentToken.type == Keywords::ID
			error()
		end

		return results
	end

	def compoundStatement
		eat(Keywords::FUNCTION)
		eat(Keywords::OCURLY)
		nodes = statementList()
		eat(Keywords::CCURLY)

		root = Compound.new()

		for node in nodes do
			root.children << node
		end
		return root
	end

	def block
		compoundStatementNode = compoundStatement()
		node = Block.new(compoundStatementNode)
		return node
	end

	def parse
		node = block()
		if @currentToken.type != Keywords::EOF
			error()
		end
		return node
	end
end
require_relative 'keywords.rb'

#####
# 	Lexer
#####

class Token
	attr_accessor :type
	attr_accessor :value

	def initialize(type, value)
		@type = type
		@value = value
	end

	def to_s
		return "Token(#{@type}, #{@value})"
	end
end

class Lexer
	attr_accessor :text
	attr_accessor :pos
	attr_accessor :currentChar

	RESERVED_KEYWORDS = {
		'var' => Token.new('VAR', 'var'),
		'function' => Token.new('FUNCTION', 'function'),
		'print' => Token.new('PRINT', 'print')
	};

	def initialize(text)
		@text = text
		@pos = 0
		@currentChar = @text[@pos]
	end

	def _id
		result = ''
		while @currentChar != nil and currentChar.is_alpha? do
			result += @currentChar
			advance()
		end

		token = RESERVED_KEYWORDS.fetch(result, Token.new(Keywords::ID, result))
		return token
	end

	def error()
		raise 'Invalid character'
	end

	def advance
		@pos += 1
		if @pos > @text.length - 1 then
			@currentChar = nil
		else 
			@currentChar = @text[@pos]
		end
	end

	def skipWhitespace
		while @currentChar != nil and @currentChar.is_blank?
			advance()
		end
	end

	def number
		result = ''
		while @currentChar != nil and @currentChar.is_integer? do
			result += @currentChar
			advance()
		end

		if @currentChar == '.'
			result += @currentChar
			advance()

			while @currentChar != nil and @currentChar.is_integer? do
				result += @currentChar
				advance()
			end
			token = Token.new('REAL', result.to_f)
		else
			token = Token.new('INTEGER', result.to_i)
		end

		return token
	end

	def str
		result = ''
		advance()
		while @currentChar != nil and @currentChar != '"' do
			result += @currentChar
			advance()
		end
		advance()
		return result
	end

	def peek
		peek_pos = @pos + 1
		if peek_pos > @text.length - 1
			return nil
		else
			return text[peek_pos]
		end
	end

	def getNextToken
		while @currentChar != nil do
			if @currentChar.is_blank? then
				skipWhitespace()
			else
				if @currentChar.is_alpha? then
					return _id()
				end

				if @currentChar.is_integer? then
					return number()
				end

				if @currentChar == '"' then
					return Token.new(Keywords::STRING, str())
				end

				if @currentChar == '=' and peek() != '=' then
					advance()
					return Token.new(Keywords::ASSIGN, '=')
				end

				if @currentChar == '=' and peek() == '=' then
					advance()
					advance()
					return Token.new(Keywords::EQ, '==')
				end

				if @currentChar == '!' and peek() != '=' then
					advance()
					return Token.new(Keywords::NOT, '!')
				end

				if @currentChar == '!' and peek() == '=' then
					advance()
					advance()
					return Token.new(Keywords::DNEQ, '!=')
				end

				if @currentChar == '>' and peek() != '=' then
					advance()
					return Token.new(Keywords::GREATERT, '>')
				end

				if @currentChar == '<' and peek() != '=' then
					advance()
					return Token.new(Keywords::LESST, '<')
				end

				if @currentChar == '>' and peek() == '=' then
					advance()
					advance()
					return Token.new(Keywords::GTOEQ, '>=')
				end

				if @currentChar == '<' and peek() == '=' then
					advance()
					advance()
					return Token.new(Keywords::LTOEQ, '<=')
				end

				if @currentChar == ';' then
					advance()
					return Token.new(Keywords::SEMI, ';')
				end

				if @currentChar == '.' then
					advance()
					return Token.new(Keywords::DOT, '.')
				end

				if @currentChar == '+' then
					advance()
					return Token.new(Keywords::PLUS, '+')
				end

				if @currentChar == '-' then
					advance()
					return Token.new(Keywords::MINUS, '-')
				end

				if @currentChar == '*' then
					advance()
					return Token.new(Keywords::MULT, '*')
				end

				if @currentChar == '/' then
					advance()
					return Token.new(Keywords::DIV, '/')
				end

				if @currentChar == '%' then
					advance()
					return Token.new(Keywords::MOD, '%')
				end

				if @currentChar == '(' then
					advance()
					return Token.new(Keywords::OPAREN, '(')
				end

				if @currentChar == ')' then
					advance()
					return Token.new(Keywords::CPAREN, ')')
				end

				if @currentChar == '{' then
					advance()
					return Token.new(Keywords::OCURLY, '{')
				end

				if @currentChar == '}' then
					advance()
					return Token.new(Keywords::CCURLY, '}')
				end

				error()
			end
		end
		return Token.new(Keywords::EOF, nil)
	end
end
require_relative 'lexer.rb'
require_relative 'parser.rb'
require_relative 'interpreter.rb'

while true
	begin
		print 'spi> '
		text = gets.chomp
	rescue
		break
	end

	lexer = Lexer.new(text)
	parser = Parser.new(lexer)
	interpreter = Interpreter.new(parser)
	result = interpreter.interpret()
	# puts result
end

# function test {var bob = (10 == 2); var hello = "hello"; print(hello + bob);}
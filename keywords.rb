class Keywords
	VAR='VAR'
	FUNCTION='FUNCTION'
	INTEGER='INTEGER'
	PLUS='PLUS'
	MINUS='MINUS'
	MULT='MULT'
	DIV='DIV'
	OPAREN='OPAREN'
	CPAREN='CPAREN'
	OCURLY='OCURLY'
	CCURLY='CCURLY'
	EOF='EOF'
	DOT='DOT'
	ID='ID'
	ASSIGN='ASSIGN'
	SEMI='SEMI'
	PRINT='PRINT'
	DQUOTE='"'
	STRING='STRING'
end

class String
	def is_integer?
		/\A\d+\z/.match(self)
	end

	def is_alpha?
		/^[a-zA-Z_]$/.match(self)
	end

	def is_blank?
		/\s/.match(self)
	end
end
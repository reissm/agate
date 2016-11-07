class Keywords
	# Types
	FUNCTION='FUNCTION'
	INTEGER='INTEGER'
	REAL='REAL'
	STRING='STRING'
	BOOLEAN='BOOLEAN'

	# Arithmetic Operators
	PLUS='PLUS'
	MINUS='MINUS'
	MULT='MULT'
	DIV='DIV'
	MOD='MOD'

	# Logic Operators
	NOT='NOT'
	EQ='EQ'
	DNEQ='DNEQ'
	GREATERT='GREATERT'
	LESST='LESST'
	GTOEQ='GTOEQ'
	LTOEQ='LTOEQ'

	# Braces/ bracket types
	OPAREN='OPAREN'
	CPAREN='CPAREN'
	OCURLY='OCURLY'
	CCURLY='CCURLY'

	# Useful characters
	EOF='EOF'
	DOT='DOT'
	ID='ID'
	ASSIGN='ASSIGN'
	SEMI='SEMI'

	# Other reserved keywords
	PRINT='PRINT'
	VAR='VAR'
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
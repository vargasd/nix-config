; inherits: ecma

; support prisma tagged templates
(call_expression
	function: (member_expression
		property: (property_identifier) @_prop
		(#any-of? @_prop "sql" "$queryRaw" "$executeRaw"))
	arguments: ((template_string) @injection.content
		(#offset! @injection.content 0 1 0 -1)
		(#set! injection.include-children)
		(#set! injection.language "sql")))
; and ones that can be functions
(call_expression
	function: (member_expression
		property: (property_identifier) @_prop
		(#any-of? @_prop "$queryRaw" "$executeRaw" "$queryRawUnsafe" "$executeRawUnsafe"))
	arguments: (arguments
		(template_string) @injection.content)
	(#offset! @injection.content 0 1 0 -1)
	(#set! injection.include-children)
	(#set! injection.language "sql"))

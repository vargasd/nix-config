; inherits: ecma

; support prisma tagged templates
(call_expression
	function: (member_expression
		property: (property_identifier) @_prop
		(#any-of? @_prop "sql" "$queryRaw" "$executeRaw" "$queryRawUnsafe" "$executeRawUnsafe"))
	arguments: ((template_string) @injection.content
		(#offset! @injection.content 0 1 0 -1)
  (#set! injection.include-children)
	(#set! injection.language "sql")))


; extends

; HTML injection for raw string literals with lang=html comment
((comment) @_comment
 .
 (_) @injection.content
 (#lua-match? @_comment ".*lang=html.*")
		(#set! injection.include-children)
		(#set! injection.combined)
		(#set! injection.language html))

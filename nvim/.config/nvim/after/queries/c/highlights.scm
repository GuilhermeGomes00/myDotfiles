; extends

((function_definition type: (_) @type.return)
  (#set! priority 130))
((function_declarator declarator: (identifier) @function)
  (#set! priority 130))
((parameter_declaration type: (_) @type.parameter)
  (#set! priority 130))
((declaration type: (_) @type.local)
  (#set! priority 130))
((storage_class_specifier) @keyword.private
  (#eq? @keyword.private "static")
  (#set! priority 130))

; extends

; Compartilhado por JavaScript, TypeScript e JSX/TSX.
([
  (function_declaration name: (identifier) @function)
  (method_definition name: (property_identifier) @function.method)
] (#set! priority 130))
((class_declaration name: (_) @type.definition)
  (#set! priority 130))
((method_definition ["get" "set"] @keyword.accessor)
  (#set! priority 130))
([(true) (false)] @boolean
  (#set! priority 130))

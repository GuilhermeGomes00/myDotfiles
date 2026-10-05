; extends

((method_declaration type: (_) @type.return)
  (#set! priority 130))
([
  (method_declaration name: (identifier) @function.method)
  (constructor_declaration name: (identifier) @constructor)
  (compact_constructor_declaration name: (identifier) @constructor)
  (class_declaration name: (identifier) @type.definition)
  (interface_declaration name: (identifier) @type.definition)
  (record_declaration name: (identifier) @type.definition)
  (enum_declaration name: (identifier) @type.definition)
] (#set! priority 130))
((formal_parameter type: (_) @type.parameter)
  (#set! priority 130))
((local_variable_declaration type: (_) @type.local)
  (#set! priority 130))
((field_declaration type: (_) @type.property)
  (#set! priority 130))
(["private" "static"] @keyword.private
  (#set! priority 130))
([(true) (false)] @boolean
  (#set! priority 130))

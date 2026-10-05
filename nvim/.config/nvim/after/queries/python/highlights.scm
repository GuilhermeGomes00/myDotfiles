; extends

((function_definition return_type: (_) @type.return)
  (#set! priority 130))
((function_definition name: (identifier) @function)
  (#set! priority 130))
((class_definition name: (identifier) @type.definition)
  (#set! priority 130))
([
  (typed_parameter type: (_) @type.parameter)
  (typed_default_parameter type: (_) @type.parameter)
] (#set! priority 130))
((assignment type: (_) @type.local)
  (#set! priority 130))

; extends

([
  (function_declaration name: (identifier) @function)
  (method_declaration name: (field_identifier) @function.method)
  (type_spec name: (type_identifier) @type.definition)
] (#set! priority 130))
([
  (function_declaration result: (_) @type.return)
  (method_declaration result: (_) @type.return)
] (#set! priority 132))
([
  (parameter_declaration type: (_) @type.parameter)
  (variadic_parameter_declaration type: (_) @type.parameter)
] (#set! priority 130))
; Resultados nomeados também são parâmetros, preservando o cinza claro.
((parameter_declaration name: (identifier) @variable.parameter)
  (#set! priority 135))
((var_spec type: (_) @type.local)
  (#set! priority 130))

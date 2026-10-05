; extends

; Contextos de C# prevalecem sobre os tokens genéricos do Roslyn (125-127).
; As captures recebem a paleta .c_sharp de colorscheme.lua.
((method_declaration returns: (_) @type.return)
  (#set! priority 130))

((local_function_statement type: (_) @type.return)
  (#set! priority 130))

((delegate_declaration type: (_) @type.return)
  (#set! priority 130))

((property_declaration type: (_) @type.property)
  (#set! priority 130))

((parameter type: (_) @type.parameter)
  (#set! priority 130))

((variable_declaration type: (_) @type.local)
  (#not-eq? @type.local "var")
  (#set! priority 130))

; Declarações laranja; chamadas de métodos laranja escuro.
((method_declaration name: (identifier) @function.method)
  (#set! priority 130))

((local_function_statement name: (identifier) @function.method)
  (#set! priority 130))

((constructor_declaration name: (identifier) @constructor)
  (#set! priority 130))

((destructor_declaration name: (identifier) @constructor)
  (#set! priority 130))

((invocation_expression
  function: [
    (identifier) @function.method.call
    (generic_name (identifier) @function.method.call)
    (member_access_expression
      name: [
        (identifier) @function.method.call
        (generic_name (identifier) @function.method.call)
      ])
    (conditional_access_expression
      (member_binding_expression
        name: [
          (identifier) @function.method.call
          (generic_name (identifier) @function.method.call)
        ]))
  ]) (#set! priority 130))

; Roslyn classifica true/false como keywords; os literais continuam escuros.
(["true" "false"] @boolean
  (#set! priority 130))

([
  (class_declaration name: (identifier) @type.definition)
  (interface_declaration name: (identifier) @type.definition)
  (struct_declaration name: (identifier) @type.definition)
  (enum_declaration name: (identifier) @type.definition)
  (record_declaration name: (identifier) @type.definition)
  (delegate_declaration name: (identifier) @type.definition)
] (#set! priority 130))

; get/set/init e private/static ficam cinza escuro.
((accessor_declaration ["get" "set" "init" "add" "remove"] @keyword.accessor)
  (#set! priority 130))

((modifier) @keyword.private
  (#any-of? @keyword.private "private" "static")
  (#set! priority 130))

; A expressão de Regex é escura; as demais strings são cinza claro.
; Inclui new Regex("pattern") e new System.Text.RegularExpressions.Regex(...).
((object_creation_expression
  type: (_) @_regex_type
  arguments: (argument_list . (argument [
    (string_literal)
    (verbatim_string_literal)
    (raw_string_literal)
    (interpolated_string_expression)
  ] @string.regexp)))
  (#match? @_regex_type "\\v(^|\\.)Regex$")
  (#set! priority 135))

; Regex.IsMatch(input, pattern), Match, Matches, Replace e Split.
((invocation_expression
  function: (member_access_expression
    expression: (_) @_regex_type
    name: (identifier) @_regex_method)
  arguments: (argument_list . (argument) . (argument [
    (string_literal)
    (verbatim_string_literal)
    (raw_string_literal)
    (interpolated_string_expression)
  ] @string.regexp)))
  (#match? @_regex_type "\\v(^|\\.)Regex$")
  (#any-of? @_regex_method "IsMatch" "Match" "Matches" "Replace" "Split" "Count" "EnumerateMatches")
  (#set! priority 135))

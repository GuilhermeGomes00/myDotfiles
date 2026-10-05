; extends

((function_declaration
  name: [
    (identifier) @function
    (dot_index_expression field: (identifier) @function)
    (method_index_expression method: (identifier) @function.method)
  ]) (#set! priority 130))

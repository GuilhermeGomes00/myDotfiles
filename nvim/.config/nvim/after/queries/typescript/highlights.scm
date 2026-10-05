; extends

([
  (function_declaration return_type: (type_annotation (_) @type.return))
  (function_expression return_type: (type_annotation (_) @type.return))
  (arrow_function return_type: (type_annotation (_) @type.return))
  (method_definition return_type: (type_annotation (_) @type.return))
  (method_signature return_type: (type_annotation (_) @type.return))
] (#set! priority 130))
((variable_declarator type: (type_annotation (_) @type.local))
  (#set! priority 130))
([
  (required_parameter type: (type_annotation (_) @type.parameter))
  (optional_parameter type: (type_annotation (_) @type.parameter))
] (#set! priority 130))
([
  (public_field_definition type: (type_annotation (_) @type.property))
  (property_signature type: (type_annotation (_) @type.property))
] (#set! priority 130))
([
  (class_declaration name: (type_identifier) @type.definition)
  (interface_declaration name: (type_identifier) @type.definition)
  (enum_declaration name: (identifier) @type.definition)
] (#set! priority 130))
((accessibility_modifier) @keyword.private
  (#eq? @keyword.private "private")
  (#set! priority 130))
("static" @keyword.private
  (#set! priority 130))

locals_without_parens = [
  channel_spec: 1,
  topic: 1,
  description: 1,
  incoming: 1,
  payload: 1,
  tags: 1
]

[
  plugins: [Styler],
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"],
  locals_without_parens: locals_without_parens,
  export: [
    locals_without_parens: locals_without_parens
  ]
]

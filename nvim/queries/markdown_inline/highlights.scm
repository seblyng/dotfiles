; extends

; I want to conceal the backslash in markdown
((backslash_escape) @string.escape
  (#offset! @string.escape 0 0 0 -1)
  (#set! conceal ""))

; Can I also get it to highlight with markup.raw?
((html_tag) @markup.raw
  (#any-of? @markup.raw "<code>" "</code>")
  (#set! conceal "`"))

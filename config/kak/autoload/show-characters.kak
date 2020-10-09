# show-characters
# Show various characters.
#
# Usage
#
# add-highlighter global/show-whitespaces show-whitespaces
# add-highlighter global/show-characters ref show-characters
#
# Faces
#
# – ShowCharactersBackground: default+f
# – ShowCharactersDimmedBackground: default+f
#
# When configuring the faces, it is recommended to keep the faces final.

provide-module show-characters %{
  # Faces
  set-face global ShowCharactersBackground default+f
  set-face global ShowCharactersDimmedBackground default+f

  # Highlighters
  add-highlighter shared/show-characters regions
  add-highlighter shared/show-characters/code default-region group

  # Whitespaces
  add-highlighter shared/show-characters/code/whitespace regex '\h+' 0:ShowCharactersBackground
  add-highlighter shared/show-characters/code/newline regex '\n+' 0:ShowCharactersDimmedBackground
  add-highlighter shared/show-characters/code/tab regex '\t+' 0:red+f
  add-highlighter shared/show-characters/code/trailing-whitespaces regex '\h+$' 0:red+f
  add-highlighter shared/show-characters/code/non-breaking-space regex ' +' 0:red+f

  # Whitespaces – Sentences
  add-highlighter shared/show-characters/code/not-two-spaces-after-sentence regex '[?!.…]\K\h(\h{2,})?(?=\w)' 0:red+f
  add-highlighter shared/show-characters/code/two-spaces-after-sentence regex '[?!.…]\K\h{2}(?=\w)' 0:green+f

  # Whitespaces – Lists
  add-highlighter shared/show-characters/code/one-space-for-ordered-list regex '\d\.\K\h(?=\w)' 0:green+f
  add-highlighter shared/show-characters/code/not-one-space-for-ordered-list regex '\d\.\K\h{2,}(?=\w)' 0:red+f

  # Whitespaces – Words
  add-highlighter shared/show-characters/code/multiple-whitespaces-after-word regex '\w\K\h{2,}' 0:red+f

  # Apostrophes
  add-highlighter shared/show-characters/code/apostrophe regex '\w\K''(?=\w)' 0:red+f

  # Dashes
  add-highlighter shared/show-characters/code/cesure regex '‐+' 0:red+f
  add-highlighter shared/show-characters/code/range-of-values regex '‑+' 0:blue+f
  add-highlighter shared/show-characters/code/u+2013 regex '–+' 0:green+f
  add-highlighter shared/show-characters/code/u+2014 regex '—+' 0:green+bf
  add-highlighter shared/show-characters/code/u+2015 regex '―+' 0:red+f
  add-highlighter shared/show-characters/code/math regex '[−×]+' 0:cyan+f

  # Quotation marks
  add-highlighter shared/show-characters/code/opening-quotation-mark regex '[“‘]+' 0:cyan+f
  add-highlighter shared/show-characters/code/closing-quotation-mark regex '”+' 0:cyan+uf
}

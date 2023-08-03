/+  *synapse-json
|_  pyk=peek
++  grow
  |%
  ++  noun  pyk
  ++  json
    =,  enjs:format
    %.  pyk
    |=  pyk=peek
    ^-  ^json
    %+  frond  -.pyk
    ?-  -.pyk
      %tags      (tags:enjs tags.pyk)
      %clusters  (clusters:enjs clusters.pyk)
      %source    (source:enjs source.pyk)
      %echoes    (echoes:enjs echoes.pyk)
      %locks     (locks:enjs locks.pyk)
    ==
  --
++  grab
  |%
  ++  noun  peek
  --
++  grad  %noun
--

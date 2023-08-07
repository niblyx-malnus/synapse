/-  *synapse
|%
++  dr-to-unix-ms  |=(d=@dr `@ud`(div d (div ~s1 1.000)))
++  to-unix-ms     |=(d=@da `@ud`(dr-to-unix-ms (sub d ~1970.1.1)))
::
++  enjs
  =,  enjs:format
  |%
  ++  tag-id  |=(id=^tag-id ?~(id '/' (rap 3 (scot %p host.id) '/' name.id ~)))
  ::
  ++  tag
    |=  =^tag
    ^-  json
    %-  pairs
    :~  [%name s+name.tag]
        [%description s+description.tag]
    ==
  ::
  ++  tag-update
    |=  upd=^tag-update
    ^-  json
    %+  frond  -.upd
    ?-  -.upd
      %tag          (tag tag.upd)
      %name         s+name.upd
      %description  s+description.upd
    ==
  ::
  ++  tags
    |=  =^tags
    ^-  json
    %-  pairs
    %+  turn  ~(tap by tags)
    |=  [id=^tag-id tg=^tag]
    ^-  [@t json]
    [(tag-id id) (tag tg)]
  ::
  ++  clusters
    |=  =^clusters
    ^-  json
    :-  %a
    %-  zing
    %+  turn  ~(tap by clusters)
    |=  [id=^tag-id =pins]
    %+  turn  ~(tap by pins)
    |=  [[peer=@p subj=@p] =pin]
    ^-  json
    %-  pairs
    :~  [%tag-id s+(tag-id id)]
        [%peer s+(scot %p peer)]
        [%subj s+(scot %p subj)]
        [%pin s+(scot %uv pin)]
    ==
  ++  weight  |=(r=@rs n+(crip (r-co:co (rlys r))))
  ::
  ++  weights
    |=  =^weights
    ^-  json
    %-  pairs
    %+  turn  ~(tap by weights)
    |=  [=pin w=^weight]
    ^-  [@t json]
    [(scot %uv pin) (weight w)]
  ::
  ++  tagged
    |=  =^tagged
    ^-  json
    %-  pairs
    %+  turn  ~(tap by tagged)
    |=  [id=^tag-id =pin]
    ^-  [@t json]
    [(tag-id id) s+(scot %uv pin)]
  ::
  ++  source
    |=  =^source
    ^-  json
    %-  pairs
    %+  turn  ~(tap by source)
    |=  [ship=@p w=^weights t=^tagged]
    ^-  [@t json]
    :-  (scot %p ship)
    %-  pairs
    :~  [%weights (weights w)]
        [%tagged (tagged t)]
    ==
  ::
  ++  vote-emit
    |=  e=(unit [=^weight time=@da])
    ^-  json
    ?~  e  ~
    %-  pairs
    :~  [%weight (weight weight.u.e)]
        [%time (numb (to-unix-ms time.u.e))]
    ==
  ::
  ++  vote-pass
    |=  m=(map @p [^weight @da])
    ^-  json
    %-  pairs
    %+  turn  ~(tap by m)
    |=  [ship=@p w=^weight t=@da]
    ^-  [@t json]
    :-  (scot %p ship)
    %-  pairs
    :~  [%weight (weight w)]
        [%time (numb (to-unix-ms t))]
    ==
  ::
  ++  vote
    |=  =^vote
    ^-  json
    %-  pairs
    :~  [%emit (vote-emit emit.vote)]
        [%pass (vote-pass pass.vote)]
    ==
  ::
  ++  poll
    |=  =^poll
    ^-  json
    %-  pairs
    %+  turn  ~(tap by poll)
    |=  [ship=@p v=^vote]
    ^-  [@t json]
    [(scot %p ship) (vote v)]
  ::
  ++  echoes
    |=  =^echoes
    ^-  json
    :-  %a
    %+  turn  ~(tap by echoes)
    |=  [s=^subject p=^poll]
    ^-  json
    %-  pairs
    :~  [%subject (subject s)]
        [%poll (poll p)]
    ==
  ::
  ++  locks
    |=  ^locks
    ^-  json
    %-  pairs
    :~  [%weight (pairs ~[dude+s/dude.weight path+s/(spat path.weight)])]
        [%tag (pairs ~[dude+s/dude.tag path+s/(spat path.tag)])]
    ==
  ::
  ++  distribution
    |=  =^distribution
    ^-  json
    %-  pairs
    %+  turn  ~(tap by distribution)
    |=  [ship=@p m=^weight p=^weight]
    ^-  [@t json]
    :-  (scot %p ship)
    %-  pairs
    :~  [%mine (weight m)]
        [%peer (weight p)]
    ==
  ::
  ++  aggregate
    |=  a=^aggregate
    ^-  json
    %-  pairs
    :~  [%num s+(scot %ud num.a)]
        [%vot (weight vot.a)]
    ==
  ::
  ++  subject
    |=  =^subject
    ^-  json
    %-  pairs
    :~  [%ship s+(scot %p ship.subject)]
        [%tag-id s+(tag-id tag-id.subject)]
    ==
  ::
  ++  vent
    |=  vnt=^vent
    ^-  json
    ?@  vnt  ~
    %+  frond  -.vnt
    ?-    -.vnt
      %tag-id  s+(tag-id tag-id.vnt)
      %pin     s+(scot %uv pin.vnt)
      ::
        %tag-and-pin
      %-  pairs
      :~  [%tag-id s+(tag-id tag-id.vnt)]
          [%pin s+(scot %uv pin.vnt)]
      ==
      ::
        %distributions
      :-  %a
      %+  turn  d.vnt
      |=  [s=^subject d=^distribution]
      %-  pairs
      :~  [%subject (subject s)]
          [%distribution (distribution d)]
      ==
      ::
        %aggregates
      :-  %a
      %+  turn  a.vnt
      |=  [s=^subject a=^aggregate]
      %-  pairs
      :~  [%subject (subject s)]
          [%aggregate (aggregate a)]
      ==
    ==
  --
 ::
++  dejs
  =,  dejs:format
  |%
  :: json number to @rs
  ++  ns
    |=  jon=json
    ^-  @rs
    ?>  ?=([%n *] jon)
    (rash p.jon (cook ryls (cook royl-cell:^so json-rn)))
  ::
  ++  tag-id
    ;~  pose
      (cold ~ fas)
      ;~  (glue fas)
        ;~(pfix sig fed:ag)
        (cook crip (star prn))
      ==
    ==
  ::
  ++  subject  (ot ~[ship+(su fed:ag) tag-id+(su tag-id)])
  ::
  ++  pin  (cu (cury slav %uv) so)
  ::
  ++  async-create
    ^-  $-(json ^async-create)
    %-  of
    :~  [%tag (ot ~[name+so description+so])]
        [%tag-on-pin (ot ~[name+so description+so ship+(su fed:ag) pin+pin])]
        [%pin (ot ~[ship+(su fed:ag) weight+ns])]
        [%pin-with-tag (ot ~[ship+(su fed:ag) weight+ns tag-id+(su tag-id)])]
        [%pin-with-new-tag (ot ~[ship+(su fed:ag) weight+ns name+so description+so])]
    ==
  ::
  ++  tag-field
    ^-  $-(json ^tag-field)
    %-  of
    :~  [%name so]
        [%description so]
    ==
  ::
  ++  tag-command
    ^-  $-(json ^tag-command)
    %-  ot
    :~
      [%p (su tag-id)]
      :-  %q
      %-  of
      :~  [%update (ar tag-field)]
          [%delete ul]
      ==
    ==
  ::
  ++  pin-command
    ^-  $-(json ^pin-command)
    %-  ot
    :~
      [%p (ot ~[ship+(su fed:ag) pin+pin])]
      :-  %q
      %-  of
      :~  [%update-pin (ot ~[weight+ns])]
          [%delete-pin ul]
          [%put-tag (ot ~[tag-id+(su tag-id)])]
          [%del-tag (ot ~[tag-id+(su tag-id)])]
      ==
    ==
  ::
  ++  lock-command
    ^-  $-(json ^lock-command)
    %-  of
    :~  [%tag (ot ~[dude+so path+pa])]
        [%weight (ot ~[dude+so path+pa])]
        [%kick-tag-locked ul]
    ==
  ::
  ++  vent-read
    ^-  $-(json ^vent-read)
    %-  of
    :~  [%dist-by-subjs (ar subject)]
        [%dist-by-ships (ar (su fed:ag))]
        [%dist-by-tags (ar (su tag-id))]
        [%aggr-by-subjs (ar subject)]
        [%aggr-by-ships (ar (su fed:ag))]
        [%aggr-by-tags (ar (su tag-id))]
    ==
  --
--

/-  *synapse
=>  |%
    +$  state-0  [%0 =tags =clusters =source =echoes =locks]
    +$  card     card:agent:gall
    --
=|  cards=(list card)
|_  [=bowl:gall state-0]
+*  core   .
    state  +<+
++  abet  [(flop cards) state]
++  emit  |=(=card core(cards [card cards]))
++  emil  |=(cadz=(list card) core(cards (weld cadz cards)))
:: tag names cannot exceed 35 characters
:: tag descriptions cannot exceed 140 characters
::
++  validate-tag
  |=  =tag
  ^-  ?
  ?&  (gte 35 (met 3 name.tag))
      (gte 140 (met 3 description.tag))
  ==
:: weights must be in [.-1, .1]
::
++  validate-weight
  |=  =weight
  ^-  ?
  ?&  (gte:rs .1 weight)
      (lte:rs .-1 weight)
  ==
::
++  init-baseline
  ^+  tags
  %+  ~(put by tags)  ~
  :-  'Baseline'
  'General ability to propagate truthful information.'
:: returns our direct weighting of a subject, if it exists
::
++  get-weight
  |=  =subject
  ^-  (unit weight)
  %-  mole  |.
  =/  [=weights =tagged]  (~(got by source) ship.subject)
  =/  upin=(unit pin)     (~(get by tagged) tag-id.subject)
  ?^  upin  (~(got by weights) u.upin)
  :: if we don't weigh this ship on this tag-id,
  :: take the "general" or "baseline" weight
  ::
  (~(got by weights) (~(got by tagged) ~))
:: returns a peer's vote on a subject, if it exists
::
++  get-vote
  |=  [peer=ship =subject]
  ^-  (unit vote)
  %-  mole  |.
  =/  =poll   (~(got by echoes) subject)
  (~(got by poll) peer)
:: convert a vote to a weight
::
++  get-vote-weight
  |=  =vote
  ^-  (unit weight)
  ?^  emit.vote  `weight.u.emit.vote
  =/  len=@ud  ~(wyt by pass.vote)
  ?:  =(0 len)  ~
  =/  sum=@rs
    %-  ~(rep by pass.vote)
    |=([p=[* w=weight *] q=@rs] (add:rs w.p q))
  `(div:rs sum (sun:rs len))
::
++  subjects-from-ship
  |=  =ship
  ^-  (list subject)
  =/  [* =tagged]  (~(got by source) ship)
  %+  turn  ~(tap in ~(key by tagged))
  |=(=tag-id [ship tag-id])
::
++  subjects-from-tag-id
  |=  =tag-id
  ^-  (list subject)
  %+  murn  ~(tap by source)
  |=  [=ship * =tagged]
  ?.  (~(has by tagged) tag-id)
    ~
  (some [ship tag-id])
::
++  handle-vent-read
  |=  ryd=vent-read
  ^-  vent
  ?-    -.ryd
      %dist-by-subjs
    :-  %distributions
    %+  turn  list.ryd
    |=  =subject
    :-  subject
    (weighted-distribution subject)
    ::
      %dist-by-ships
    :-  %distributions
    %-  zing
    %+  turn  list.ryd
    |=  =ship
    %+  turn  (subjects-from-ship ship)
    |=  =subject
    :-  subject
    (weighted-distribution subject)
    ::
      %dist-by-tags
    :-  %distributions
    %-  zing
    %+  turn  list.ryd
    |=  =tag-id
    %+  turn  (subjects-from-tag-id tag-id)
    |=  =subject
    :-  subject
    (weighted-distribution subject)
    ::
      %aggr-by-subjs
    :-  %aggregates
    ^-  (list [subject aggregate])
    %+  turn  list.ryd
    |=  =subject
    :-  subject
    (weighted-aggregate subject)
    ::
      %aggr-by-ships
    :-  %aggregates
    %-  zing
    %+  turn  list.ryd
    |=  =ship
    %+  turn  (subjects-from-ship ship)
    |=  =subject
    :-  subject
    (weighted-aggregate subject)
    ::
      %aggr-by-tags
    :-  %aggregates
    %-  zing
    %+  turn  list.ryd
    |=  =tag-id
    %+  turn  (subjects-from-tag-id tag-id)
    |=  =subject
    :-  subject
    (weighted-aggregate subject)
  ==
:: returns map from peer to a pair of
:: (1) our weight of them and
:: (2) their weight of the subject
::
++  weighted-distribution
  |=  =subject
  ^-  distribution
  ?~  poll=(~(get by echoes) subject)  ~
  %-  ~(gas by *distribution)
  %+  murn  ~(tap by u.poll)
  |=  [peer=ship =vote]
  ^-  (unit [ship weight weight])
  ?~  mine=(get-weight peer tag-id.subject)  ~
  =/  =weight  (need (get-vote-weight vote))
  [~ peer u.mine weight]
:: returns number of voters and weighted average of votes
::
++  weighted-aggregate
  |=  =subject
  ^-  aggregate
  =/  dis=distribution
    (weighted-distribution subject)
  =;  vot=weight
    :-  (lent dis)
    (div:rs vot (sun:rs (lent dis)))
  %+  roll  ~(val by dis)
  |=  [[our=weight pyr=weight] vot=weight]
  (add:rs vot (mul:rs our pyr))
:: a function to gate who to share our weightings with
:: potentially delegated out to another agent
::
++  got-weight-lock
  .^  weight-lock  %gx
    ;:  weld
      /(scot %p our.bowl)/[dude.weight.locks]/(scot %da now.bowl)
      path.weight.locks  /noun
    ==
  ==
:: a function to gate who to share our tags with
:: potentially delegated out to another agent
::
++  got-tag-lock
  .^  tag-lock  %gx
    ;:  weld
      /(scot %p our.bowl)/[dude.tag.locks]/(scot %da now.bowl)
      path.tag.locks  /noun
    ==
  ==
::
++  kick-tag-locked
  ^-  (list card)
  %-  zing
  %+  turn  ~(tap in ~(key by tags))
  |=  =tag-id
  ?>  ?=(^ tag-id)
  %+  murn  ~(val by sup.bowl)
  |=  [=ship =path]
  ^-  (unit card)
  ?.  ?=([%tag @t @t ~] path)  ~
  ?:  (got-tag-lock ship tag-id)  ~
  [~ %give %kick ~[/tag/(scot %p host.tag-id)/[name.tag-id]] `ship]
:: send all our weights to a ship (gated by lock)
::
++  send-our-weights
  |=  to=ship
  ^-  (list card)
  %-  zing
  %+  turn  ~(tap by source)
  |=  [=ship =weights =tagged]
  %+  murn  ~(tap by tagged)
  |=  [=tag-id =pin]
  ^-  (unit card)
  ?.  (got-weight-lock [to ship tag-id])  ~
  =/  =weight  (~(got by weights) pin)
  =/  =ballot
    [[ship tag-id] %emit ~ weight pin]
  [~ %give %fact ~ ballot+!>(ballot)]
:: propagate all secondhand weights to a ship (gated by lock)
::
++  propagate-all
  |=  to=ship
  ^-  (list card)
  %-  zing
  %+  turn  ~(tap by echoes)
  |=  [[=ship =tag-id] =poll]
  ^-  (list card)
  %+  murn  ~(tap by poll)
  |=  [peer=^ship =vote]
  ^-  (unit card)
  ?.  (got-weight-lock [to ship tag-id])  ~
  ?~  mine=(get-weight ship tag-id)  ~
  =/  =weight  (need (get-vote-weight vote))
  =/  =ballot  [[ship tag-id] %pass %& peer (mul:rs u.mine weight)]
  [~ %give %fact ~ ballot+!>(ballot)]
::
++  apply-pass-ballot
  |=  [peer=ship =ballot]
  ^-  vote
  =/  =vote  (fall (get-vote peer p.ballot) *vote)
  ?>  ?=(%pass -.q.ballot)  
  =+  q.ballot :: expose for convenience
  ?-    -.p
    %|  vote(pass (~(del by pass.vote) p.p))
    %&  vote(pass (~(put by pass.vote) ship.p.p [weight.p.p now.bowl]))
  ==
::
++  echoes-update
  |=  [peer=ship =ballot]
  ^+  echoes
  =/  [=ship =tag-id]  p.ballot
  =/  =poll  (~(gut by echoes) p.ballot *poll)
  ?-    -.q.ballot
      %emit
    =/  =vote  (fall (get-vote peer p.ballot) *vote)
    =.  emit.vote
      ?~  wip=p.q.ballot  ~
      [~ weight.u.wip now.bowl]
    =.  poll
      ?:  =([~ ~] vote)  (~(del by poll) peer)
      (~(put by poll) peer vote)
    (~(put by echoes) p.ballot poll)
    ::
      %pass
    =/  =vote  (apply-pass-ballot peer ballot)
    =.  poll
      ?:  =([~ ~] vote)  (~(del by poll) peer)
      (~(put by poll) peer vote)
    (~(put by echoes) p.ballot poll)
  ==
::
++  clusters-update
  |=  [peer=ship =ballot]
  ^+  clusters
  ?.  ?=(%emit -.q.ballot)  clusters
  ?~  p.q.ballot
    =/  =pins  (~(gut by clusters) tag-id.p.ballot *pins)
    %+  ~(put by clusters)
      tag-id.p.ballot
    (~(del by pins) [peer ship.p.ballot])
  =/  =pins  (~(gut by clusters) tag-id.p.ballot *pins)
  %+  ~(put by clusters)
    tag-id.p.ballot
  %+  ~(put by pins)
    [peer ship.p.ballot]
  pin.u.p.q.ballot
::
++  propagate
  |=  [to=ship peer=ship subject]
  ^-  (unit card)
  ?.  (got-weight-lock [to ship tag-id])  ~
  =;  =ballot  [~ %give %fact ~[/give/(scot %p to)] ballot+!>(ballot)]
  ?~  mine=(get-weight peer tag-id)    [[ship tag-id] %pass %| peer]
  ?~  vot=(get-vote peer ship tag-id)  [[ship tag-id] %pass %| peer]
  ?~  wet=(get-vote-weight u.vot)      [[ship tag-id] %pass %| peer]
  [[ship tag-id] %pass %& peer (mul:rs u.mine u.wet)]
::
++  propagate-to-followers
  |=  [peer=ship =subject]
  ^-  (list card)
  %+  murn  ~(val by sup.bowl)
  |=  [to=ship =path]
  ?.  ?=([%give @t ~] path)  ~
  (propagate to peer subject)
::
++  propagate-peer
  |=  peer=ship
  ^-  (list card)
  %-  zing
  %+  turn  ~(tap by echoes)
  |=  [=subject =poll]
  ^-  (list card)
  %-  zing
  %+  turn  ~(tap by poll)
  |=  [peer=ship vote]
  ^-  (list card)
  ?.  =(peer ^peer)  ~
  (propagate-to-followers peer subject)
::
++  emit-ballots
  |=  [=subject payload=(unit [weight pin])]
  ^-  (list card)
  %+  murn  ~(val by sup.bowl)
  |=  [to=^ship =path]
  ?.  ?=([%give @t ~] path)  ~
  ?.  (got-weight-lock [to subject])  ~
  =/  =ballot  [subject %emit payload]
  [~ %give %fact ~[/give/(scot %p to)] ballot+!>(ballot)]
::
++  send-pin-update
  |=  [=ship =pin =weight]
  ^-  (list card)
  =/  [* =tagged]  (~(got by source) ship)
  %-  zing
  %+  turn  ~(tap by tagged)
  |=  [=tag-id =^pin]
  ^-  (list card)
  ?.  =(pin ^pin)  ~
  (emit-ballots [ship tag-id] `[weight pin])
::
++  send-pin-delete
  |=  [=ship =pin]
  ^-  (list card)
  =/  [* =tagged]  (~(got by source) ship)
  %-  zing
  %+  turn  ~(tap by tagged)
  |=  [=tag-id =^pin]
  ^-  (list card)
  ?.  =(pin ^pin)  ~
  (emit-ballots [ship tag-id] ~)
::
++  send-put-tag
  |=  [=ship =tag-id =pin]
  ^-  (list card)
  =/  [=weights =tagged]  (~(got by source) ship)
  =/  =weight             (~(got by weights) pin)
  (emit-ballots [ship tag-id] `[weight pin])
::
++  send-del-tag
  |=  [=ship =tag-id =pin]
  ^-  (list card)
  =/  [=weights =tagged]  (~(got by source) ship)
  =/  =weight             (~(got by weights) pin)
  (emit-ballots [ship tag-id] ~)
:: apply tag updates and emit tag updates
::
++  drop-many
  |=  =tag-id 
  |=  upds=(list tag-update)
  ^+  core
  |-  ?~  upds  core
  %=  $
    upds  t.upds
    core  ((drop tag-id) i.upds)
  ==
:: apply tag update and emit tag update
:: (helps to avoid missing update bugs)
::
++  drop
  |=  =tag-id
  ?>  ?=(^ tag-id)
  |=  upd=tag-update
  ^+  core
  =/  =tag  (~(got by tags) tag-id)
  =.  tag   (do-tag-update upd tag)
  =.  tags  (~(put by tags) tag-id tag)
  =/  =path  /tag/(scot %p host.tag-id)/[name.tag-id]
  (emit %give %fact ~[path] synapse-tag-update+!>(upd))
::
++  do-tag-updates
  |=  [=tag upds=(list tag-update)]
  ^+  tag
  |-  ?~  upds  tag
  %=  $
    upds  t.upds
    tag  (do-tag-update i.upds tag)
  ==
::
++  do-tag-update
  |=  [upd=tag-update =tag]
  ^+  tag
  ?-    -.upd
    %tag          tag.upd
    %name         tag(name name.upd)
    %description  tag(description description.upd)
  ==
--

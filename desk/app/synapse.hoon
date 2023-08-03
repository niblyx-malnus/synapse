/-  *synapse
/+  vio=ventio, dbug, verb, default-agent
:: import to force compilation during testing
::
/=  v-  /ted/vines/synapse
|%
+$  state-0  [%0 =tags =clusters =source =echoes =locks]
+$  card     card:agent:gall
--
=|  state-0
=*  state  -
=<
%-  agent:dbug
%+  verb  |
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
    hc    ~(. +> [bowl ~])
::
++  on-init
  ^-  (quip card _this)
  `this
::
++  on-save   !>(state)
::
++  on-load
  |=  ole=vase
  ^-  (quip card _this)
  =/  old=state-0  !<(state-0 ole)
  =.  state  old
  `this
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  :: forward vent requests directly to the vine
  ::
  ?:  ?=(%vent-request mark)  :_(this ~[(to-vine:vio vase bowl)])
  :: only you can command your %synapse
  ::
  ?>  =(src our):bowl
  ?+    mark  (on-poke:def mark vase)
      %synapse-lock-command
    =+  !<(cmd=lock-command vase)
    ?-    -.cmd
      %tag              `this(t.locks scry.cmd)
      %weight           `this(w.locks scry.cmd)
      %kick-tag-locked  :_(this kick-tag-locked:hc)
    ==
    ::
      %synapse-tag-command
    =+  !<(cmd=tag-command vase)
    :: only you can modify tags created in your name
    ::
    ?>  =(our.bowl host.p.cmd)
    ?-    +<.cmd
        %create
      ?.  (validate-tag:hc +.q.cmd)
        ~|(%invalid-tag !!)
      ?:  (~(has by tags) p.cmd)
        ~|(%tag-id-not-unique !!)
      `this(tags (~(put by tags) p.cmd +.q.cmd))
      ::
        %update
      =^  cards  state
        abet:((drop-many:hc p.cmd) fields.q.cmd)
      [cards this]
      ::
        %delete
      :_  this(tags (~(del by tags) p.cmd))
      [%give %kick ~[/tag/(scot %p host.p.cmd)/[name.p.cmd]] ~]~
    ==
    ::
      %synapse-pin-command
    =+  !<(cmd=pin-command vase)
    =/  [=ship =pin]  p.cmd
      ?<  =(ship our.bowl) :: can't weight self
    ?-    +<.cmd
        %create-pin
      ?.  (validate-weight:hc weight.q.cmd)
        ~|(%invalid-weight !!)
      =/  [=weights =tagged]  (~(gut by source) ship [*weights *tagged])
      ?<  (~(has by weights) pin)
      =.  weights  (~(put by weights) pin weight.q.cmd)
      :_  this(source (~(put by source) ship weights tagged))
      :: follow the person you just weighted
      ::
      =/  =wire  /take/(scot %p ship)
      =/  =path  /give/(scot %p our.bowl)
      ?:  (~(has by wex.bowl) [wire ship dap.bowl])  ~
      [%pass wire %agent [ship dap.bowl] %watch path]~
      ::
        %update-pin
      ?.  (validate-weight:hc weight.q.cmd)
        ~|(%invalid-weight !!)
      =/  [=weights =tagged]  (~(got by source) ship)
      =.  weights  (~(put by weights) pin weight.q.cmd)
      :-  (send-pin-update:hc ship pin weight.q.cmd)
      this(source (~(put by source) ship weights tagged))
      ::
        %delete-pin
      =/  [=weights =tagged]  (~(got by source) ship)
      =.  weights  (~(del by weights) pin)
      :_  this(source (~(put by source) ship weights tagged))
      %+  welp  (send-pin-delete:hc ship pin)
      :: leave the person if you have no more pins for them
      ::
      ?.  =(~ weights)  ~
      =/  =wire  /take/(scot %p ship)
      ?.  (~(has by wex.bowl) [wire ship dap.bowl])  ~
      [%pass wire %agent [ship dap.bowl] %leave ~]~
      ::
        %put-tag
      ?>  (~(has by tags) tag-id.q.cmd)
      =/  [=weights =tagged]  (~(got by source) ship)
      =.  tagged   (~(put by tagged) tag-id.q.cmd pin)
      :-  (send-put-tag:hc ship tag-id.q.cmd pin)
      this(source (~(put by source) ship weights tagged))
      ::
        %del-tag
      ?>  (~(has by tags) tag-id.q.cmd)
      =/  [=weights =tagged]  (~(got by source) ship)
      =.  tagged   (~(del by tagged) tag-id.q.cmd)
      :-  (send-del-tag:hc ship tag-id.q.cmd pin)
      this(source (~(put by source) ship weights tagged))
    ==
  ==
::
++  on-watch
  |=  =(pole knot)
  ^-  (quip card _this)
  ?+    pole  (on-watch:def pole)
    [%vent @ @ ~]  `this
    ::
      [%give ship=@t ~]
    =/  =ship  (slav %p ship.pole)
    ?>  =(src.bowl ship)
    :_  this
    %+  welp
      (send-our-weights:hc ship)
    (propagate-all:hc ship)
    ::
      [%tag host=@t name=@t ~]
    =/  host=ship  (slav %p host.pole)
    ?>  =(our.bowl host)
    =/  =tag-id         [host name.pole]
    =/  tag=(unit tag)  (~(get by tags) tag-id)
    :: shouldn't be able to infer tag-locked out from remote stack trace
    ::
    ?>  &(?=(^ tag) (got-tag-lock:hc src.bowl tag-id))
    :: give initial update
    ::
    :_(this [%give %fact ~ synapse-tag-update+!>([%tag u.tag])]~)
  ==
::
++  on-leave  on-leave:def
::
++  on-peek
  |=  =(pole knot)
  ^-  (unit (unit cage))
  ?+    pole  (on-peek:def pole)
    [%x %default-lock ~]  ``noun+!>(_&)
    [%x %tags ~]          ``noun+!>(tags)
    [%x %source ~]        ``noun+!>(source)
  ==
::
++  on-agent
  |=  [=(pole knot) =sign:agent:gall]
  ^-  (quip card _this)
  ?+    pole  (on-agent:def pole sign)
      [%take ship=@t ~]
    =/  peer=ship  (slav %p ship.pole)
    ?>  =(src.bowl peer)
    ?+  -.sign  (on-agent:def pole sign)
        %kick
      ~&  "{<dap.bowl>}: got kick from {(spud pole)}, resubscribing..."
      :_  this
      [%pass pole %agent [src dap]:bowl %watch /give/(scot %p our.bowl)]~
        %fact
      ?.  ?=(%ballot p.cage.sign)  (on-agent:def pole sign)
      =+  !<(=ballot q.cage.sign)
      =.  echoes    (echoes-update:hc peer ballot)
      =.  clusters  (clusters-update:hc peer ballot)
      :_  this
      %+  welp
        (propagate-to-followers:hc peer p.ballot)
      :: follow new tag-id
      ::
      =/  [host=ship name=term]  tag-id.p.ballot
      =/  =path  /tag/(scot %p host)/[name]
      ?:  (~(has by wex.bowl) [path host dap.bowl])  ~
      [%pass path %agent [host dap.bowl] %watch path]~
    ==
    ::
      [%tag host=@t name=@t ~]
    =/  host=ship  (slav %p host.pole)
    ?>  =(host src.bowl)
    =/  =tag-id  [host name.pole]
    ?+    -.sign  (on-agent:def pole sign)
        %watch-ack
      ?~  p.sign  `this
      %-  (slog 'Subscribe failure.' ~)
      %-  (slog u.p.sign)
      :: clear tag from state on watch nack
      ::
      `this(tags (~(del by tags) tag-id))
      ::
        %kick
      :: resubscribe on kick
      ::
      %-  (slog '%pools: Got kick, resubscribing...' ~)
      :_(this [%pass pole %agent [src dap]:bowl %watch pole]~)
      ::
        %fact
      ?.  =(p.cage.sign %synapse-tag-update)  (on-agent:def pole sign)
      :: incorporate tag update
      ::
      =+  !<(upd=tag-update q.cage.sign)
      =/  =tag  (~(gut by tags) tag-id *tag)
      =.  tag   (do-tag-update:hc upd tag)
      `this(tags (~(put by tags) tag-id tag))
    ==
  ==
::
++  on-arvo
  |=  [=(pole knot) sign=sign-arvo]
  ^-  (quip card:agent:gall _this)
  ?.  ?=([%vent p=@ta q=@ta ~] pole)  (on-arvo:def pole sign)
  ?.  ?=([%khan %arow *] sign)        (on-arvo:def pole sign)
  %-  (slog ?:(?=(%.y -.p.sign) ~ p.p.sign))
  :_(this (vent-arow:vio pole p.sign))
::
++  on-fail   on-fail:def
--
|_  [=bowl:gall cards=(list card)]
+*  core  .
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
:: returns our direct weighting of a subject, if it exists
::
++  get-weight
  |=  =subject
  ^-  (unit weight)
  %-  mole  |.
  =/  [=weights =tagged]  (~(got by source) ship.subject)
  =/  =pin                (~(got by tagged) tag-id.subject)
  (~(got by weights) pin)
:: returns a peer's vote on a subject, if it exists
::
++  get-vote
  |=  [peer=ship =subject]
  ^-  (unit vote)
  %-  mole  |.
  =/  =polls  (~(got by echoes) ship.subject)
  =/  =poll   (~(got by polls) tag-id.subject)
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
:: a function to gate who to share our weightings with
:: potentially delegated out to another agent
::
++  got-weight-lock
  .^  weight-lock  %gx
    ;:  weld
      /(scot %p our.bowl)/[dude.w.locks]/(scot %da now.bowl)
      path.w.locks  /noun
    ==
  ==
:: a function to gate who to share our tags with
:: potentially delegated out to another agent
::
++  got-tag-lock
  .^  tag-lock  %gx
    ;:  weld
      /(scot %p our.bowl)/[dude.t.locks]/(scot %da now.bowl)
      path.t.locks  /noun
    ==
  ==
::
++  kick-tag-locked
  ^-  (list card)
  %-  zing
  %+  turn  ~(tap in ~(key by tags))
  |=  =tag-id
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
  |=  [=ship =polls]
  ^-  (list card)
  %-  zing
  %+  turn  ~(tap by polls)
  |=  [=tag-id =poll]
  ^-  (list card)
  %+  murn  ~(tap by poll)
  |=  [peer=^ship =vote]
  ^-  (unit card)
  ?.  (got-weight-lock [to ship tag-id])  ~
  ?~  mine=(get-weight ship tag-id)  ~
  =/  =weight  (need (get-vote-weight vote))
  =/  =ballot  [[ship tag-id] %pass %& peer (mul:rs u.mine weight)]
  [~ %give %fact ~ ballot+!>(ballot)]
:: returns map from peer to a pair of
:: (1) our weight of them and
:: (2) their weight of the subject
::
++  weighted-distribution
  |=  =subject
  ^-  distribution
  ?~  polls=(~(get by echoes) ship.subject)  ~
  ?~  poll=(~(get by u.polls) tag-id.subject)  ~
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
  =/  =polls  (~(gut by echoes) ship *polls)
  =/  =poll   (~(gut by polls) tag-id *poll)
  ?-    -.q.ballot
      %emit
    =/  =vote  (fall (get-vote peer p.ballot) *vote)
    =.  emit.vote
      ?~  wip=p.q.ballot  ~
      [~ weight.u.wip now.bowl]
    =.  poll
      ?:  =([~ ~] vote)  (~(del by poll) peer)
      (~(put by poll) peer vote)
    =.  polls  (~(put by polls) tag-id poll)
    (~(put by echoes) ship polls)
    ::
      %pass
    =/  =vote  (apply-pass-ballot peer ballot)
    =.  poll
      ?:  =([~ ~] vote)  (~(del by poll) peer)
      (~(put by poll) peer vote)
    =.  polls  (~(put by polls) tag-id poll)
    (~(put by echoes) ship polls)
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
  |=  [=ship =polls]
  ^-  (list card)
  %-  zing
  %+  turn  ~(tap by polls)
  |=  [=tag-id =poll]
  ^-  (list card)
  %-  zing
  %+  turn  ~(tap by poll)
  |=  [peer=^ship vote]
  ^-  (list card)
  ?.  =(peer ^peer)  ~
  (propagate-to-followers peer ship tag-id)
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

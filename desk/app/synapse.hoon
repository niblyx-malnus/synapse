/-  *synapse
/+  vio=ventio, synapse, dbug, verb, default-agent,
:: import to force compilation during testing
::
synapse-json
/=  v-  /ted/vines/synapse
/=  p-  /mar/synapse/peek
/=  p-  /mar/synapse/vent
/=  p-  /mar/synapse/tag-command
/=  p-  /mar/synapse/async-create
/=  p-  /mar/synapse/pin-command
/=  p-  /mar/synapse/vent-read
/=  p-  /mar/synapse/lock-command
/=  p-  /mar/synapse/tag-update
|%
+$  state-0  [%0 =tags =clusters =source =echoes =locks]
+$  card     card:agent:gall
--
=|  state-0
=*  state  -
%-  agent:dbug
%+  verb  |
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
    syn   ~(. synapse [bowl state])
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
      %tag              `this(tag.locks scry.cmd)
      %weight           `this(weight.locks scry.cmd)
      %kick-tag-locked  :_(this kick-tag-locked:syn)
    ==
    ::
      %synapse-tag-command
    =+  !<(cmd=tag-command vase)
    :: only you can modify tags created in your name
    ::
    ?>  =(our.bowl host.p.cmd)
    ?-    +<.cmd
        %create
      ?.  (validate-tag:syn +.q.cmd)
        ~|(%invalid-tag !!)
      ?:  (~(has by tags) p.cmd)
        ~|(%tag-id-not-unique !!)
      `this(tags (~(put by tags) p.cmd +.q.cmd))
      ::
        %update
      =^  cards  state
        abet:((drop-many:syn p.cmd) fields.q.cmd)
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
      ?.  (validate-weight:syn weight.q.cmd)
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
      ?.  (validate-weight:syn weight.q.cmd)
        ~|(%invalid-weight !!)
      =/  [=weights =tagged]  (~(got by source) ship)
      =.  weights  (~(put by weights) pin weight.q.cmd)
      :-  (send-pin-update:syn ship pin weight.q.cmd)
      this(source (~(put by source) ship weights tagged))
      ::
        %delete-pin
      =/  [=weights =tagged]  (~(got by source) ship)
      =.  weights  (~(del by weights) pin)
      :_  this(source (~(put by source) ship weights tagged))
      %+  welp  (send-pin-delete:syn ship pin)
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
      :-  (send-put-tag:syn ship tag-id.q.cmd pin)
      this(source (~(put by source) ship weights tagged))
      ::
        %del-tag
      ?>  (~(has by tags) tag-id.q.cmd)
      =/  [=weights =tagged]  (~(got by source) ship)
      =.  tagged   (~(del by tagged) tag-id.q.cmd)
      :-  (send-del-tag:syn ship tag-id.q.cmd pin)
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
      (send-our-weights:syn ship)
    (propagate-all:syn ship)
    ::
      [%tag host=@t name=@t ~]
    =/  host=ship  (slav %p host.pole)
    ?>  =(our.bowl host)
    =/  =tag-id         [host name.pole]
    =/  tag=(unit tag)  (~(get by tags) tag-id)
    :: shouldn't be able to infer tag-locked out from remote stack trace
    ::
    ?>  &(?=(^ tag) (got-tag-lock:syn src.bowl tag-id))
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
    [%x %state ~]         ``noun+!>(state)
    [%x %default-lock ~]  ``noun+!>(_&)
    [%x %tags ~]          ``synapse-peek+!>(tags+tags)
    [%x %clusters ~]      ``synapse-peek+!>(clusters+clusters)
    [%x %source ~]        ``synapse-peek+!>(source+source)
    [%x %echoes ~]        ``synapse-peek+!>(echoes+echoes)
    [%x %locks ~]         ``synapse-peek+!>(locks+locks)
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
      =.  echoes    (echoes-update:syn peer ballot)
      =.  clusters  (clusters-update:syn peer ballot)
      :_  this
      %+  welp
        (propagate-to-followers:syn peer p.ballot)
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
      =.  tag   (do-tag-update:syn upd tag)
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

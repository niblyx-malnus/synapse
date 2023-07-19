/-  *synapse
/+  dbug, verb, default-agent
|%
+$  state-0  [%0 =tags =source =echoes]
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
++  on-init
  ^-  (quip card _this)
  `this
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
  ?+    mark  (on-poke:def mark vase)
      %synapse-command
    =/  cmd=command  !<(command vase)
    :: only you can command your %synapse
    ::
    ?>  =(src our):bowl
    ?-    +<.cmd
        %create-pin
      =/  [=weights =tagged]  (~(got by source) p.cmd)
      =/  =pin  (sham eny.bowl)
      =.  weights  (~(put by weights) pin weight.q.cmd)
      `this(source (~(put by source) p.cmd weights tagged))
      :: sends no updates
      ::
        %delete-pin
      =/  [=weights =tagged]  (~(got by source) p.cmd)
      =.  weights  (~(del by weights) pin)
      `this(source (~(put by source) p.cmd weights tagged))
      :: sends out a delete message for all
      :: [%| `ship`p.cmd tag-id] for each tag of that pin
      ::
        %update-pin
      =/  [=weights =tagged]  (~(got by source) p.cmd)
      =.  weights  (~(put by weights) [pin weight]:q.cmd)
      `this(source (~(put by source) p.cmd weights tagged))
      :: sends out an add message for all
      :: [%& `ship`p.cmd tag-id weight [~ pin]]
      :: for each tag of that pin
      ::
        %move-tag
      =/  [=weights =tagged]  (~(got by source) p.cmd)
      =.  tagged   (~(put by tagged) [tag-id pin]:q.cmd)
      `this(source (~(put by source) p.cmd weights tagged))
      :: sends a [%| p.cmd tag-id] and then a
      :: [%& p.cmd tag-id weight [~ pin]] for that tag-id
      ::
        %kill-tag
      =/  [=weights =tagged]  (~(got by source) p.cmd)
      =.  tagged   (~(del by tagged) tag-id)
      `this(source (~(put by source) p.cmd weights tagged))
      :: sends a [%| p.cmd tag-id]
    ==
  ==
::
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-peek   on-peek:def
++  on-agent  on-agent:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--

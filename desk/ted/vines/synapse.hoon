/-  spider, *synapse
/+  *ventio
=>  |%
    +$  dude  dude:gall
    --
=,  strand=strand:spider
^-  thread:spider
|=  arg=vase
=/  m  (strand ,vase)
^-  form:m
::
=/  req=(unit [ship dude request])  !<((unit [ship dude request]) arg)
?~  req  (strand-fail %no-arg ~)
=/  [src=ship dap=dude vid=vent-id =mark =noun]  u.req
;<  =vase         bind:m  (unpage mark noun)
;<  =bowl:spider  bind:m  get-bowl
=/  [our=ship now=@da eny=@uvJ]  [our now eny]:bowl
:: only you can command your own %synapse
::
?>  =(src our)
::
|^
?+    mark  (punt [our dap] mark vase) :: poke normally
    %synapse-async-create
  =+  !<(cmd=async-create vase)
  ?-    -.cmd
      %tag
    =/  =tag-id  (unique-tag-id name.cmd)
    :: poke %synapse to create tag with new id
    ::
    =+  synapse-tag-command+!>([tag-id %create [name description]:cmd])
    ;<  ~              bind:m  (poke [our dap] -)
    :: vent the id
    ::
    (pure:m !>(tag-id+tag-id))
    ::
      %pin
    =/  =pin  (unique-pin ship.cmd)
    :: poke %synapse to create tag with new id
    ::
    =+  synapse-pin-command+!>([[ship pin] %create-pin weight.cmd])
    ;<  ~              bind:m  (poke [our dap] -)
    :: vent the id
    ::
    (pure:m !>(pin+pin))
  ==
==
++  sour  (scot %p our)
++  snow  (scot %da now)
++  tags    .^((map tag-id tag) %gx /[sour]/synapse/[snow]/tags/noun)
++  source  .^(^source %gx /[sour]/synapse/[snow]/source/noun)
::
++  unique-pin
  |=  =ship
  ^-  pin
  =/  [=weights =tagged]  (~(got by source) ship)
  |-
  =/  =pin  (sham [now eny])
  ?.  (~(has by weights) pin)
    pin
  $(now +(now))
::
++  unique-tag-id
  |=  name=@t
  |^  `tag-id`(uniquify (tasify name))
  ++  uniquify
    |=  =term
    ^-  tag-id
    ?.  (~(has by tags) [our term])
      [our term]
    =/  num=@t  (numb (end 4 eny))
    $(term (rap 3 term '-' num ~)) :: add random number to end
  ++  numb :: from numb:enjs:format
    |=  a=@u
    ?:  =(0 a)  '0'
    %-  crip
    %-  flop
    |-  ^-  ^tape
    ?:(=(0 a) ~ [(add '0' (mod a 10)) $(a (div a 10))])
  ++  tasify
    |=  name=@t
    ^-  term
    =/  =tape
      %+  turn  (cass (trip name))
      |=(=@t `@t`?~(c=(rush t ;~(pose nud low)) '-' u.c))
    =/  =term
      ?~  tape  %$
      ?^  f=(rush i.tape low)
        (crip tape)
      (crip ['x' '-' tape])
    ?>(((sane %tas) term) term)
  --
--

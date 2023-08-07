|%
+$  pin       @uv
+$  weight    @rs
:: the null tag-id is a place for the "general" or "baseline" weight
::
+$  tag-id    $@(~ [host=ship name=term])
+$  tag       [name=@t description=@t]
:: a place to store short descriptions of tags
::
+$  tags      (map tag-id tag)
:: collect information about how tags cluster
::
+$  pins      (map [peer=ship subj=ship] pin)
+$  clusters  (map tag-id pins)
::
+$  weights   (map pin weight)
+$  tagged    (map tag-id pin)
+$  source    (map ship [=weights =tagged])
::
+$  subject   [=ship =tag-id]
::
+$  duct      (list ship)
+$  haul      (list weight)
+$  pin-list  (list pin)
++  duct-cap  4
:: TODO: change ballot to: (pair subject (each [=duct =haul =pin-list] duct))
::
+$  ballot
  %+  pair  subject
  $%  [%emit p=(unit [=weight =pin])]
      [%pass p=(each [=ship =weight] ship)]
  ==
:: TODO: change vote to (map duct [=haul =time])
:: direct vote is simply at /[subject-ship]
::
+$  vote
  $:  emit=(unit [=weight =time])
      pass=(map ship [=weight =time]) :: secondhand votes
  ==
:: secondhand polls for ships around the network
:: map from your peers to their votes on a ship/tag-id pair
::
+$  poll      (map ship vote)
+$  echoes    (map subject poll)
::
+$  scry      [=dude:gall =path]
:: %& means ALLOWED, %| means BANNED
::
+$  weight-lock  $-([ship subject] ?)
+$  tag-lock     $-([ship tag-id] ?)
::
+$  locks
  $:  weight=$~([%synapse /default-lock] scry)
      tag=$~([%synapse /default-lock] scry)
  ==
:: map from our peers to
:: (1) our weighting of them and
:: (2) their weighting of a subject
::
+$  distribution   (map ship [weight weight])
:: num: total number of voters
:: vot: weighted average of votes
::
+$  aggregate      [num=@ud vot=weight]
::
+$  pin-command
  %+  pair  [=ship =pin]
  $%  [%create-pin =weight]
      [%update-pin =weight]
      [%delete-pin ~]
      [%put-tag =tag-id]
      [%del-tag =tag-id]
  ==
::
+$  tag-field
  $%  [%name name=@t]
      [%description description=@t]
  ==
::
+$  tag-update  $%([%tag =tag] tag-field)
::
+$  tag-command
  %+  pair  tag-id
  $%  [%create name=@t description=@t]
      [%update fields=(list tag-field)]
      [%delete ~]
  ==
::
+$  async-create
  $%  [%tag name=@t description=@t]
      [%tag-on-pin name=@t description=@t =ship =pin]
      [%pin =ship =weight]
      [%pin-with-tag =ship =weight =tag-id]
      [%pin-with-new-tag =ship =weight name=@t description=@t]
  ==
::
+$  lock-command
  $%  [%tag =scry]
      [%weight =scry]
      [%kick-tag-locked ~]
  ==
::
+$  vent-read
  $%  [%dist-by-subjs =(list subject)]
      [%dist-by-ships =(list ship)]
      [%dist-by-tags =(list tag-id)]
      [%aggr-by-subjs =(list subject)]
      [%aggr-by-ships =(list ship)]
      [%aggr-by-tags =(list tag-id)]
  ==
::
+$  vent
  $@  ~
  $%  [%tag-id =tag-id]
      [%pin =pin]
      [%tag-and-pin =tag-id =pin]
      [%distributions d=(list [subject distribution])]
      [%aggregates a=(list [subject aggregate])]
  ==
::
+$  peek
  $%  [%tags =tags]
      [%clusters =clusters]
      [%source =source]
      [%echoes =echoes]
      [%locks =locks]
  ==
--

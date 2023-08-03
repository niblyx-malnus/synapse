|%
+$  pin      @uv
+$  weight   @rs
+$  weights  (map pin weight)
+$  tag-id   [host=ship name=term]
+$  tagged   (map tag-id pin)
::
+$  tag  [name=@t description=@t]
:: a place to store short descriptions of tags
::
+$  tags      (map tag-id tag)
:: collect information about how tags cluster
::
+$  pins      (map [peer=ship subj=ship] pin)
+$  clusters  (map tag-id pins)
::
+$  source    (map ship [=weights =tagged])
::
+$  subject   [=ship =tag-id]
::
+$  ballot
  %+  pair  subject
  $%  [%emit p=(unit [=weight =pin])]
      [%pass p=(each [=ship =weight] ship)]
  ==
::
+$  vote
  $:  emit=(unit [=weight =time])
      pass=(map ship [=weight =time]) :: secondhand votes
  ==
:: map from your peers to their votes on a ship/tag-id pair
::
+$  poll      (map ship vote)
:: a poll for each category
::
+$  polls     (map tag-id poll)
:: TODO: refactor as a mip (low priority)
:: secondhand polls for ships around the network
::
+$  echoes    (map ship polls)
::
+$  scry      [=dude:gall =path]
:: %& means ALLOWED, %| means BANNED
::
+$  weight-lock  $-([ship subject] ?)
+$  tag-lock     $-([ship tag-id] ?)
::
+$  locks
  $:  w=$~([%synapse /default-lock] scry)
      t=$~([%synapse /default-lock] scry)
  ==
:: map from our peers to
:: (1) our weighting of them and
:: (2) their weighting of a subject
::
+$  distribution  (map ship [weight weight])
:: num: total number of voters
:: vot: weighted average of votes
::
+$  aggregate     [num=@ud vot=weight]
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
      [%pin =ship =weight]
  ==
::
+$  lock-command
  $%  [%tag =scry]
      [%weight =scry]
      [%kick-tag-locked ~]
  ==
::
+$  vent
  $@  ~
  $%  [%tag-id =tag-id]
      [%pin =pin]
  ==
--

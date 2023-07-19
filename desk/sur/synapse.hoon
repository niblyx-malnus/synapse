|%
+$  pin      @uv
+$  weight   @rs
+$  weights  (map pin weight)
+$  tag-id   [host=ship name=term]
+$  tagged   (map tag-id pin)
:: a place to store short descriptions of tags
::
+$  tags     (map tag-id desc=@t)
:: your weights of others; when these change, you
:: send updates to subscribers
:: maybe you do actually gate subscriptions
:: maybe the subscription path is literally just /pulse/~zod
:: so if I am ~nec, I follow ~zod's %synapse agent on
:: path /pulse/~nec and he can use the ship in the path
:: to decide whether to send a certain ship/tag-id vote along it...
::
+$  source   (map ship [=weights =tagged])
:: you send this out to your subscribers when your
:: weights change and they update their echoes map
:: and propagate the change to their peers...
:: I was thinking you'd include the whole chain of historic
:: vote information but this seems wasteful and unnecessary...
::
+$  subject  [=ship tag=tag-id]
+$  ballot   (each [subject vote-diff] subject)
::
+$  vote-diff
  $%  [%emit =weight =pin]
      [%pass p=(each [old=(unit weight) new=weight] weight)]
  ==
::
+$  vote
  $%  [%emit =weight =pin =time]
      [%pass =weight count=@ud =time]
  ==
:: map from your peers to their votes on a ship/tag-id pair
::
+$  poll     (map ship vote)
:: a poll for each category
::
+$  polls    (map tag-id poll)
:: secondhand polls for ships around the network
::
+$  echoes   (map ship polls)
:: All of this means you just accumulate weights and
:: categories from people you've rated and then
:: can display that information about a person as
:: an average or as a distribution instantly...
+$  command
  %+  pair  ship
  $%  [%create-pin =weight]
      [%delete-pin =pin]
      [%update-pin =pin =weight]
      [%move-tag =pin =tag-id]
      [%kill-tag =pin =tag-id]
  ==
--

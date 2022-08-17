VAR oxygenRemaining = 72
You awaken on floor.
-> medbay

== medbay ==
    -> updateoxygen ->
    + Go to Navigation. -> mednavhall

== mednavhall ==
    -> updateoxygen ->
    + {navigation} [Return to Medbay.] -> medbay
    + [{Proceed | Return} to Navigation.] -> navigation

== navigation ==
    -> updateoxygen ->
    There is a spacial map with a platform above it. This must be navigation.
    + Go to Medbay. -> mednavhall
    + Go to Oxygen. -> o2NavHall
    + Go to Bridge. -> bridgeNavHall
    + Go to Engine. -> engNavHall
    
== o2NavHall ==
    -> updateoxygen ->
    + Go to Oxygen. -> oxygen
    
== oxygen ==
    -> updateoxygen ->
    + Go to Navigation. -> o2NavHall
    
== bridgeNavHall ==
    -> updateoxygen ->
    + Go to the Bridge. -> bridge
    
== bridge ==
    -> updateoxygen ->
    + Go to Navigation. -> bridgeNavHall
    
== engine ==
    -> updateoxygen ->
    + Go to Navigation. -> navigation
    + Go to the Armory. -> armEngHall
    + Go to the SleepingQuarters. -> sqEngHall
    
== armEngHall ==
    -> updateoxygen ->
    + Go to the Armory. -> armory

== engNavHall ==
    -> END
    
== armory ==
    -> updateoxygen ->
    + Go to Engine. -> armEngHall
    
== sqEngHall ==
    -> updateoxygen ->
    + Go to the SleepingQuarters. -> sleepingQuarters
    
== sleepingQuarters ==
    -> updateoxygen ->
    + Go to Engine. -> sqEngHall
    
    
    
== updateoxygen ==
    ~ oxygenRemaining -= 1
    You have {oxygenRemaining} hours of oxygen left.
->->
    
- They lived happily ever after.
    -> END

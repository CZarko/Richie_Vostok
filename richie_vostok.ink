You awaken on floor.
-> medbay

== medbay ==
    + Go to Navigation. -> mednavhall

== mednavhall ==
    + {navigation} [Return to Medbay.] -> medbay
    + [{Proceed | Return} to Navigation.] -> navigation

== navigation ==
    + Go to Medbay. -> mednavhall
    + Go to Oxygen. -> o2NavHall
    + Go to Bridge. -> bridgeNavHall
    + Go to Engine. -> engNavHall
    
== o2NavHall ==
    + Go to Oxygen. -> oxygen
    
== oxygen ==
    + Go to Navigation. -> o2NavHall
    
== bridgeNavHall ==
    + Go to the Bridge. -> bridge
    
== bridge ==
    + Go to Navigation. -> bridgeNavHall
    
== engine ==
    + Go to Navigation. -> navigation
    + Go to the Armory. -> armEngHall
    + Go to the SleepingQuarters. -> sqEngHall
    
== armEngHall ==
    + Go to the Armory. -> armory
    
== armory ==
    + Go to Engine. -> armEngHall
    
== sqEngHall ==
    + Go to the SleepingQuarters. -> sleepingQuarters
    
== sleepingQuarters ==
    + Go to Engine. -> sqEngHall
    
    
- They lived happily ever after.
    -> END

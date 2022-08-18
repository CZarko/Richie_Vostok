VAR oxygenRemaining = 72
Insert introduction...
-> main

== main ==
    {EnvironmentDescription()}
    <- move(-> main)
    -> updateoxygen ->
-> DONE

LIST locations = hallway, medbay, navigation, oxygen, bridge, engine, armory, quarters
VAR cur_loc = medbay
VAR accessible = (navigation)

== function CanMove(loc) ==
    ~ return accessible ? loc && cur_loc != loc

== move(-> ret) ==
    + {CanMove(medbay)} [Return to Medbay.]
        {cur_loc:
            - hallway:
                ~ accessible = (navigation)
                ~ cur_loc = medbay
            - else:
                ~ accessible = cur_loc + medbay
                ~ cur_loc = hallway
        }
    + {CanMove(navigation)} [{Go|Proceed|Return} to Navigation.]
        {cur_loc:
            - hallway:
                ~ accessible = (medbay, oxygen, engine, bridge)
                ~ cur_loc = navigation
            - else:
                ~ accessible = cur_loc + navigation
                ~ cur_loc = hallway
        }
    + {CanMove(oxygen)} [{Go|Proceed|Return} to Oxygen.]
        {cur_loc:
            - hallway:
                ~ accessible = (navigation)
                ~ cur_loc = oxygen
            - else:
                ~ accessible = cur_loc + oxygen
                ~ cur_loc = hallway
        }
    + {CanMove(bridge)} [{Go|Proceed|Return} to Bridge.]
        {cur_loc:
            - hallway:
                ~ accessible = (navigation)
                ~ cur_loc = bridge
            - else:
                ~ accessible = cur_loc + bridge
                ~ cur_loc = hallway
        }
    + {CanMove(engine)} [{Go|Proceed|Return} to Engine.]
        {cur_loc:
            - hallway:
                ~ accessible = (navigation, armory, quarters)
                ~ cur_loc = engine
            - else:
                ~ accessible = cur_loc + engine
                ~ cur_loc = hallway
        }
    + {CanMove(armory)} [{Go|Proceed|Return} to Armory.]
        {cur_loc:
            - hallway:
                ~ accessible = (engine)
                ~ cur_loc = armory
            - else:
                ~ accessible = cur_loc + armory
                ~ cur_loc = hallway
        }
    + {CanMove(quarters)} [{Go|Proceed|Return} to Sleeping Quarters.]
        {cur_loc:
            - hallway:
                ~ accessible = (engine)
                ~ cur_loc = quarters
            - else:
                ~ accessible = cur_loc + quarters
                ~ cur_loc = hallway
        }
- -> ret

== function EnvironmentDescription() ==
    {cur_loc:
        - hallway:
            # COMPLICATED DEPENDENT ON WHAT IS ACCESSIBLE FROM GIVEN HALLWAY
            Insert description of hallway...
        - medbay:
            Insert description of medbay...
        - navigation:
            Insert description of navigation...
        - oxygen:
            Insert description of oxygen...
        - bridge:
            Insert description of bridge...
        - engine:
            Insert description of engine...
        - armory:
            Insert description of armory...
        - quarters:
            Insert description of quarters...
    }


== updateoxygen ==
    ~ oxygenRemaining -= 1
    You have {oxygenRemaining} hours of oxygen left.
->->

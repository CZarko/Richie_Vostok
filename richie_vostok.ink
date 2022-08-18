CONST MAX_OXYGEN = 72
VAR oxygenRemaining = MAX_OXYGEN
~oxygenRemaining++
Insert introduction...
-> main

== main ==
    {EnvironmentDescription()}
    <- action(-> main)
    -> updateoxygen ->
    {oxygenRemaining: 
        - 0: -> oxygen_deprivation_end
    }
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

== action(-> ret) ==
    + [Investigate elsewhere.] -> move(-> main)
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

== oxygen_deprivation_end ==
    The blaring alarm grows ever fainter, and the audio messages have reached a point of complete illegibility. An intrusive thought interjects...
    "I'm tired..."
    The light of the room is suddenly beginning to fade. The details of the surroundings more difficult to make out. 
    "Where is this?"
    "What was... I... doing?"
    
    Your last moments of feeling give you the vague notion you have fallen, but everything is so dark and you are so tired... what does it matter anyway?
- -> game_over
    

== game_over ==
    With that your journey has come to a horrible end.
- -> END
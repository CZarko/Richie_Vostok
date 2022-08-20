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
/*
== med_nav_hallway_actions(-> ret) ==
    * [Unique one-time medbay/navigation hallway action.] Not yet implemented.
    + [Unique repeatable medbay/navigation hallway action.] Not yet implemented.
- -> ret

== nav_oxy_hallway_actions(-> ret) ==
    * [Unique one-time navigation/oxygen hallway action.] Not yet implemented.
    + [Unique repeatable navigation/oxygen hallway action.] Not yet implemented.
- -> ret

== nav_bri_hallway_actions(-> ret) ==
    * [Unique one-time navigation/bridge hallway action.] Not yet implemented.
    + [Unique repeatable navigation/bridge hallway action.] Not yet implemented.
- -> ret

== nav_eng_hallway_actions(-> ret) ==
    * [Unique one-time navigation/engine hallway action.] Not yet implemented.
    + [Unique repeatable navigation/engine hallway action.] Not yet implemented.
- -> ret

== eng_arm_hallway_actions(-> ret) ==
    * [Unique one-time engine/armory hallway action.] Not yet implemented.
    + [Unique repeatable engine/armory hallway action.] Not yet implemented.
- -> ret

== eng_qua_hallway_actions(-> ret) ==
    * [Unique one-time engine/quarters hallway action.] Not yet implemented.
    + [Unique repeatable engine/quarters hallway action.] Not yet implemented.
- -> ret

== hallway_actions(-> ret) ==
    {accessible:
        - (medbay, navigation):
            <- med_nav_hallway_actions(ret)
        - (navigation, oxygen):
            <- nav_oxy_hallway_actions(ret)
        - (navigation, bridge):
            <- nav_bri_hallway_actions(ret)
        - (navigation, engine):
            <- nav_eng_hallway_actions(ret)
        - (engine, armory):
            <- eng_arm_hallway_actions(ret)
        - (engine, quarters):
            <- eng_qua_hallway_actions(ret)
    }
- -> ret
*/
== medbay_actions(-> ret) ==
    * [Unique one-time medbay action.] Not yet implemented. 
    + [Unique repeatable medbay action.] Not yet implemented. 
- -> ret

== navigation_actions(-> ret) ==
    * [Unique one-time navigation action.] Not yet implemented. 
    + [Unique repeatable navigation action.] Not yet implemented. 
- -> ret

== oxygen_actions(-> ret) ==
    * [Unique one-time oxygen action.] Not yet implemented. 
    + [Unique repeatable oxygen action.] Not yet implemented. 
- -> ret

== bridge_actions(-> ret) ==
    * [Unique one-time bridge action.] Not yet implemented. 
    + [Unique repeatable bridge action.] Not yet implemented. 
- -> ret

== engine_actions(-> ret) ==
    * [Unique one-time engine action.] Not yet implemented. 
    + [Unique repeatable engine action.] Not yet implemented. 
- -> ret

== armory_actions(-> ret) ==
    * [Unique one-time armory action.] Not yet implemented. 
    + [Unique repeatable armory action.] Not yet implemented. 
- -> ret

== quarter_actions(-> ret) ==
    * [Unique one-time quarter action.] Not yet implemented. 
    + [Unique repeatable quarter action.] Not yet implemented. 
- -> ret

== action(-> ret) ==
    {cur_loc:
        /*- hallway:
            <- hallway_actions(ret)*/
        - medbay:
            <- medbay_actions(ret)
        - navigation:
            <- navigation_actions(ret)
        - oxygen:
            <- oxygen_actions(ret)
        - bridge:
            <- bridge_actions(ret)
        - engine:
            <- engine_actions(ret)
        - armory:
            <- armory_actions(ret)
        - quarters:
            <- quarter_actions(ret)
    }
    + [Investigate elsewhere.] -> move(ret)
- -> ret

== function EnvironmentDescription() ==
    {cur_loc:
        - hallway:
            {accessible:
                - (medbay, navigation):
                    Insert description of medbay/navigation hallway...
                - (navigation, oxygen):
                    Insert description of navigation/oxygen hallway... 
                - (navigation, bridge):
                    Insert description of navigation/bridge hallway... 
                - (navigation, engine):
                    Insert description of navigation/engine hallway... 
                - (engine, armory):
                    Insert description of engine/armory hallway... 
                - (engine, quarters):
                    Insert description of navigation/quarters hallway... 
            }
        - medbay:
            A hard bed and very sterile environment? The medical bay of course... but why is there some blood over there?
        - navigation:
            A holographic map with a platform overlooking it? Ah, this must be the navigation room.
        - oxygen:
            Tanks and fauna? No question, the oxygen room. Looks like they were experimenting with recycling air. What is that hissing sound?
        - bridge:
            Rotating chairs pointed at LCD screens with numbers on them and... WOW! Look at that! Space! That is gorgeous! This has to be the bridge room.
        - engine:
            Wow, it's loud in here. Valves relieving pressure and a loud hum? Definitely the engine room.
        - armory:
            Guns, body armor, and other weaponry? The armory room for if we ever run into pirates.
        - quarters:
            Bunk beds and desks? Must be the sleeping quarters.
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
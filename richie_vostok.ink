//https://github.com/inkle/ink/blob/master/Documentation/WritingWithInk.md#multiline-blocks
CONST MAX_OXYGEN = 72
VAR oxygenRemaining = MAX_OXYGEN
~ oxygenRemaining++
VAR hallucination = 0
Drowsily and groaning, I push myself away from the chilled, steel floor. A remnant of drool and cryostasis fluid the only evidence of my presense remaining. Unsettled I glance around the room I find myself in. I do not recognize it.
-> main

== main ==
    {EnvironmentDescription()}
    <- action(-> main)
    -> update_oxygen_and_hallucination ->
    {oxygenRemaining: 
        - 0: -> oxygen_deprivation_end
    }
-> DONE


//
// Movement System
//

LIST locations = hallway, medbay, navigation, oxygen, bridge, engine, armory, quarters
VAR cur_loc = medbay
VAR accessible = (navigation)
VAR accessed = (medbay)

== function CanMove(loc) ==
    ~ return accessible ? loc && cur_loc != loc

== move(-> ret) ==
    {accessed !? cur_loc: 
        ~ accessed += cur_loc
    }
    + {CanMove(medbay)} [Return to Medbay.]
        {cur_loc:
            - hallway:
                ~ accessible = (navigation)
                ~ cur_loc = medbay
            - else:
                ~ accessible = cur_loc + medbay
                ~ cur_loc = hallway
        }
    + {CanMove(navigation)} [{accessed !? navigation: Go | Return} to Navigation.]
        {cur_loc:
            - hallway:
                ~ accessible = (medbay, oxygen, engine, bridge)
                ~ cur_loc = navigation
            - else:
                ~ accessible = cur_loc + navigation
                ~ cur_loc = hallway
        }
    + {CanMove(oxygen)} [{accessed !? oxygen: Go | Return} to Oxygen.]
        {cur_loc:
            - hallway:
                ~ accessible = (navigation)
                ~ cur_loc = oxygen
            - else:
                ~ accessible = cur_loc + oxygen
                ~ cur_loc = hallway
        }
    + {CanMove(bridge)} [{accessed !? bridge: Go | Return} to Bridge.]
        {cur_loc:
            - hallway:
                ~ accessible = (navigation)
                ~ cur_loc = bridge
            - else:
                ~ accessible = cur_loc + bridge
                ~ cur_loc = hallway
        }
    + {CanMove(engine)} [{accessed !? engine: Go | Return} to Engine.]
        {cur_loc:
            - hallway:
                ~ accessible = (navigation, armory, quarters)
                ~ cur_loc = engine
            - else:
                ~ accessible = cur_loc + engine
                ~ cur_loc = hallway
        }
    + {CanMove(armory)} [{accessed !? armory: Go | Return} to Armory.]
        {cur_loc:
            - hallway:
                ~ accessible = (engine)
                ~ cur_loc = armory
            - else:
                ~ accessible = cur_loc + armory
                ~ cur_loc = hallway
        }
    + {CanMove(quarters)} [{accessed !? quarters: Go | Return} to Sleeping Quarters.]
        {cur_loc:
            - hallway:
                ~ accessible = (engine)
                ~ cur_loc = quarters
            - else:
                ~ accessible = cur_loc + quarters
                ~ cur_loc = hallway
        }
- -> ret


//
// Inventory System
//

LIST Props = notebook, charred_tank, dented_tank, valve, wrench, hammer, saw // a list of all items littered throughout the spacecraft
VAR Inventory = (notebook) // the detective's inventory initially begins with only his trusty notebook

// Adds prop from Props LIST to Inventory
== pick_up(prop, -> ret) ==
    ~ Inventory += prop
- -> ret

// Removes prop from Props LIST from Inventory
== use(prop, -> ret) ==
    ~ Inventory -= prop
- -> ret

// Prints a description of prop based on its name
== inspect(prop) ==
    {prop:
        - notebook:
            {hallucination:
                - 3:
                    Jeremy seems to be all right.
                - 2:
                    The mass of paper and binding named Jeremy seems to be in a good condition.
                - 1:
                    A bundle of papers bound together that seem to be breathing...
                - else:
                    A notebook. This detective's best friend.
            }
            * [Discard it?] -> use(notebook, -> main)
        - charred_tank:
            {hallucination:
                - 3:
                    This wonderful glass of dark whiskey sure looks satisfying!
                - 2:
                    This glass of... liquid? It sure looks hydrating... I am quite parched...
                - 1: 
                    This tank of gas has a dark label, which is unusual, but it seems that it stores some oxide in it. Seeing as oxide is normally a sign of the gas being a compound, this seems puzzling, but labels don't lie.
                - else:
                    The gas tank seems in a fine condition, but the label is near impossible to read given the dark charring... Whatever gas is in it ends with oxide... and that's all that can be made out.
            }
            * [Use it?] -> read_the_label_end
        - dented_tank:
            {hallucination:
                - 3:
                    This wonderful glass of light whiskey sure looks satisfying!
                - 2:
                    This glass of... liquid? It sure looks hydrating... I am quite parched...
                - 1: 
                    This tank of gas is in a near pristine state, and the label reads "Maybe you should use me?" How odd...
                - else:
                    Although this gas tank is a tad dented, it seems to be in great shape. Even better, its label reads O2. Perhaps this will help.
            }
            * [Use it?]
                ~ oxygenRemaining += 10
                -> use(dented_tank, -> main)
        - else:
            Uh oh. One of the Developers of this game, has made a mistake and either not removed this temporary prop or forgotten to code a description for it.
    }
    + [Save it for later.] I decided to hold onto it for the time being.
- ->->

// Creates button for inspectuous
== inspect_option(inv, -> ret)
    + [The {LIST_MIN(inv)}.] -> inspect(LIST_MIN(inv)) -> main
- -> ret

// Creates a menu with a button for every prop in the player's current Inventory
// On selection of such a button, the inspect knot is ran for that given prop
== inspectuous(inv, -> ret) ==
    <- inspect_option(inv, -> inspectuous)
    {LIST_COUNT(inv) != 1: <- inspectuous(inv - LIST_MIN(inv), ret)}
    {LIST_COUNT(inv) != 1: -> DONE}
    + [Nevermind.] -> main
- -> ret

// Recursively prints each prop in the player's current Inventory
== function PrintInventory(inv) ==
    A {LIST_MIN(inv)}.
    {LIST_COUNT(inv) != 1:{PrintInventory(inv - LIST_MIN(inv))}}

// The action thread for reviewing the player's current Inventory
== check(-> ret) ==
    I decided now would be a good time to review all of the pieces to this puzzle I had found thus far...
    {PrintInventory(Inventory)}
    I debated inspecting an item further...
    + [Inspect it.] -> inspectuous(Inventory, ret)
    + [Maybe later...]
- -> ret


//
// Room Based Actions
//

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

== medbay_actions(-> ret) ==
    * [Unique one-time medbay action.] Not yet implemented. 
    + [Unique repeatable medbay action.] Not yet implemented. 
- -> ret

== navigation_actions(-> ret) ==
    * [Unique one-time navigation action.] Not yet implemented. 
    + [Unique repeatable navigation action.] Not yet implemented. 
- -> ret

== oxygen_actions(-> ret) ==
    * [Inspect the Oxygen Tanks.] 
        Taking a closer look at the oxygen tanks, I can't help but worry... With this little air left, what if I don't make it... what if...
        No, now is not the time to think like that. Furthermore, on closer inspection there appears to be a portable canister of some sort jammed in between the piping mess. This could be useful.
        [Picked Up ~ Dented Tank]
        -> pick_up(dented_tank, -> main)
    * [Inspect the Filtration System.] 
        As expected, on approaching the filtration system the hissing becomes increasingly excrutiating to my ears. Near unbearable frankly, but now's not that time for excuses...
        On further inspection of the damaged system, it becomes clear that the damage is worse than it looks. The system is no longer capable of filtration... It's barely capable of pumping air throughout the vessel, and who knows how long that will last...
        Worst of all, it's unrepairable.
- -> ret

== bridge_actions(-> ret) ==
    * [Unique one-time bridge action.] Not yet implemented. 
    + [Unique repeatable bridge action.] Not yet implemented. 
- -> ret

== engine_maintenance ==
    Finally, with the valve I have been gain a glance into the engine itself. 
    Absurdly hot, the engine seems to be working over time. Of the various pipes and components of the engine, one keeps rattling... and hissing?
    * {Inventory ? wrench} [Tighten the bolts.] -> you_did_it_end
    + [Leave it alone for now.] 
- -> main

== engine_actions(-> ret) ==
    * [Investigate the charred tank.] 
        A charred gas tank, with the label almost completely covered with charring. It might be useful, so I decided to take it with me.
        [Picked Up ~ Charred Tank]
        -> pick_up(charred_tank, -> main)
    * {Inventory ? valve} [Inspect the engine.] -> engine_maintenance
- -> ret

== armory_actions(-> ret) ==
    * [Unique one-time armory action.] Not yet implemented. 
    * {Inventory ? valve} [Inspect the engine.] -> engine_maintenance 
- -> ret

== sneak_a_peak ==
    There appear to be some objects forgotten here and there in the various chests, but one of them stands out as it contains various tools in it. A note on the front of this particular container reads as such...
            "I'm keeping my tools here now, because CHARLIE keeps borrowing and losing them! As I'm not here to clean up after CHARLIE all the time, I've elected to store them somewhere he can't get them. Sincerely, the only engineer on board, David."
    Peaking in I've seen that there is some wrenches, some hammers, and curiously a few saw?
    * [Take a wrench.] 
        [Picked Up ~ Wrench] 
        -> pick_up(wrench, -> main)
    * [Take a hammer.] 
        [Picked Up ~ Hammer]
        -> pick_up(hammer, -> main)
    * [Take a saw.] 
        [Picked Up ~ Saw]
        -> pick_up(saw, -> main)
- -> main

== quarter_actions(-> ret) ==
    + [Inspect the Blood.]
        Even with a closer look, it is impossible to procure whether it was from a struggle or a mere workplace mishap from this amount of blood.
        Yet, it remains unsettling.
    * [Inspect the Crew's Chests.] -> sneak_a_peak
- -> ret

== action(-> ret) ==
    {cur_loc:
        - hallway:
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
    + [Check inventory.] -> check(ret)
- -> ret

// Depending on the current location and hallucination level of the player
// A description will be printed of the local environment
== function EnvironmentDescription() ==
    {cur_loc:
        - hallway:
            {accessible:
                - (medbay, navigation):
                    {hallucination:
                        - 3:
                            One door says medbay, and the other one says navigation. It’s awfully chilly in this hall, and that hissing sound is also pretty annoying.
                        - 2:
                            dur
                        - 1:
                            dur
                        - else:
                            This is the hallway between the medbay and the main navigation hub. The hallway feels very cool and I can hear a slight hissing sound coming from all sides...
                    }
                - (navigation, oxygen):
                    {hallucination:
                        - 3:
                             I could go to oxygen or navigation. Maybe I should flip a coin to decide where to go. Uh oh, no coins on me so I’ll have to decide. The hissing is louder here.
                        - 2:
                            dur
                        - 1:
                            dur
                        - else:
                            This is the hallway between the oxygen supply and the main navigation hub. The hissing appears to be getting way louder in around here.

                    }
                - (navigation, bridge):
                    {hallucination:
                        - 3:
                            Bridge on this side. Navigation on that side. Man, that word is hard to say. The bridge is flashing red. Is that the party room where everyone is hiding? There’s that annoying hissing sound again.
                        - 2:
                            dur
                        - 1:
                            dur
                        - else:
                            This is the hallway between the bridge and the main navigation hub. There is a red light flashing from inside the bridge and a faint hissing sound coming from all sides.
                    } 
                - (navigation, engine):
                    {hallucination:
                        - 3:
                            Engine is written over this door with a heat coming from it. They must be roasting marshmallows there, or I could go to the other door with nav- nAvIgAtIOn written above it.
                        - 2:
                            dur
                        - 1:
                            dur
                        - else:
                            This is the hallway between the engine room and the main navigation hub. There is a strong heat coming from the direction of the engine room. You can hear a faint hissing coming from the walls.
                    } 
                - (engine, armory):
                    {hallucination:
                        - 3:
                           Let’s see here. I could go back to that toasty room that is the engine room, or I could go to the armory where there is probably a lot of fun to be had. That hissing is getting on my nerves.
                        - 2:
                            dur
                        - 1:
                            dur
                        - else:
                            This is the hallway between the engine room and the armory. There is a strong heat coming from the direction of the engine room. You can hear a faint hissing coming from the walls.
                    }
                - (engine, quarters):
                    {hallucination:
                        - 3:
                            Do I want to return to that hot room, or do I want to go to the cool sounding sleeping quarters? Now that I think about it, I have never seen a quarter sleep. Will that hissing ever stop?
                        - 2:
                            dur
                        - 1:
                            dur
                        - else:
                            This is the hallway between the engine room and the sleeping quarters. There is a strong heat coming from the direction of the engine room. You can hear a faint hissing coming from the walls.
                    } 
            }
        - medbay:
            {hallucination:
                - 3:
                    Things are bad.
                - 2:
                    Things are worse.
                - 1:
                    Things aren't what they were.
                - else:
                    The medbay I find myself in is fairly small and clearly intended to only hold one or two people at max capacity, excluding the space occupied by the now completely empty crew cryo-sleep, but it appears to have been filled to the brim with extra beds. All of which appear to have been both used and vacated in a hurry. 
                    There isn’t any overly complex equipment that can be seen, just the bare minimum required for a ship of this class. There are a couple of basic medkits, some of which have been used, and a couple empty vials of a basic cure-all medicine that is fairly standard to have on vessels going through deep space. It appears the last of which was pumped into the cryotube I most recently emerged from.
                    There is a chart stuck to the tube that might have some details about me and this situation, medically speaking at least. There is also a door that appears to lead to what is dubbed “Navigation.”
            }
        - navigation:
            {hallucination:
                - 3:
                    Things are bad.
                - 2:
                    Things are worse.
                - 1:
                    Things aren't what they were.
                - else:
                    Slipping into the room, a choppy holographic projection catches my eye. It seems to be being emitted from some small device central to the room. Its poor quality makes it particularly difficult to garner any specific details, but it seems to be a map of the ship.
                    Had I been a crew member, I suppose that lack of details would be much less perturbing, considering any and all crew members should be more than familiar with all the facilities aboard. At least, it's enough to gather a sense of the ship's layout, of which I appear to be in the center of.
                    On all four sides of the room are doors, each leading to another major section of the ship. Deducing from the map, it would appear these doors lead to the Medical Bay, the Engines, the Oxygen Supply, and the Bridge, the last of which's door occasionally glows disturbingly red along the edges.
            }
        - oxygen:
            {hallucination:
                - 3:
                    WWWWOOOOOOOOAAAAAAHHHHH!!! Look at all those tanks with O2 written on them. There is one with a singular blinking bar on it, but all the rest are out. I could probably make a good song matching the speed of the light flicker. That hissing sound would make a good background noise to that song. Should these things be like this?
                    Over in the back is some enclosed green things that look like plants inside a device. What would all this do in an oxygen room? And it’s the thing that’s hissing? This probably is not good. Someone should probably do something about that.
                - 2:
                    Things are worse.
                - 1:
                    Things aren't what they were.
                - else:
                    {Entering the room, an all encompassing hissing greets me.|} 
                    The room is budging beyond the brim with ginormous O2 tanks and piping. Horrifyingly, these components which should be teeming with oxygen, are all near depleted. This means one of two things, this ship has been pilgrimaging for much longer than would normally be anticipated, or somewhere there is... a leak.
                    Despite the room's crowding a large filtration system is visible towards the back end of the room, which, among various other functions, is responsible for the distribution and recycling of air all across the ship. It appears to have been severly damaged. It must be the source of that hissing.
            }
        - bridge:
            {hallucination:
                - 3:
                    Things are bad.
                - 2:
                    Things are worse.
                - 1:
                    Things aren't what they were.
                - else:
                    The bridge is mostly intact, although it has definitely seen better days. All the chairs that would normally be in front of their respective stations have been strewn across the room and various displays appear to have been shattered. Numerous tools and instruments are rolling across the floor amidst the various glass shards as the ship slowly continues its drifting through space. Fortunately, the main terminal seems to be relatively whole, excluding a dent or two, and functional, although it repeatedly basks the room in an ominous red. 
                    {Perhaps this warrants some attention.|}
            }
        - engine:
            {hallucination:
                - 3:
                    UGH! This room is blistering hot! Was this where they had their on board sauna? I don’t know why they would put it in a room called engines. That just doesn't seem smart.
                    That big thing over there has a bunch of pipes going to it, and if I look out the window, there are weird pulses coming out from behind that big thing. On the other wall, there are taped out silhouettes where things are missing. Maybe it is a crime scene, but everything is too small for them to be anything from a human. It might have been that someone’s toys were taken from there.
                    Those things up there that look like they open and shut are leaking some spooky, glow-in-the-dark fluid. I bet those missing toys could stop that.
                - 2:
                    Things are worse.
                - 1:
                    Things aren't what they were.
                - else:
                    The first word that comes to mind is hot. The engine is emitting an outrageously blistering heat making it hard to breathe what miniscule memories of air remain on the ship. 
                    The engine is a fairly large contraption connected to the main thrusters at the back of the ship. There are numerous pipes and valves covering the outside of the engine directing fuel and exhaust where it needs to go. Looking at the walls, there appears to be many places where tools COULD be hung up in case repairs are necessary, but all are notably missing-in-action.
                    Several of the valves that litter the room appear to have loosened, and several seem to be leaking various unknown fluids that evaporate almost as soon as they spill. That can't be good.
            }
        - armory:
            {hallucination:
                - 3:
                    Are those laser tag weapons? No way! I bet they had so much fun with these. I wish I had someone to play laser tag with. I am curious if they ever played laser tag with any species not from Earth. I bet that would be super fun.
                    It looks like everyone had their own weapons, armor, and everything. This must have been a fun ship to work on when everyone was around. Some of the wall chests are opened and even missing their things. They must have liked it so much they couldn’t stop playing laser tag even when they left. Someone even built a barricade so that they could win more easily. I bet that guy won the last game of laser tag.
                - 2:
                    Things are worse.
                - 1:
                    Things aren't what they were.
                - else:
                    It's standard for a ship to have some form of armory aboard in order for the crew to properly defend themselves. It's a big galaxy out there and unfortunately quite a few things in it would see humans as the perfect bite sized snack, even other humans... ugh...
                    Lining each of the walls are various lockers filled with the typical standard weapons and armor for this class of ship; nothing too strong, nothing too weak. Most of the lockers appear to be locked up tight though and the few that are open are missing any remnant of equipment. Even more peculiar, of the benches almost all stationed neatly and symmetrically along the length of the room, one sits upturned, dragged to the center as if almost acting as some sort of barrier... but to what?
            }
        - quarters:
            {hallucination:
                - 3:
                    Bunk beds as far as the walls go! This must have been where they had cool late night hangouts. EW, and there are desks too. That must mean they had homework, and they had containers that might have held all their homework. People must have been in a hurry because a lot of things have been dropped on the floor. There are a couple cool shirts, socks, and they even left behind some old pizza. Maybe I should look around to see if there is any leftover warm pizza.
                    Oh, it looks like someone spilled some red jam on the corner of that table over there. I wonder what happened. I’m not sure if the jam was spilled on purpose or by accident. I hope the people eventually get their cool clothes back. It is a shame about the red jam though.
                - 2:
                    Things are worse.
                - 1:
                    Things aren't what they were.
                - else:
                    The sleeping quarters are a big communal space. Beds line the walls with small desks and personalized chest abreast to each one. The various containers, however, seem to have been emptied in great haste. Many small trinkets and litterings of dropped clothes scatter the floor. In their rush, the crew appear to have incidentally left many of their chests open. Perhaps something remains in them. Some food lays scattered upon some of the desktops but it has long since gone cold. It would seem to have been abandoned for at least a couple days.
                    In the back of the room is a modicum of old dried blood on the corner of one of the desks.
            }
    }


//
// Oxygen/Hallucination System
//

== update_oxygen_and_hallucination ==
    ~ oxygenRemaining -= 1
    {A loud, urgent alarm voice shares, |}"You have {oxygenRemaining} hours of oxygen left."
    {That sounds very bad.|}
    
    ~ hallucination = 3 - FLOOR((oxygenRemaining*4)/MAX_OXYGEN)
    {hallucination < 0: 
        ~ hallucination = 0
    }
    //You have {hallucination} hallucination. // TODO: comment out later
->->


//
// Game Over Events
//

== oxygen_deprivation_end ==
    The blaring alarm grows ever fainter, and the audio messages have reached a point of complete illegibility. An intrusive thought interjects...
    "I'm tired..."
    The light of the room is suddenly beginning to fade. The details of the surroundings more difficult to make out. 
    "Where is this?"
    "What was... I... doing?"
    
    Your last moments of feeling give you the vague notion you have fallen, but everything is so dark and you are so tired... what does it matter anyway?
- -> game_over

== read_the_label_end ==
    You do not have a lot of time, and you decide that this would be a good time to use this! Unfortunately, it's never good time to pump yourself full of Sulfur Dioxide.
- -> game_over
    
== game_over ==
    You have met a horrible end.
- -> END

== you_did_it_end ==
    Repairing the engine, you notice that the repetitive oxygen warning has ceased. It would seem that you have found and fixed the issue... or at least the most imminent one.
- -> END
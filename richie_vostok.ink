//https://github.com/inkle/ink/blob/master/Documentation/WritingWithInk.md#multiline-blocks
CONST MAX_OXYGEN = 72
VAR oxygenRemaining = 72
~ oxygenRemaining++
VAR hallucination = 0
** Drowsily and groaning, I push myself away from the chilled, steel floor. 
A remnant of drool and cryostasis fluid the only evidence of my presense remaining. Unsettled I glance around the room I find myself in. I do not recognize it.
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
    # CLEAR
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

LIST Props = notebook, charred_tank, dented_tank, valve_handle, wrench, hammer, saw, meds, book, blaster, screwdriver, crowbar, screws, bolts // a list of all items littered throughout the spacecraft
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
            * [Discard it?] 
                # CLEAR
                -> use(notebook, -> main)
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
                # CLEAR
                ~ oxygenRemaining += 10
                -> use(dented_tank, -> main)
        - valve_handle:
            {hallucination:
                - 3:
                    A metal wheel meant for spinning things open.
                - 2:
                    It's made of metal, circular, and opens doors, I think.
                - 1: 
                    A metal handle meant for opening doors or hatches.
                - else:
                    Some sort of valve handle... perhaps it can be used to open some sort of door or hatch...
            }
        - wrench:
            {hallucination:
                - 3:
                    The wrencher.
                - 2:
                    Metal tool for wrenching.
                - 1: 
                    A wrench.
                - else:
                    A cresent-moon wrench.
            }
        - hammer:
            {hallucination:
                - 3:
                    The hammerer.
                - 2:
                    Tool for hammering.
                - 1: 
                    A hammer.
                - else:
                    A metal hammer.
            }
        - saw:
            {hallucination:
                - 3:
                    I see a saw. Get it.
                - 2:
                    Tool for sawing.
                - 1: 
                    A saw.
                - else:
                    A thin metal saw.
            }
        - meds:
            {hallucination:
                - 3:
                    Magic medicine.
                - 2:
                    Meds that work almost like magic.
                - 1: 
                    Medicinal cure-all.
                - else:
                    Meds that can supposedly cure any ailment.
            }
        - book:
            {hallucination:
                - 3:
                    The will of Mechanos can be felt in the pages.
                - 2:
                    A scribble mess of pages... or perhaps it actually makes sense.
                - 1: 
                    A heavily notated book.
                - else:
                    Some sort of religous book, but filled to the brim with the scribbles of some sort of lunatic.
            }
            * {hallucination == 3} -> mechanos_end
        - blaster:
            {hallucination:
                - 3:
                    My laser-tag rifle.
                - 2:
                    A laser blaster... could be fun.
                - 1: 
                    A gun, with no ammo.
                - else:
                    Standard defensive weaponry for this class of ship. It has no ammo.
            }
        - screwdriver:
            {hallucination:
                - 3:
                    It could really be used to screw me over. Get it?
                - 2:
                    The metal screw stick.
                - 1: 
                    A screwdriver.
                - else:
                    A metal screwdriver. Could be useful.
            }
        - crowbar:
            {hallucination:
                - 3:
                    Magic rod of prying.
                - 2:
                    A metal bar meant for prying.
                - 1: 
                    A crowbar.
                - else:
                    A metal crowbar.
            }
        - screws:
            {hallucination:
                - 3:
                    Snacks.
                - 2:
                    I wouldn't want these sharp and delicous smelling bits to be used against me.
                - 1: 
                    Screws.
                - else:
                    Some metal screws.
            }
            * {hallucination == 3} [Eat.] -> ate_it_end
        - bolts:
            {hallucination:
                - 3:
                    Snacks.
                - 2:
                    Metal... tasty... bolts?
                - 1: 
                    Bolts.
                - else:
                    Some metal bolts.
            }
            * {hallucination == 3} [Eat.] -> ate_it_end
        - else:
            Uh oh. One of the Developers of this game, has made a mistake and either not removed this temporary prop or forgotten to code a description for it.
    }
    + [Save it for later.] 
        # CLEAR
        I decided to hold onto it for the time being.
- ->->

// Creates button for inspectuous
== inspect_option(inv, -> ret)
    + [The {LIST_MIN(inv)}.] 
        # CLEAR
        -> inspect(LIST_MIN(inv)) -> main
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
    {hallucination:
        - 3:
            Oh my gosh, someone was trying to get outside through the window! Why didn't I think about that!? I should leave.
            They seem to have left some mess in front of the window.
            * {Inventory !? crowbar} [Check their mess.] 
                # CLEAR
                A crowbar is here. I can pick up where they left off with this.
                [Picked Up ~ Crowbar]
                -> pick_up(crowbar, -> main)
            * {Inventory ? crowbar} [Go outside.] -> outside_end
        - 2:
            Somebody tried to go outside, but they failed. Sucks for them. Great for me. Space is too cold, or so I hear.
            There is some metal piled in front of the window.
            * {Inventory !? crowbar} [Check the pile.] 
                # CLEAR
                I found a crowbar. I'll take what I can get.
                [Picked Up ~ Crowbar]
                -> pick_up(crowbar, -> main)
        - 1:
            Somebody tried to leave the ship through the window into space. Lucklily they failed spectacularly, because the window is in tip-top shape.
            There are some scraps in front of the window...
            * {Inventory !? crowbar} [Check the scraps.] 
                # CLEAR
                Whoever tried to do this left their crowbar. I'll take it for now.
                [Picked Up ~ Crowbar]
                -> pick_up(crowbar, -> main)
        - else:
            Oddly it appears that someone in this hallway tried to break out throug the window... Into space... it's fortunate that they failed, and that the window seems to be in relatively great shape... 
            There are some metallic scraps on the floor. What happened in here?
            * {Inventory !? crowbar} [Inspect the scraps.] 
                # CLEAR
                There is a crowbar here. It could be useful. 
                [Picked Up ~ Crowbar]
                -> pick_up(crowbar, -> main)
    }
    + ->
- -> ret

== function canCollect(tool, prop) ==
{
    - Inventory !? tool:
        ~ return false
    - Inventory ? prop: 
        ~ return false
    - else:
        ~ return true
}

== nav_oxy_hallway_actions(-> ret) ==
    {hallucination:
        - 3:
            Whoever made this hallway, must have made it for me! It's clean and there are collectible snacks in the walls!
            * {canCollect(screwdriver, screws)} [Collect these snacks.] 
                # CLEAR
                I sure am hungry, and luckily I have the right tool to get these snacks out of the walls.
                ** {Inventory ? bolts} -> greedy_dismantler_end
                ** -> pick_up(screws, -> main)
            * {canCollect(wrench, bolts)} [Collect those snacks.] 
                # CLEAR
                I sure am hungry, and luckily I have the right tool to get these snacks out of the walls.
                {Inventory ? screws} -> greedy_dismantler_end
                -> pick_up(bolts, -> main)
        - 2:
            The hallway is nice... at least, pleasent on my eyes. The delicious metal sticking out from the wall in various places is a bit of a bother, but their delicious aroma makes up for it.
            * {canCollect(screwdriver, screws)} [Get sharp metal bits.] 
                # CLEAR
                These smell great, and I was able to get them out with one of my tools... but they are sharp.
                ** {Inventory ? bolts} -> greedy_dismantler_end
                ** -> pick_up(screws, -> main)
            * {canCollect(wrench, bolts)} [Get flat-ish metal bits.] 
                # CLEAR
                These smell great, and, with the proper tool, now they're mine.
                ** {Inventory ? screws} -> greedy_dismantler_end
                ** -> pick_up(bolts, -> main)
        - 1:
            This hallway is pretty clean, but the walls seem to have some screws and bolts sticking out of them... yikes.
            * {canCollect(screwdriver, screws)} [Unscrew the screws.] 
                # CLEAR
                Might as well use the screwdriver to take the screws.
                ** {Inventory ? bolts} -> greedy_dismantler_end
                ** -> pick_up(screws, -> main)
            * {canCollect(wrench, bolts)} [Unbolt the bolts.] 
                # CLEAR
                Might as well use the wrench to take the bolts.
                ** {Inventory ? screws} -> greedy_dismantler_end
                ** -> pick_up(bolts, -> main)
        - else:
            The state of the hallway is more or less pristine... except for... some loose screws and bolts... that are hanging somewhat out from the wall panels... that might not be good.
            * {canCollect(screwdriver, screws)} [Unscrew the screws.] 
                # CLEAR
                Might as well use the screwdriver to take the screws.
                ** {Inventory ? bolts} -> greedy_dismantler_end
                ** -> pick_up(screws, -> main)
            * {canCollect(wrench, bolts)} [Unbolt the bolts.] 
                # CLEAR
                Might as well use the wrench to take the bolts.
                ** {Inventory ? screws} -> greedy_dismantler_end
                ** -> pick_up(bolts, -> main)
    }
    + ->
- -> ret

== nav_bri_hallway_actions(-> ret) ==
    {hallucination:
        - 0:
            {Inventory !? screwdriver: There's a screwdriver underneath a grate in the floor...}
            * {Inventory ? crowbar} [Pry grate.]
                # CLEAR
                Using the crowbar, I am able to pry the grate to get to the screwdriver. It could be useful.
                [Picked Up ~ Screwdriver]
                -> pick_up(screwdriver, -> main)
        - else:
            {Inventory !? screwdriver: Something is beneath the floors here...}
            * {Inventory ? crowbar} [Check below.]
                # CLEAR
                Using the metal stick of prying, I am able to get beneath the floor.
                ** {Inventory !? screwdriver} 
                    Oh neat, there's a tool down here.
                    [Picked Up ~ Screwdriver]
                    -> pick_up(screwdriver, -> main)
    }
    + ->
- -> ret

== nav_eng_hallway_actions(-> ret) ==
    + ->
- -> ret

== eng_arm_hallway_actions(-> ret) ==
    {hallucination:
        - 3:
            Laser tag gear has been abandoned in the hallway. Maybe I could have some of it.
            * {Inventory !? blaster} [Aquire some gear.] 
                # CLEAR
                They shouldn't have left it here, but I all the armor is too heavily used for me to play too... Though, there seems to be a laser gun here... PERFECT.
                -> pick_up(blaster, -> main)
        - 2:
            Somebody left some gear on the floor, that's not good. They should clean up after themselves better.
            * {Inventory !? blaster} [Check gear.] 
                # CLEAR
                Whatever happened must have been awesome, because this gear has been heavily used. Even better in the pile there seems to be a laser blaster... Finder's keepers.
                -> pick_up(blaster, -> main)
        - 1:
            There's a messy pile of armor on the ground.
            * {Inventory !? blaster} [Check pile.] 
                # CLEAR
                On closer inspection this looks to be a pile of armor that has been shot quite a bit, and under it a blaster seems to have been left. I'll take it.
                -> pick_up(blaster, -> main)
        - else:
            This isn't good. Some equipment from the armory seems to have been dropped here... a messy pile of... riddled armor? What is going on here?
            * {Inventory !? blaster} [Inspect the pile.] 
                # CLEAR
                Searching through the messy pile, doesn't help make heads or tails of what went down here, but I found a blaster. I'll take this just in case.
                -> pick_up(blaster, -> main)
    }
    + ->
- -> ret

== eng_qua_hallway_actions(-> ret) ==
    {hallucination:
        - 3:
            Oh no, a crime must have been committed, but good thing this detective is on the scene. I need to get to the bottom of this mass theft that left so much all over the hall.
            * {Inventory !? book} [Also steal.] 
                # CLEAR
                This book will be mine. 
                -> pick_up(book, -> main)
        - 2:
            Stuff is all over the hallway. Could someone have been stealing all this?
            * {Inventory !? book} [Collect some evidence.] 
                # CLEAR
                Wouldn't want the criminals to get away with it. Perhaps this book will help.
                -> pick_up(book, -> main)
        - 1:
            Crew's stuff seems to be scattered all over the hall. What could have happened here to have caused this?
            * {Inventory !? book} [Search.] 
                # CLEAR
                While most of the stuff around the room is clothing and the sort, this book could be useful. I'll take it.
                -> pick_up(book, -> main)
        - else:
            Some loose articles of clothing... and other personal items mixed in with trash completely litter this hallway.
            * {Inventory !? book} [Search the area.] 
                # CLEAR
                Among the various objects covering the hallway, I find an interesting book. I decide to take it.
                -> pick_up(book, -> main)
    }
    + ->
- -> ret

== medbay_actions(-> ret) ==
    + [Inspect chart.]
        # CLEAR
        {hallucination:
            - 3:
                Oh, please no. I must be dying. Nothing on this chart makes sense. Everything is MOVING. I don't know what tests they must have done, but to get these results...
            - 2:
                I can't read this anymore. None of it makes sense to me. To be fair though, I was never a doctor.
            - 1:
                It's a standard medical check... but some of these numbers seem off.. or maybe I'm seeing them oddly... it's hard to be sure.
            - else:
                A pretty standard medical check, nothing seems abnormal about my condition or vitals according to the chart... curious...
        }
    * {Inventory !? meds} [Take some meds.] 
        # CLEAR
        {hallucination:
            - 3:
                These are mine. No one else needs them. I'm going to cure myself. Hah!
            - 2:
                I don't know what this bottle of pills is, but it's fun to shake it! I'll take them for now.
            - 1:
                A bottle of some pills is visible in the cabinet. I can't quite make out the label. Might as well take them though, just in case they serve some use.
            - else:
                While I might not need them now, there are some pain killers left here, and in an emergency they might be useful. I guess I'll take them.
        }
        [Picked Up ~ Meds]
        -> pick_up(meds, -> main)
- -> ret

== navigation_actions(-> ret) ==
    + [Check the map.] 
        # CLEAR
        {hallucination:
            - 3:
                This is so cool, but it's too fuzzy for it to make any sense. Whoever made it should have done a better job.
            - 2:
                I can read this map. There are four rooms ajoining to this one, and two rooms ajoin to one of those rooms. None of them have English names, but squiggles I cannot fathom pronouncing.
            - 1:
                I don't remember the map being this hard to make out, but I can still vaguely tell what it shows. Connecting to here is the Medbay, Engine, Oxygen, and Bridge. The Engine seems to connect to some sort of Armory and Quarters...
            - else:
                It's not filled with a lot of specifics, but it clearly shows where all the rooms on the ship are. The Medbay, Oxygen supply, Engine, and Bridge are all reachable from here. The Armory and Sleeping Quarters are both reachable from the Engine.
        }
- -> ret

== oxygen_actions(-> ret) ==
    {hallucination:
        - 0:
            * {Inventory !? dented_tank} [Inspect the Oxygen Tanks.] 
                # CLEAR
                Taking a closer look at the oxygen tanks, I can't help but worry... With this little air left, what if I don't make it... what if...
                No, now is not the time to think like that. Furthermore, on closer inspection there appears to be a portable canister of some sort jammed in between the piping mess. This could be useful.
                [Picked Up ~ Dented Tank]
                -> pick_up(dented_tank, -> main)
            * [Inspect the Filtration System.] 
                # CLEAR
                As expected, on approaching the filtration system the hissing becomes increasingly excrutiating to my ears. Near unbearable frankly, but now's not that time for excuses...
                On further inspection of the damaged system, it becomes clear that the damage is worse than it looks. The system is no longer capable of filtration... It's barely capable of pumping air throughout the vessel, and who knows how long that will last...
                Worst of all, it's unrepairable.
                -> ret
        - else:
            * [Look at the Oxygen Tanks.]
                # CLEAR
                It worries me that the oxygen is so depleted. What if I don't make it out of this nightmare. I don't even know why I'm here.
                Looking at the mess of pipes is difficult on my eyes. It's impossible to figure out which pipe goes where. Is this even ship legal?
                -> ret
            * [Look at Filtration System.]
                # CLEAR
                The filtration system hisses annoyingly. It hurts my ears. I wish I would just be leaving already, but no, I wanted to know what was going on.
                It's damaged. Badly. Properly unrepairable. That's great. Not only do most of its functions not work, but there's nothing to be done so this has been a gigantic waste of my time. WONDERFUL.
                -> ret
    }
    + ->
- -> ret

== bridge_actions(-> ret) ==
    + [Check the computer.]
        # CLEAR
        {hallucination:
            - 3:
                Gosh this beauty sure has a lot to say. Who knew she was such a talker?
                "You take my breath away."
                "My stomach is all a flutter."
                "It's kind of hot in here."
                Oh, how cute she is. I wish I had more time to talk.
            - 2:
                The bright screen has so many words on it. I can only understand a few.
                [OXYGEN NOT GOOD.]
                [INSIDE NOT GOOD.]
                [ENGINE IS TOASTY.]
                Wow, those are all pretty clear, I just need to fix them. That sounds easy.
            - 1:
                It's getting harder to understand what I am seeing, but I can make out just enough information from the screen.
                [OXYGEN RAPIDLY DEPLETING.]
                [INTERNAL DAMAGE DETECTED.]
                [ENGINE IS HOT.]
                Well, if they were hard to read, they're just as hard to solve. That bites.
            - else:
                Various alerts appear on the screen.
                [OXYGEN RAPIDLY DEPLETING.]
                [INTERNAL DAMAGE DETECTED.]
                [ENGINE IS HOT.]
                None of these are particularlly helpful, but it's good to have a full list of the various issues on board.
        }
- -> ret

== engine_maintenance ==
    {hallucination:
        - 3:
            The engine is stupid hot. Why did I do this? It just made it worse...
            The inside actually looks kind of cool though, get it. There's so much stuff crammed in here, I wonder if even I could fit in. One of the pipes is shaking like it's ready to party.
            * {Inventory ? wrench} [Cease the party fever.] 
                # CLEAR
                -> you_did_it_end
        - 2:
            The inside of the engine is hotter that it was on the outside. That kind of makes sense, but I don't like it.
            The various things in here all seem okay. Even the jiggling pipe, he likes to move quite a bit!
            * {Inventory ? wrench} [No more jiggling.] 
                # CLEAR
                -> you_did_it_end
        - 1:
            The valve has gained me access to the inside of the engine. It's too hot for my tastes.
            Everything in here is pretty expected... except for a pipe that's moving a bit more than normal...
            * {Inventory ? wrench} [Tighten the pipe down.] 
                # CLEAR
                -> you_did_it_end
        - else:
            Finally, with the valve I have been gain a glance into the engine itself. 
            Absurdly hot, the engine seems to be working over time. Of the various pipes and components of the engine, one keeps rattling... and hissing?
            * {Inventory ? wrench} [Tighten the bolts.] 
                # CLEAR
                -> you_did_it_end
    }
    + [Leave it alone for now.] 
- -> main

== engine_actions(-> ret) ==
    {hallucination:
        - 3:
            * {Inventory !? charred_tank} [Get drink.]
                # CLEAR
                A cool glass of whiskey. Perfect for these temps, and just strong enough to help cope with the current situation.
                [Picked Up ~ Charred Tank]
                -> pick_up(charred_tank, -> main)
        - 2:
            * {Inventory !? charred_tank} [Check liquid.]
                # CLEAR
                Some sort of container of liquid appears to be on the floor. It could help with the heat... maybe...
                [Picked Up ~ Charred Tank]
                -> pick_up(charred_tank, -> main)
        - 2:
            * {Inventory !? charred_tank} [Check gas tank.]
                # CLEAR
                A gas tank of some sort. The label is near impossible to read due to charring. It could be useful.
                [Picked Up ~ Charred Tank]
                -> pick_up(charred_tank, -> main)
        - else:
            * {Inventory !? charred_tank} [Investigate the charred tank.]
                # CLEAR
                A charred gas tank, with the label almost completely covered with charring. It might be useful, so I decided to take it with me.
                [Picked Up ~ Charred Tank]
                -> pick_up(charred_tank, -> main)
    }
    * {Inventory ? valve_handle} [Inspect the engine.] 
        # CLEAR
        -> engine_maintenance
    + ->
- -> ret

== armory_actions(-> ret) ==
    {hallucination:
        - 3:
            * [Check the Lockers.]
                # CLEAR
                These crew members aren't very nice. They didn't leave any laser-tag stuff for me. I want to play too.
                -> ret
            * [Look at rad barrier.] 
                # CLEAR
                This game of laser tag must have been the laser tag to end all laser tags, cause this barrier has been sooooo lasered. Neat.
                -> ret
        - 2:
            * [Check the Lockers.]
                # CLEAR
                The crew took all their blasters and armor from here. That's pretty lame. I would love some.
                -> ret
            * [Look at the barricade.]
                # CLEAR
                This barricade is riddled with laser wholes. Whatever happened here, was cool. I wish I could have seen it.
                -> ret
        - 1:
            * [Inspect the Lockers.]
                # CLEAR
                There's no equipment remaining. Clearly, the crew absconded with it, but why? One locker is damaged. It has some strange holes all over it.
                -> ret
            * [Inspect the bench.]
                # CLEAR
                The bench has been overturned, and covered in bullet holes. Why?
                -> ret
        - else:
            * [Inspect the Lockers.]
                # CLEAR
                Devoid of any equipment, the lockers are simply empty metal containers.... but one locker stands out, as it is riddled with holes... but not those of a bullet... Odd.
                -> ret
            * [Inspect the bench.]
                # CLEAR
                There are bullet holes in the bench. What the heck happened here?
                -> ret
    }
    + ->
- -> ret

== sneak_a_peak == 
    {hallucination:
        - 3:
            The crew left some stuff... Stuff for me to take. One box has a note on it, but I don't care. More importantly, there are some wrenches, hammers, and saws for me to steal.
        - 2:
            There is stuff for me to loot from the various boxes. One box has a lot of stuff in it, but it comes with a note on it. You can't read very good, but... you think it says...
                "THESE ARE MINE, NOT YOURS"
            I don't see them here to stop me.
        - 1: 
            Some of the chests have abandoned things in them. Others do not. One chest has a note in it, and a lot of tools in it. The notes says...
                "I'm keeping my tools here now, because CHARLIE keeps borrowing and losing them! As I'm not here to clean up after CHARLIE all the time, I've elected to store them somewhere he can't get them. Sincerely, the only engineer on board, David."
            Looking in... there's some tools inside.
        - else:
            There appear to be some objects forgotten here and there in the various chests, but one of them stands out as it contains various tools in it. A note on the front of this particular container reads as such...
                    "I'm keeping my tools here now, because CHARLIE keeps borrowing and losing them! As I'm not here to clean up after CHARLIE all the time, I've elected to store them somewhere he can't get them. Sincerely, the only engineer on board, David."
            Peaking in I've seen that there is some wrenches, some hammers, and curiously a few saws?
    }
    * {Inventory !? wrench} [Take a wrench.] 
        [Picked Up ~ Wrench] 
        -> pick_up(wrench, -> main)
    * {Inventory !? hammer} [Take a hammer.] 
        [Picked Up ~ Hammer]
        -> pick_up(hammer, -> main)
    * {Inventory !? saw} [Take a saw.] 
        [Picked Up ~ Saw]
        -> pick_up(saw, -> main)
    + ->
- -> main

== quarter_actions(-> ret) ==
    { hallucination:
        - 3:
            + [Taste Jam.]
                # CLEAR
                This jam does not taste good. Did someone poor metal into it???
                -> ret
            * [Take.] 
                # CLEAR
                -> sneak_a_peak
        - 2:
            + [Look at dry-ish Goop.] 
                # CLEAR
                I don't know what it is... it just is.
                -> ret
            * [Loot.] 
                # CLEAR
                -> sneak_a_peak
        - 1:
            + [Inspect the Stain.]
                # CLEAR
                With a closer look, it appears that the reddish-brown stain is blood. Strange. I don't seem to have any cuts on me.
                -> ret
            * [Inspect the Boxes.] 
                # CLEAR
                -> sneak_a_peak
        - else:
            + [Inspect the Blood.]
                # CLEAR
                Even with a closer look, it is impossible to procure whether it was from a struggle or a mere workplace mishap from this amount of blood.
                Yet, it remains unsettling.
                -> ret
            * [Inspect the Crew's Chests.] 
                # CLEAR
                -> sneak_a_peak
    }
    + ->
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
    + [Check inventory.] 
        # CLEAR
        -> check(ret)
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
                            Medbay or Navigation. Which one should I go to? I still can’t say for certain that it is not a medieval play docking port or medical bay. What is up with that hissing sound by the way?
                        - 1:
                            If my intuition and the Navigation of the ship are correct, this is the hallway connecting the Medbay and the Navigation room, but what are these hissing sounds that make me think they don’t sound so good.......
                        - else:
                            This is the hallway between the medbay and the main navigation hub. The hallway feels very cool and I can hear a slight hissing sound coming from all sides...
                    }
                - (navigation, oxygen):
                    {hallucination:
                        - 3:
                             I could go to oxygen or navigation. Maybe I should flip a coin to decide where to go. Uh oh, no coins on me so I’ll have to decide. The hissing is louder here.
                        - 2:
                            The place with all those containers and the grass is that way, and the room with the map in it is the other way. Which do I need at the moment? That hissing is bugging me.
                        - 1:
                            I think I found the source of the hissing sound, its is the Oxygen room supply, but why is the Oxygen room connected to the Navigation room? It's kind of strange.
                        - else:
                            This is the hallway between the oxygen supply and the main navigation hub. The hissing appears to be getting way louder in around here.

                    }
                - (navigation, bridge):
                    {hallucination:
                        - 3:
                            Bridge on this side. Navigation on that side. Man, that word is hard to say. The bridge is flashing red. Is that the party room where everyone is hiding? There’s that annoying hissing sound again.
                        - 2:
                            Should I go to the party room or the holograph room? I should not call them that. The Bridge and the Navigation. I might forget their names one day.
                        - 1:
                            My intuition told me not to go here, I don’t understand why’d I still be here, also how can I hear these hissing sounds everywhere?
                        - else:
                            This is the hallway between the bridge and the main navigation hub. There is a red light flashing from inside the bridge and a faint hissing sound coming from all sides.
                    } 
                - (navigation, engine):
                    {hallucination:
                        - 3:
                            Engine is written over this door with a heat coming from it. They must be roasting marshmallows there, or I could go to the other door with nav- nAvIgAtIOn written above it.
                        - 2:
                            Ugh. I can feel the heat of that room from here. It makes me want to avoid it altogether, and go back to Navigation. Maybe there is something in there to fix this hissing.
                        - 1:
                            The Navigation room can also lead to the Engine room. In here I can hear a different hissing sound than before, but it also makes me worry.
                        - else:
                            This is the hallway between the engine room and the main navigation hub. There is a strong heat coming from the direction of the engine room. You can hear a faint hissing coming from the walls.
                    } 
                - (engine, armory):
                    {hallucination:
                        - 3:
                           Let’s see here. I could go back to that toasty room that is the engine room, or I could go to the armory where there is probably a lot of fun to be had. That hissing is getting on my nerves.
                        - 2:
                            Guns versus heat. These two being right next to each other is probably not a good idea. Hopefully the hissing does not affect the guns in that room.
                        - 1:
                            The armory is this way, and the hot engines are back that way. Maybe I can do something about the hissing in one of those two rooms. Maybe I can just shoot the source of the hissing.
                        - else:
                            This is the hallway between the engine room and the armory. There is a strong heat coming from the direction of the engine room. You can hear a faint hissing coming from the walls.
                    }
                - (engine, quarters):
                    {hallucination:
                        - 3:
                            Do I want to return to that hot room, or do I want to go to the cool sounding sleeping quarters? Now that I think about it, I have never seen a quarter sleep. Will that hissing ever stop?
                        - 2:
                            There is the hot engine room or the sleeping quarters that I could go into. I bet that heat makes sleeping nice and toasty. As long as you can’t hear this annoying hiss.
                        - 1:
                            The engine room where it is unbelievably hot and the sleeping quarters are right next to each other. I should eventually go into one. In a hurry too if I want to keep my hearing after listening to all this hissing.
                        - else:
                            This is the hallway between the engine room and the sleeping quarters. There is a strong heat coming from the direction of the engine room. You can hear a faint hissing coming from the walls.
                    } 
            }
        - medbay:
            {hallucination:
                - 3:
                    Medbay. Hmmmmm, I wonder what that means. Maybe I’ll figure it out with my super awesome, super stealth abilities that everyone is jealous of. It looks too small to hold boats in, so med does not mean ship. It could hold two small kayaks on those things that look like beds, and there are some empty kayak sized tubes that are all frozen over.
                    There are not too many things in here other than a couple of boxes with big red plusses on them. Maybe they’re old Switzerland memorabilia? They have a couple bandages, tape, and brown bottles with a liquid in them. There are a couple weird tubes that say “cures everything” on them. Why would they need to cook things here? Wait a minute! I slightly remember something about waking up here a while ago. 
                - 2:
                     Medbay? Medbay, medbay medbay. Where have I heard that before. I think it’s for… medicine I think. I guess it could be just a room for Medieval ships for them to play with. They even have break beds. They must be really invested in that if they do it so much they need to sleep in that room. That is why I think med meaning medical has my slight favoritism. It’s strange that it has this few of beds and so many of those chambers.
                    The dirty equipment is what makes me think that it is for the medieval ships again because why would all of it be in such bad shape if it was for medicine. There are a few used medical looking packs on the ground, but maybe some people would get hurt from time to time, so they would have to tend to their playing wounds.
                    Interesting. This piece of paper has my name on it. I wonder what that means. Was I someone of importance? It says I was left in a cryotube, but for how long? I do not think I was too important if I was the only one left.
                - 1:
                    If I guess right, this should be a Medbay. It seems that the treatment of doctors on this ship is very good. Not only does it reserve space for patients, but it even arranges many beds for doctors to rest. There is not much space left in the medbay, and I don't quite understand why they do this. Is it because there are many doctors?
                    What's even more bizarre is that the ship treats the doctors so well, but doesn't seem to pay much attention to the condition of the patients. The medical equipment in the medbay seems to be the most basic, even some used medkits are not discarded but kept and placed there, it seems that no one has cleaned or organized the medical equipment recently.
                    The strangest thing happened, there was a medical record about me on my cryotube. But I'm not going to worry about that anymore because there's a door over there that says "Navigation" and hopefully that should get me out of here.
                - else:
                    The medbay I find myself in is fairly small and clearly intended to only hold one or two people at max capacity, excluding the space occupied by the now completely empty crew cryo-sleep, but it appears to have been filled to the brim with extra beds. All of which appear to have been both used and vacated in a hurry. 
                    There isn’t any overly complex equipment that can be seen, just the bare minimum required for a ship of this class. There are a couple of basic medkits, some of which have been used, and a couple empty vials of a basic cure-all medicine that is fairly standard to have on vessels going through deep space. It appears the last of which was pumped into the cryotube I most recently emerged from.
                    There is a chart stuck to the tube that might have some details about me and this situation, medically speaking at least. There is also a door that appears to lead to what is dubbed “Navigation.”
            }
        - navigation:
            {hallucination:
                - 3:
                    Woah! Check this out! There is a trippy, psychedelic map being projected. I wonder what all those symbols mean. The closer I get to everything the fuzzier it all gets. I just came from a place that looks like that space. This must be a map! I’m so smart!
                    The crew must have been brainiacs to have thought that these were the rooms of this thing we are on. I can barely make out what any of these things are. If the calculus in my head is correct, I must be somewhere in the middle of this.
                    There are four doors, so I can only be in one place. The navigation room. Man, that word is long. Nav. Navi, Navigat. Navigation room. That is a trippy word. The Medical Bay is that way. The Engines that way, Oxygen Supply that way, and OH MY GOSH! They fit a whole bridge in this place, and it is flashing red! There must be a rave going on in there.
                - 2:
                    Ooooooooooooo, this thing looks like it would be really useful to people on this ship. Whatever it is, it seems to be a fairly low quality. That looks something like what I came out of, so this is probably a map.
                    I wonder why the crew did not opt for a system with more detail. Why wouldn’t you want to see every inch of everything in real time. Maybe the ship did not have enough bandwidth to support something of that quality. Maybe it would be just too confusing for them which I also understand.
                    If there are four doors in this room, it must mean I can only be in one place. This must be navigation. Which room did I come from again? Eh, that does not matter as much anymore. I need to get some stuff done. Let’s see. Should I go to oxygen, engines, medbay, or bridge? What to do. What to do.
                - 1:
                    I think I see hope, this is... a holographic projection? It's big, really big, but it looks a little fuzzy, well, more than a little, but I can still see it. Maybe, it is a map of the ship. 
                    I suddenly wondered, would I ever be a crew member? This map has been giving me a familiar feeling, as if I had dreamed it before.I am a little sleepy now, is it because of this reason? ?
                    Then I looked forward and saw four doors. Needless to say, they must lead to four places. 80% relying on my intuition and 20% relying on the map. I can see that these doors lead to the Medical Bay, the Engines, the Oxygen Supply,  and the Bridge, at the same time my gut tells me it's better not to go to the bridge.
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
                    Ow! That hurt my ears. These tanks are quite interesting. They say O2 on them. They might have been oxygen. Look. Here is one with its LEDs still working. There are a couple more blinking lights still on it. We should probably get back to a space dock soon if I want to keep breathing. I wonder what that sound could be.
                    Over there is some grass. I wonder if they were getting prepared to plant a tree in here. That would make this place look pretty cool. Who knows. Maybe it could have had a real purpose. Maybe growing coconuts? That would be awesome.
                - 1:
                    What caught my eye were those huge O2 tanks displayed in the room, which gave me some peace of mind that at least there was so much oxygen in reserve, which should not be used up in a short period of time. Wait, this is... is it empty? No wonder I'm a little sleepy, it turns out that the oxygen is not enough, it's better not to be leaking... but my gut tells me that it seems to be the case……
                    Oops, the big guy in the room is supposed to be a large filtration system, but apparently it's broken because the noise can be easily reminiscent of a leak.
                - else:
                    {Entering the room, an all encompassing hissing greets me.|} 
                    The room is budging beyond the brim with ginormous O2 tanks and piping. Horrifyingly, these components which should be teeming with oxygen, are all near depleted. This means one of two things, this ship has been pilgrimaging for much longer than would normally be anticipated, or somewhere there is... a leak.
                    Despite the room's crowding a large filtration system is visible towards the back end of the room, which, among various other functions, is responsible for the distribution and recycling of air all across the ship. It appears to have been severly damaged. It must be the source of that hissing.
            }
        - bridge:
            {hallucination:
                - 3:
                    Oh. Well that is lame. I thought people were going to be raving in here and they somehow fit an entire bridge in this place. The place seems to have working TVs and knobs under them. It does look like they were having a party here. There are chairs and thingamabobs everywhere around the room. They must have been throwing stuff around because there are a couple cracks in TVs and dents. Amazing that they did not break the main window though. I can still see the beautiful colors of space. One TV is still on. I wonder why it is so red.
                - 2:
                    Something exciting must have happened in here. The place is a mess. Did they have a party or worse; was it something awful? That would be very unfortunate. There are things just about everywhere. There are cups on the ground, chairs on their sides, and tvs that probably let them watch sports completely shattered. I bet this probably makes for a very interesting story. That is, if anyone survived. Hopefully they all did, and it was actually something fun.
                - 1:
                    Could it be that my intuition is wrong? The bridge doesn't seem as bad and scary as I imagined, but all kinds of items are not placed where they should be, but floating in the air, which makes me feel a little weird , the main terminal has not been damaged and can be used normally, but for some reason, I still think this is not good, is it because of the red light emitted by the main terminal?
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
                    Why is this room so hot? Someone needs to turn on the ac. I hate when captains are not willing to stretch for the extra good air conditioners. Then again, this could be for a reason.
                    That must be the biggest thing on this ship. It would probably make this the ship’s engine. So many tubes all in one place. Could it be anything else? Maybe this was also the mechanical repairment place. There is a place for things that might have been tools. They could have also been weird shaped hard light swords.
                    Hmmm, those things seem a little too loose. I wonder if I could fix them with what I have on me. That would make me pretty cool if I could, but messing it up more would make me very not cool. Risk versus reward.
                - 1:
                    My god, it's too hot, I feel like I'm going to faint, is there really any air left in this room?
                    I think it's either an engine or a heater, but I think it's the former because it's connected to the ship's main thrusters through a lot of pipes. But I'm sure any normal person can tell that this thing should be broken because it's missing too many parts.
                    Ahhhhhh...some liquid is leaking from the valve, although it looks dangerous, because the leaked liquid is very hot at first sight, but I believe I can solve it……maybe……
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
                    So many guns in one place? This could be an armory. Why would they need this many weapons? Were they defending themselves from an alien species, or were they going to start a mutiny. This place gets more interesting by the minute.
                    It looks like everyone had their own weapons and armor, and they were all in their own lockers. Well, I should say most of them. One of them looks to have been placed on the ground. Why would you just place one locker on the ground randomly? The people who worked here were weird. How many friends did I have that were on here, and what happened to them?
                - 1:
                    Finally got to see something refreshing, an armory! I think with this, my precarious life finally has a little security, at least in this vast galaxy full of all kinds of alien creatures, I may be able to fight against them for a bit of time…
                    I seem to be happy a little too early. The weapons in these lockers are very ordinary, and I can't get them out at all. These lockers are all locked, and those that are not locked can't help at all. And the chairs are all used as cover, it seems like I missed a good fight.
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
                    Beds, beds, beds. This looks like a fun place to sleep. Maybe I should go to sleep. That sounds pretty nice right about now. I guess I will keep working. Ugh. One of these chests must have been mine. I hope I had some magazines of cool cars or something in it. Most of them seem to be open and empty. That would definitely explain why no one is here. Some people were messy though and left behind some gross food.
                    What is that red stuff over there? That does not look so good. Maybe someone slipped. Eew. It is blood. I guarantee that someone slipped on some of this for on the ground or something. Hopefully it was not that bad and was healed.
                - 1:
                    The sleeping quarter is really really big. I said before that the ship's treatment of the crew was not good. I apologize for that. But in such a huge sleeping quarter, there is no one here, not even personal belongings left. They were all taken away, but some food from a few days ago, but it's better not to eat it I think.
                    Ok, I’m out of this. Please, someone get me out of here! The red on this table must be blood! There's so much blood on this, I think the owner of this blood must be dead, please, I don't want to be the next.
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

== mechanos_end ==
    The book that another might have looked at as nothing but the scribbles of a lunatic has revealed its true form to you. The teachings of Mechanos the Mechanical God will lead you upon the path of enlightenment. Death is not the end, but rather the path to salvation. 
    You will join the great machine.
- -> game_over

== ate_it_end ==
    These tasty snacks you found sure taste of metal, but they satisfy your cravings... at first... now your stomach is hurting, and it keeps getting worst. It must be coincidental, what a time to get sick!
- -> game_over

== outside_end ==
    This was a great idea! Although, the sudden cold sucks the last remenants of your oxygen out of you, and you immediately explode from the change in pressure.
- -> game_over

== greedy_dismantler_end ==
    Screws and Bolts, all are for you to claim. The hallway is upset by this, and immediately begins to creak and fall to pieces. Your greed has been your downfall.
- -> game_over

== game_over ==
    You have met your end.
- -> END

== you_did_it_end ==
    Repairing the engine, you notice that the repetitive oxygen warning has ceased. It would seem that you have found and fixed the issue... or at least the most imminent one.
- -> END
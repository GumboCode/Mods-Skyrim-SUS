# Simple Unlock Spell

<img src="https://staticdelivery.nexusmods.com/mods/1704/images/151386/151386-1748586076-1610554653.jpeg" width="600">

Mod Page: https://www.nexusmods.com/skyrimspecialedition/mods/151386

This mod has no dependencies.

## About

This mod adds a spell to the game that lets you unlock doors and chests from a distance, as long as it doesn’t require a key. It's extremely light weight, only runs scripts each time it's cast, and uninstalling it is easy. It’s very close to Oblivion’s unlock spells, but with some additional quality of life features. Just like in Oblivion, using it in front of guards won't get you into trouble. The spell was designed with game balance in mind, if you don’t like my default settings, I have given you 3 global variables so you can tweak it to your satisfaction.

You can obtain the spell by buying it from Belethor's General Goods, Bits and Pieces, Gray Pine Goods, Riverwood Trader, and The Pawned Prawn.

There is only one Unlock spell to learn, and it doesn’t matter what your alteration skill is, you can always bruteforce any lock open with enough magicka. The better you are at alteration, the less magicka it will take to unlock things. Practice with the spell, and you will be awarded XP in the alteration school for it, tougher locks yield higher XP. If you get the perks that cut your alteration spell costs by half, it will apply to locks matching that level. Perhaps you consider yourself crafty, in that case, you can use enchantments to bring down your alteration spell cost and use potions to increase your magicka. The point here is that the spell still works similarly to a vanilla one, while being packed into one spell.

## Features

- Cast a spell that will open any lock that doesn’t require a key.
<img src="https://staticdelivery.nexusmods.com/mods/1704/images/151386/151386-1748586095-2140083066.jpeg" width="600">
<img src="https://staticdelivery.nexusmods.com/mods/1704/images/151386/151386-1748586104-1753488042.jpeg" width="600">
<img src="https://staticdelivery.nexusmods.com/mods/1704/images/151386/151386-1748586118-922485343.jpeg" width="600">
<img src="https://staticdelivery.nexusmods.com/mods/1704/images/151386/151386-1748586127-12901927.jpeg" width="600">

- It will work at any skill level, provided you have enough magicka.
- You won’t get in trouble for unlocking things with the spell.
- You can use the game mechanics to reduce the cost of opening locks.
- Configure the spell through 3 different global variables.

<ins>Details:</ins>

- The default base magicka costs for each lock level goes 80, 160, 240, 320, 400. You can adjust the maximum cost with the GM_SUS_Unlock_Magicka_Glob1 global variable, and the value will be divided for all 5 levels.
> Magicka = Global / 5, Novice = Magicka, Apprentice = Magicka x 2, Adept = Magicka x 3, … etc.

- The default skill increases for successfully opening each lock level goes 20, 40, 60, 80, 100. You can adjust the maximum skill advancement with the GM_SUS_Unlock_Skill_Glob1 global variable, and the value will be divided for all 5 levels.
> Skill = Global / 5, Novice = Skill, Apprentice = Skill x 2, Adept = Skill x 3, … etc.

- The formula used to calculate magicka cost is:
> Base Cost x ( 1 - ( Alteration Mod / 100 ) ) x ( 1 - ( Alteration Skill / 400 )^0.65 )

- If you have an alteration perk that halves the spell cost, and you cast it on a lock that matches that perk's level, it halves the result:
> Magicka Cost / 2

- You can adjust the spell’s lock detection radius with the GM_SUS_Unlock_Radius_Glob1 global variable, the default value is 150.

Alteration Mod is the total value of all your Alteration spell cost reducing enchantments, and once that hits 100, the magicka cost is simply 0.

Some doors may be a little awkward to unlock, especially the jail doors in Riften. You can hit the door in different corners, or adjust the radius global to increase the spell’s detection radius.

<ins>Current limitations:</ins>

- You cannot open locks that require a key because it can break things, especially quests.

## Installation

<ins>Manually install the files:</ins>

1. Download the latest version: https://www.nexusmods.com/skyrimspecialedition/mods/151386?tab=files
2. Extract the contents of the .zip file into Skyrim's Data directory. "Skyrim Special Edition\Data\"

The Skyrim Special Edition folder location depends on what platform you installed it from. For Steam its in the "Steam\steamapps\common\" folder.

<ins>Make sure it's working:</ins>

1. Boot up the game.
2. You may need to go to Creations and Load Order to enable the mod.
3. While in the game, buy the spell tome from one of 5 merchants, and learn the Unlock spell.
4. Create a save after purchasing the spell, do not cast it before you save.
5. Cast the spell on something that is locked.
6. You should see the object glow, or a notification appear at the top of the screen. If not, close the game and load back into the save you made before casting the spell.

<ins>To uninstall:</ins>

- Remove the files you had previously installed.

## Notes

Feel free to post any questions about the mod here: https://www.nexusmods.com/skyrimspecialedition/mods/151386?tab=posts

I don’t know if or when I will answer them, but I will certainly attempt to at least sporadically respond to them as any responsible mod author would do.

If you find any bugs, please report them to me if you care to. You can do that right here: https://www.nexusmods.com/skyrimspecialedition/mods/151386?tab=bugs
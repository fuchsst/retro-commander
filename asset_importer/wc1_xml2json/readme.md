# Wing Commander Converter Usage Guide

## Overview
The `convert.py` script is designed to convert XML files exported from the Wing Commander game using [Wing Commander Toolbox](https://www.wcnews.com/chatzone/threads/wing-commander-toolbox.27769/) into JSON format and the gif images to png. It also scales images based on a provided scale factor.

## Prerequisites
- Python 3.x installed
- The `fire` library installed (install with `pip install fire`)

## Running the Script

1. Open your command-line interface (CLI).
2. Navigate to the directory containing the `convert.py` script.
3. Run the script using the following command:

```bash
python convert.py --wct_output_path=<path_to_xml_files> --converted_json_output_path=<path_to_output_json_files> --image_scale_factor=<scale_factor>
```

Replace `<path_to_xml_files>` with the path to the directory containing the XML files, 
`<path_to_output_json_files>` with the path where you want the JSON files to be saved, and 
`<scale_factor>` with the desired image scale factor (default is 4).

Example:

```bash
python convert.py --wct_output_path="D:\Godot\projects\wing-commander-converter\wc1_xml2json\GAMEDAT" --converted_json_output_path="D:\Output\JsonFiles" --image_scale_factor=2
```

his will process the XML files located in `D:\Godot\projects\wing-commander-converter\wc1_xml2json\GAMEDAT`, 
convert them to JSON, save them in `D:\Output\JsonFiles`, 
and scale images by a factor of `2`.



# Notes

## Briefings

Even entries are data selecting faces, font colors, and backgrounds.  These entries are divided into thirteen-byte chunks, one chunk per screen, with an extra chunk to denote the end of the cutscene.

#### Dialog Settings

#### Briefing Room Foregrounds

0: Briefing crowd moving
1: Briefing crowd still
2: Halcyon midrange at podium
3: Halcyon pointing to the nav map
4: Nav map closeup
5: Briefing crowd standing up
6: Empty room
7: Mid-range nav map
8: Empty room
9: Half wall
10: Camera pans right across backs of pilots
11: Camera holds on backs of pilots
12-15: Various starfield debris shots
16: Camera holds?
17: DIVIDE ERROR, GAME CRASHES!
18: Blank
19: Blank
20: Halcyon
21: Spirit
22: Hunter
23: Bossman/Jazz
24: Iceman
25: Angel
26: Paladin/Doomsday
27: Maniac
28: Knight
29: Bluehair
30: Shotglass
254 (-2): end conversation
255 (-1): nobody
MAY BE MORE FOR HALCYON OFFICE, FUNERAL, AND MEDAL SCENES

#### Medal Ceremony Foregrounds

6: Crowd with Halcyon talking to Blair (BRIEFING.VGA-ImageBlock008-ImageItem000)
12: BRIEFING.VGA-ImageBlock010-ImageItem001
13: BRIEFING.VGA-ImageBlock010-ImageItem000

#### Halycons Office Foregrounds

#### Text colors
0: Light blue
1: Lavendar (Spirit)
2: Royal Blue (Hunter)
3: Red (Bossman/Jazz)
4: Cyan (Iceman)
5: Peach (Angel)
6: Blue (Paladin/Doomsday)
7: Electric Green (Maniac)
8: Brown (Knight)
9: Yellow (Bluehair)
10: Pea Green (Shotglass)
11: medium light gray
12: medium gray
13: very light gray
14: very dark gray
15: medium dark gray
16: medium light gray
17: medium light gray
18: black
various grays from here on?

#### Backgrounds
-2: blue empty background
0: briefing room wall
1: briefing room crowd
2: shotglass window
3: left bar seat
4: right bar seat
5: funeral
6: farewell (space with debris background)
7: halcyon office door
8: halcyon office window
9: halcyon office room (desk)
10: halcyon background during debriefing
11: pilot background during debriefing (hangar door)
12:
13:
255: nothing
MAY BE MORE FOR HALCYON OFFICE, FUNERAL, AND MEDAL SCENES


### Conversation Block 0: Funeral scenes

0: End of player funeral.  "Farewell, $C. You'll be missed."
1: Start of player funeral, early game.
2: Start of player funeral, middle game.
3: Start of player funeral, winning late game.
4: Start of player funeral, losing late game.
5: Blair saying goodbye to another pilot, branching based on who died.
6: Start of pilot funeral, branching based on who died.

### Conversation Block 1: Colonel Halcyon's office

TODO

### Conversation Block 2: Medal Ceremony

TODO

### Blocks 3+: Mission Blocks

Each mission has 10 entries in its secondary table, corresponding to the conversations available for that mission.

0: briefing
1: debriefing
2: shotglass
3: bar seat right
4: bar seat left






Odd entries are the scripts for the scenes.  Each script is divided into chunks separated by \0's.  Each group of four chunks is associated with a single screen of the cutscene.

The first chunk is a script defining a branch under certain circumstances, whether a character is dead, whether a mission was accomplished, etc.  Unusual combination of ASCII and not.  A branch comes in two basic formats, depending on whether the branch requires arguments or not.

The first byte is always the branch condition.  If the condition does not accept arguments, this is followed by the destination frame of the conversation, IN ASCII.  49 would be screen 1, 49 48 would be 10.  If there is an argument, these arguments are also in ASCII, and are followed by a 44 (','), which is then followed by the destination frame.  More commands can be appended if multiple conditionals are to be ORed, by placing 44's between each conditional.

CONDITIONS (these are all the conditions used in the original briefings, there may be others the system will respond to):
1: Unconditional, always branch
2(X): Branch if mission didn't go well?  Damage above a certain threshhold?
3(X): Branch if mission went well?  Damage below a certain threshhold?
4(X): Branch if pilot X is dead
5(X): Branch if pilot X is alive
6: Branch if player kills last mission == 0
7: Branch if player kills last mission > 0
8(X): Branch if pilot X kills last mission == 0
9(X): Branch if pilot X kills last mission > 0
10: Branch if no meeting with Halcyon after debriefing
11(X): Branch if objective X failed
12(X): Branch if objective X succeeded
13: Branch if receiving Pewter Planet
14: Branch if receiving Bronze/Silver/Gold Star
15: Branch if receiving Golden Sun
16: Branch if not promoted
17: Branch if didn't eject this mission
18: Branch if first ejection (Golden Sun)
19: Branch if not transferring squadrons
20: Branch if not transferring to Hornet
21: Branch if not transferring to Scimitar
22: Branch if not transferring to Raptor
23: Branch if not transferring to Rapier
24: Branch if transfer to worse ship
25: Branch if transfer to better ship
26: Branch if not first ejection
27(X): Branch if objective X sighted
28(X): Branch if objective X not sighted
29(X): Branch if pilot X did not die this mission
30(X): Branch if pilot X died this mission
31(X): Branch if Kilrathi ace dead
32(X): Branch if Kilrathi ace survived previous mission
33(X): Branch if Kilrathi ace alive
34(X): Branch if Kilrathi ace died in previous mission
35: Branch if mission went poorly (quantifiable?)
36: Branch if mission went well (quantifiable?)

PILOTS:
48(0): Spirit
49(1): Hunter
50(2): Bossman/Jazz
51(3): Iceman
52(4): Angel
53(5): Paladin/Doomsday
54(6): Maniac
55(7): Knight

ACES:
48(0): Bhurak Starkiller
49(1): Dakhath Deathstroke
50(2): Khajja the Fang
51(3): Baron Bakhtosh Redclaw

The second block is the text displayed on the screen.  Some variables can be inserted here.

Variables:
$A: MEDAL TO BE AWARDED
$C: CALLSIGN
$D: DATE
$E: PREVIOUS DATE (FOR MEDAL CEREMONY)
$K: KILLS LAST MISSION
$L: WINGMAN KILLS LAST MISSION
$N: NAME
$P: NAME (NEVER USED)
$R: RANK
$S: SYSTEM
$T: TIME OF NEXT MISSION

The third block is a phonetic version of the text, in ASCII, used to make the mouth move correctly.  Might be useful for a speech pack?  Pauses can be inserted.  $X where X is some number is a pause before or after speech.  A number otherwise is interpreted as a pause DURING speech.

Fourth block is an ASCII script controlling the expressions of the talking head.  Note that at times there is no talking head, this script is zero!  First byte is usually 82 ('R').  If it's not, the first command seems to be skipped.  After that, the block is divided into commands by 44 (',').  Block must always end with a ',' as well.  Each command consists of an expression and a length.

Facial expressions
0 CLOSED
1 LEFT
2 RIGHT
3 UP
4 DOWN
5 AFRAID?  Eyebrows up
6 ANGRY
7 PERPLEXED, one eyebrow up
8 HAPPY
Anything else seems to be default face

Left to do:
Bytes 3/4 for each screen are unknown
Code fails in reading SM1 series 6 mission 1 debriefing screen 10; DOES NOT fit format; error in file?
Some branching conditions aren't fully quantified

## Animations

### DialogItem Commands

Eye positions:
1: 
2: 
3: 
4: 
5: 
6: 
7: 
8: 
9: 
10: 

Mouth positions:
11: open
12: 
13: 
14: 
15: 
16: 
17: 
18: 
19: 
20: 


Example:
`<DialogItem Commands="" FacialExpressions="RA45,81,01,A35,81,01,A50,81,02," LipSyncText="baleapfradadtakalodaf2$99" Text="Belly on up, friend, and take a load off." />`
Results in the following eyes/mouth combinations (their respective image index; -1 if empty)
frame: eyes/mouth
1: -1 / 1
2: -1 / 5
3: -1 / 5
4: -1 / 1
5: -1 / 1
6: -1 / 1
7: -1 / 5
8: -1 / 5
9: -1 / 5
10: -1 / 5
11: -1 / 1
12: -1 / 5
13: -1 / 5
14: -1 / 1
15: -1 / 1
16: -1 / 1
17: -1 / 1
18: -1 / 1
19: -1 / 3
20: -1 / 3
21: -1 / 3
22: -1 / 3
23: -1 / 5
24: -1 / 1
25: -1 / 1
26: -1 / 1
27: -1 / 1
28: -1 / 9
29: -1 / 9
30: -1 / 9
31: -1 / 10

`<DialogItem Commands="" FacialExpressions="R81,01,A35,81,01,A40," LipSyncText="olsatglasastegituask$99" Text="...old Shotglass is the guy to ask!" />`
frame: eyes/mouth
1: -1 / 1
2: -1 / 1
3: -1 / 1
4: 11 / 5
5: 11 / 5
6: -1 / 1
7: -1 / 1
8: -1 / 5
9: -1 / 5
10: -1 / 5
11: -1 / 5
12: -1 / 1
13: -1 / 1
14: -1 / 1
15: -1 / 1
16: -1 / 8
17: -1 / 5
18: -1 / 5
19: -1 / 5
20: -1 / 1
21: -1 / 1
22: -1 / 5
23: -1 / 5
24: -1 / 5
25: -1 / 5
26: -1 / 2
27: -1 / 2
28: -1 / 2
29: -1 / 5
30: -1 / 5
31: -1 / 1
32: -1 / 1
33: -1 / 1
34: -1 / 5
35: -1 / 5
36: -1 / 5
37: -1 / 4
38: -1 / 4
39: -1 / 4
40: -1 / 5
41: -1 / 5
42: -1 / 1
43: -1 / 1
44: -1 / 1
45: -1 / 5
46: -1 / 5
47: -1 / 5
48: -1 / 5
49: -1 / 10




In the `DialogItem` elements, the `Commands` attribute seems to control the animation sequence associated with each dialog item. For instance, `[36]:7;` would mean that the animation group `36` is used, and the animation plays at frame `7`.

The `DialogSettingItem` elements seem to control the overall settings for the dialog, such as the background, delay, foreground, and text color. The `Background`, `Foreground`, and `TextColor` attributes likely refer to color codes or identifiers, while the `Delay` attribute probably controls the timing or speed of the dialog or animation.

The `FacialExpressions` attribute in the `DialogItem` elements appears to control the facial expressions of the characters during the dialog. The format of this attribute is a sequence of codes separated by commas, which likely correspond to different facial expressions.

The `LipSyncText` attribute in the `DialogItem` elements seems to be a phonetic representation of the dialog text, which could be used for lip-syncing the characters' speech in the animation.

In conclusion, the `Commands` attribute controls the animation sequence, the `DialogSettingItem` elements control the overall settings, the `FacialExpressions` attribute controls the facial expressions, and the `LipSyncText` attribute is used for lip-syncing.


## Ships

### Classes

* ShipClass 12: Light Fighter
* ShipClass 13: Corvette

* ShipClass 0: Likely a placeholder or undefined class.
* ShipClass 5: Given its non-combat properties, it could be a Shuttle or Transport.
* ShipClass 6: Similar to class 5, possibly another type of Shuttle or Transport.
* ShipClass 7: Minimal properties suggest a Drone or Probe.
* ShipClass 8: With weapons and shields, it could be a Fighter, but not as advanced as the Light Fighter (class 12).
* ShipClass 9: Similar to class 7, potentially another Drone or Probe.
* ShipClass 10: Non-combat properties might indicate a Support Ship or Utility Craft.
* ShipClass 11: With weapons and shields, this could be a Scout or another type of light combat ship.

### Weapons

* WeaponType 24: MK. 25 Laser Cannon
* WeaponType 25: MK. 40F Neutron Guns
* WeaponType 26: Mk. 30A Gatling Mass Driver Cannons
* WeaponType 27: MK. 25 Laser Cannons (possibly a different variant or used in a different context than WeaponType 24)
* WeaponType 28: Dart DumbFire Missile
* WeaponType 29: Javelin Heatseeker Missile
* WeaponType 30: Pilum FFs Missile
* WeaponType 31: Spiculum IR Missile
* WeaponType 33: Porcupine Mine

### Combat

To reach a Nav point you’ll need to be within 1,000 clicks of it. The next Nav point will automatically be selected.


### Missions

Wing Commander has 13 series, for a total of 40 missions. 
There’s a "winning" branch, a "losing" branch, and a lot of "in-between" branches. 
The losing branch missions are a bit harder as you fly inferior crafts and face slightly more enemies.

Each series can be won or lost except the final two.
Series missions have "victory points", which are counted toward the series.
If you accumulate more victory points than the minimum required for the series, you win the series and continue on the winning path.
Otherwise, you lose the series and follow the losing branch to another series. 
You can lose some missions in the series and still win the series as long as you have the required victory points to win the series.
The after-action briefing you get with Colonel Halcyon will be different depending on you win or lose the mission, but that in itself does not dictate the series win or loss.

Winning medals and promotions depends on amount of "medal points" you accumulate. 
Killing Kilrathi ships wins medal points, so does saving Confed ships. 
Losing Confed ships loses medal points.
These points have nothing do with the victory points listed above. 
When you accumulate certain number of medal points, you gain one rank. 
Certain missions have a possibility of winning a medal. 
If you accumulate enough "medal points" in that mission you win that medal. 
I don’t have an exact chart for this, but you can guess that killing capships would win a lot more points than killing puny fighters.

Your rank and medals has no effect on the game. They are there only as "rewards" for your performance.

Each mission is then broken down into "action zones", which are either on the nav points, or between nav points.
As there are a maximum of four nav points in a WC mission, N12, N23, and N34 will be used to denote the "in between" action zone encounters between nav 1 and nav 2, nav 2 and nav 3, or nav 3 and nav 4 respectively. 
Tiger’s Claw or start is considered nav 0 for this purpose.


#### Mission Tree

Key: Series name (number of missions), Win goes to, Lose goes to

* Enyo (2 missions)  W = McAuliffe  L = Gateway
* McAuliffe (3 missions) W = Gimle  L = Brimstone
* Gateway (3 missions) W = Brimstone  L= Cheng Du
* Gimle (3 missions) W = Dakota  L = Brimstone
* Brimstone (3 missions) W = Dakota  L = Port Hedland
* Cheng Du (3 missions) W = Brimstone  L = Port Hedland
* Dakota (3 missions) W = Kurasawa  L = Rostov
* Port Hedland (3 missions)  W = Rostov  L = Hubble’s Star
* Kurasawa (3 missions)  W = Venice   L= Rostov
* Rostov (3 missions)  W = Venice   L = Hell’s Kitchen
* Hubble’s Star (3 missions)   W = Rostov   L = Hell’s Kitchen
* Venice (4 missions) You win
* Hell’s Kitchen (4 missions) You lose

If you draw this on paper, you’ll see that there are a LOT of second chances. Unless you end up in Hell’s Kitchen, you can always fight yourself back onto the winning track and get to Venice, where you win the Vega sector.
If you want the quickest way to win WC, you can eject in all Enyo, all Gateway, all Cheng-Du, and all Port Hedland. 
Play Hubble’s Star 1 and Hubble’s Star 3 perfectly, eject from Rostov 1, win Rostov 2 and Rostov 3, then eject from all Venice missions. You only need to play four missions.

If you want maximum number of kills, then you need to lose Gimle and Kurasawa (almost everybody loses Kurasawa any way) to play Brimstone and Rostov for two extra series.

Note about the mission listing: The series is listed with name of the system, and the points needed to win next to points available. 
For example, Enyo Series (11/15) means there are 15 victory points in this series, and you need 11 to win this series and end up in Gateway. If you don’t, you go to McAuliffe.


#### Enyo Series (11/15)

In Enyo, you pilot the Hornet along with Spirit. She listens to your orders (just humoring you, really. After all, you’re the rookie just out of the Academy!) and she’s not too bad in the cockpit either. The missions are easy. If you can’t handle this, you’re not fit to sit in the cockpit.


6.2.1     Enyo 1 (6/6)

Patrol Nav 1 (2), Nav 2 (1), Nav 3 (2), Land (1). No medals possible.
Simple patrol. N01 has 3 Dralthi. Asteroids at N2. 2 Salthi at N23. Some asteroids at N30.
You can bypass most of the asteroids at nav 2 by going N1, N3, N2, then N0.


6.2.2     Enyo 2 (5/9)

Escort nav 1 (2), nav 2 (2), Drayman escorted out (5), Bronze Star for 52 medal points.

Your first escort mission have your wing escorting Drayman out to the jump point. N01 has 2 Salthi, and N12 has 3 Dralthi.
There are a few asteroids at Nav 2. Wait until the Drayman jumps out before returning to the Claw.


#### McAuliffe Series (32/37)

McAuliffe is on the winning track, and you’ll be flying with Paladin. 
After the light armament of the Hornet, you’d think Scimitar is armed heavily... But it handles like a pig. 
Things are still easy, as you’ll get your first chance to fight enemy aces and conduct cap ship strikes here. You’ll also get your first taste of a minefield.


6.3.1     McAuliffe 1 (8/10)

Patrol N1 (2), N2 (2), N3 (2), N4 (2), land (2). No medal possible.

Simple patrol again. There are 3 Dralthi at N01, mine field at N32, and 3 Salthis at N34. With mass drivers, you outgun all of the enemy crafts.
With Scimitar you can actually play "chicken" with a Dralthi. Just keep firing when you’re in range, and you should kill it before you two collide head-on.


6.3.2     McAuliffe 2 (11/12)

Cap ship strike, N1 (1), destroy Ralari (10), land (1). Bronze Star for 65 medal points.
Your first strike mission has 4 Dralthi at N01, and the Ralari with 2 escorting Krants at N1. Just take out the escorts, then park yourself behind the Ralari and fire away.


6.3.3     McAuliffe 3 (16/17)

Escort. N1 (1), Escort Drayman (10), kill Bhurak (5), land (1).
Silver Star for 86 medal points.

Escort freighter, N01 has 4 Krants, while 3 Salthis (including Bhurak Starkiller) attack you at N10 after you come back with the Drayman.

Your first serious escort mission requires you to go out, meet a freighter, and escort it back to the Claw. The 4 Krants on the way are pretty tough, though they don’t have much firepower. 
The Salthis on the way back really move around, and Bhurak will try to draw you away from the freighter so the other two Salthis can kill it. Taunt the other two Salthis to attack you (and thus ignoring the freighter), then take out the Salthis.


#### Gateway Series (35/44)

Gateway is the first series on the losing track, though there’s plenty of time to fight your way back. Unfortunately, you fly the Hornet, which are way too weak to be an effective escort.


6.4.1     Gateway 1 (6/8)

Patrol, N1 (2), N2 (2), N3 (2), Land (2), no medal possible.
Asteroids at N01, N1 is clear. N12 has 4 Salthis. N23 has 2 Grathas. N3 is clear, N30 is clear. Your first encounter with Gratha is not a pleasant one. They are so heavy that it’ll take a LOT of shots to kill them. Don’t get too close or their mass drivers will chew you up.


6.4.2     Gateway 2 (20/20)

Scramble, keep Tiger’s Claw alive (20), Silver Star for 50 medal points.
Your first scramble mission features a LOT of enemies attacking your home base. 3 wings of 2 Dralthis attack the Claw. Kill them all, and you win this mission. If you kill five out of six, you get the medal too.


6.4.3     Gateway 3 (15/16)

Escort mission. Escort Drayman (15), kill Bhurak (1), Silver Star for 62 medal points.

There are 5 Krants at N01, and 3 Salthis (including Bhurak Starkiller) at N10. 
Taking out the Krants with a Hornet requires a lot of patience. Use your HS here as you won’t get a chance to use them on the Salthis. Keep the DFs for the Salthis. 
Again, escorting the Drayman is the primary objective, and those Salthis will go after the Drayman unless you divert them by shooting them or taunting them.


#### Gimle Series (25/35)

You fly the Gimle series with Angel in a Raptor, probably the best fighter in the game, and you get to try out the new Rapier as well. 
You are definitely on the winning track. It is possible to lose the Exeter in Gimle 1 and still win the series, but you can’t afford to lose any more points other than those 10.


6.5.1     Gimle 1 (12/12)

Defend mission. Defend Exeter (10), land (2). Gold Star possible for 83 medal points.

You launch and immediately run into 2+2 Salthis (2 waves of 2).
Don’t use up all your missiles against them. Use full guns and wipe them out. 
One solid hit will cripple it. Your first encounter with the three Jalthi is not a happy one. 
The three of them can take out the Exeter quickly unless you even the odds ASAP. Blow one up with missiles and full guns. 
Then send Angel to keep one busy while you take out the other one. 
Your shields can take ONE salvo of those six guns, but only one. If you have to, ram one of the Jalthis.


6.5.2     Gimle 2 (9/10)

Patrol mission. You get to try the new Rapier. N1 (1), N2 (3), N3 (3), kill Gratha(s) (3).

Launch, area is clean. N1 has asteroids but otherwise unoccupied.
Rapier’s high speed may make navigating the asteroids difficult, so slow down!
N12 has 4 Dralthis. N2 is clear. N23 is blocked by 2 Grathas, which are pretty hard to kill.


6.5.3     Gimle 3 (9/13)

Patrol mission, each Dralthi is 1 point except the last one, while Dakhath is 5 points. 80 medal points for a Bronze Star.
Launch is clear. When you hit N1, you find 5 Dralthis. When you kill them all, Dakhath (Dralthi Ace) and 3 more Dralthis show up.
After that, go home.
If you can’t handle these Dralthis in a Raptor, you really shouldn’t be flying.


#### Brimstone (28/28)

You get here by losing McAuliffe, or winning Gateway.
Unfortunately, you’re flying Scimitar with Maniac, who almost never follows orders. If you can keep him alive, you are good.
You must complete EVERY goal of every mission, or you lose the series.


6.6.1     Brimstone 1 (8/8)

Patrol mission. N1 (2), N2 (2), N3 (2), Land (2). No medal possible.

Launch is clear. N01 has a Salthi. When you take it out, 3 Grathas jump in. 
2 Krants block N12. 
Asteroids are at Nav 2. 
Nav 3 is clear.


6.6.2     Brimstone 2 (10/10)

Escort mission. Exeter escorted to the Claw (10)

Asteroids with 4 Salthis are at N01. 
While you may want to bypass them, that’s actually a bad idea, since they will show up at N2 later if you don’t destroy them. 
Instead, take your time and wipe them out. Then head on out to N1 and take out those 4 attacking Dralthis.
Then go home via N2 and you’re done.


6.6.3     Brimstone 3 (10/10)

Strike mission. Must destroy Dorkir (10).

On the way to N1, 2 Jalthis block your way. 
At N1, 4 Krants are escorting the Dorkir. When you kill them, 2 more Krants show up.
Take them all out and go home.


#### Cheng-Du Series (26/26)

While Cheng-Du is on the losing track, it’s in the mid-way losing.
To win the game really fast, you should consider losing this series.
If you do so, you just need to win at Port Hedland, Rostov, and you’re at Venice.
If you win, you end up at Brimstone, Dakota, Kurasawa, then Venice, one more series and 3 more missions to fly.

You fly with Angel in Cheng-Du. The problem is you’ll be flying Hornets, which are just too light to do serious work.


6.7.1     Cheng-Du 1 (6/6)

Escort / Strike mission. Escort Valkyrie (5), land (1)

Valkyrie is in a Hornet at N1, under attack by 4 Krants. 
If you take out the 4 Krants, the Ralari Valkyrie saw may show up with 2 Krant escorts. 
If so, destroy it (then the victory point becomes 16, with the Ralari worth 10 pts). Otherwise, go home.

In WC, the Ralari may or may not show up. If you use the SM2.EXE to run this mission, then the Ralari always show up. 
Guess there’s a bug in the mission script. (see 9.3 on the SM2.EXE alternate way to run WC).


6.7.2     Cheng-Du 2 (10)

Escort mission. Safely escort Exeter (10).

Who the heck decided to run a destroyer through asteroid fields?
There are THREE asteroid fields between N01. 
You must escort the Exeter to N1, and keep the Dralthis (one of them piloted by Dakhath) off the Exeter until it jumps. 
After you take care of them, 5 Salthis will jump you at N10 (on the way back).


6.7.3     Cheng-Du 3 (10)

Defend mission. Successfully defend the Claw (10). Silver Star for 75 medal points.

Upon launch, 2+2+2 Grathas attack the Claw. Take them all out, enough said.


#### Dakota Series (50/67)

Dakota series is on the winning track. While Raptor is good, Knight is below average. At least the missions are challenging.


6.8.1     Dakota 1 (17/17)

Escort mission. Escort Drayman out (5), Escort Drayman in (10),
land (2). Silver Star for 150 mp.

Launch, rendevous with Drayman. At N01 5 Salthis (4 Jalthis?) attacked. 3 Krants waited at N1. Freighter jumped. Upon arriving at N2 3 Jalthis (4?) attack Drayman.

This mission is hard, with two escort segments. Both require good shepherding and quick kills.


6.8.2     Dakota 2 (17/23)

Patrol / Strike mission. N1 (2), N2 (2), N3 (2), land (2), destroy Ralari (15). 
Silver Star for 105 mp.

Launch is clear. Asteroid field and 2 Grathas are at N1.
Dogfighting in asteroid field can be quite tense. Ralari with 6 Krants are sitting at N2. N3 just have a few more asteroids.


6.8.3     Dakota 3 (17/27)

Strike mission, Dorkir (5), Dorkir (2 x 10), land (2). 
Gold Star for 135 mp.

First Dorkir is at N1 escorted by 6 Krants. Toast them. 
At Nav 2, you find instead of 1 Dorkir that Colonel Halcyon said to expected, you see two Dorkirs! 2 Jalthi escorts each Dorkir. 
And Bakhtosh Redclaw is there in a Jalthi... So take them all out.


#### Port Hedland Series (X/X)

As you must complete each and every goal in this series, there’s no point in listing the individual victory points...
This series features the Scimitar... Not good. You’re flying with Knight, which is almost as bad. Be careful out there.


6.9.1     Port Hedland 1 (X/X)

Escort the Drayman back to the Claw. Bronze star for 130 mp.
4 Jalthis jump you at N01, and 3 Grathas jump you at N10.


6.9.2     Port Hedland 2 (X/X)

Patrol / Strike mission. Hit all nav points, and take out the Fralthi. Silver star for 130 mp
3 Dralthi await you at N1. N2 just have some mines. Fralthi and 3 Grathas are at N3, while some asteroids are at N4.


6.9.3     Port Hedland 3 (X/X)

Defend / Defend / Strike. Gold Star for 165 mp.

Upon launch, 4 Jalthis are attacking the Claw. Once clear, head for N1, where 4 Grathas are attacking the Exeter. 
Once that’s clear, head for N2, where 4 Krants are escorting the Fralthi.
Take them all out and go home.


#### Kurasawa Series (40/50)

This is known as the impossible series. You finally get to play with the Rapier, and Bossman flies quite well. 
Despite that advantage, mission 2 is just about impossible, so we’ll see you at Rostov...


6.10.1    Kurasawa 1 (20/20)

Strike mission. Take out Dorkir (10), Dorkir (5), and Dorkir (5).
No medals.

You find 5 Dralthi and a Dorkir at N1A. N2 has a Dorkir escorted by 4 Krants. 
At N1B 2 Jalthis are waiting for the Dorkir to jump in. 
Take care of them, then the Dorkir when it jumps in.


6.10.2    Kurasawa 2 (15/15)

Escort mission, escort the captured Ralari back to the Claw (15).
98 pm for Silver Star. (hah!)

This is the impossible mission. There’s an asteroid field between you and N1. 
Inside are 4 Salthis, so take them out. 
Once you come out of the autopilot at N1, you have about 15-20 seconds to save the Ralari, which is NOT enough time to distract all 4 Grathas unless you’re extremely lucky or good or both. 
You can try this 100 times and you won’t succeed. It’s THAT frustrating.

If you really want to try, you need to kill two Grathas VERY quickly. 
Quickly find the ones attacking (some may just be flying around). Quickly send taunt to all four while you afterburner in.
Send Bossman to attack one. Fire one missile at the next one, then full guns. 
That should kill that one. Turn toward next one, kamikaze into it, hopefully right after you fired your missile at it. 
By then your missile should lock and/or your guns should be recharged. Kill that one. Now two are down and the odds are even.
Hopefully the Ralari is still alive then. Then just kill them and you win the mission.


6.10.3    Kurasawa 3 (15/15)

Escort mission, escort the Exeter (15) back to the Claw. No medal.

This one is actually quite easy. There’s a minefield between N01.
Five Dralthis are attacking the Exeter at N1.Kill them. Rendevous with Exeter. 
As you reach N2, 4 Krants attack. Take them out, and you’re home free.


#### Rostov Series (40/55)

Rostov is the turning point. 
If you win, you go to Venice. 
If you lose, you go to Hell’s Kitchen.
While Rostov missions are fun, all those asteroid fields also make the missions quite tedious.
You’re flying with Iceman in Raptors, and you’ll need the shields and firepower to win the day.


6.11.1    Rostov 1 (12/15)

Patrol/Strike. 4 Nav points (1 pt each), Dorkir (10), land (1). Bronze Star for 135 mp.

So many asteroids... It’s boring. 
N1 is in asteroids. 2 Dralthi at N12. 
N2 is in asteroids. 
N3 has 5 Grathas and a Dorkir. 
N4 has asteroids, and more asteroids between N4 and home.


6.11.2    Rostov 2 (15/15)

Strike mission, destroy the Ralari (15). Silver Star for 113 mp.
Launch is inside an asteroid field. Wing of 2+3 Salthis is between N0 and N1. 4 Jalthis are escorting the Ralari at N1.


6.11.3    Rostov 3 (25/25)

Patrol/Strike mission. Find Fralthi (15), kill Fralthi (10).
Gold Star for 120 mp.

N01 has nothing. N1 has nothing. At N2 you’ll find the 4 Krants and the Fralthi. Kill them. Between N20 you’ll find 4 Dralthi between the asteroids.


#### Hubble’s Star Series (65/90)

You fly with Knight in Scimitars. Missions are a bit tougher...
Mainly due to lousy fighters.


6.12.1    Hubble’s Star 1 (50/50)

Patrol / Strike mission, kill Ralari (15), Dakhath (15), and both
Dorkirs (2x10).

Note: if you have killed Dakhath in a previous mission, you get
those 15 pts automatically.

Launch is clear. N1 has the Ralari and 4 Krants. 4 Dralthi
(including Dakhath) and the 2 Dorkirs are at N2. N3 has some
mines.

Be careful about Dakhath. If you damage him, he’ll run away. Kill
him, THEN worry about the transports.


6.12.2    Hubble’s Star 2 (20/20)

Escort two Draymen (10 each) back to the Claw. 120 mp for Bronze Star.

Launch is clear. 4 Dralthis intercept between Claw and N1. 
Then you run into a minefield. At N1 4 Gratha are attacking the Draymen.

Note: you can lose both tankers, this mission doesn’t matter that much. As long as you do mission 1 and mission 3 perfectly you win the series.


6.12.3    Hubble’s Star 3 (20/20)

Defend the Claw (10), kill Redclaw (10), 110 mp for Silver Star.

Note: if you had killed Redclaw in a previous mission, you get the 10 pts automatically.

You go off to N1 to find the strike force... And through some asteroids. Upon arriving at N1, you see only a few Krants. 
Guess where they are? Yep. Kill the Krants, get back to the Claw, and you see the 4 Grathas attacking. 
When you take them out, 2 Jalthis join in (one of them would be Redclaw if he’s still around). 
Take them out, and you get the chance at Venice.


#### Venice Series

As long as you are at Venice, you have won (you’ll see the winning endgame). 
You can eject from every mission in this series. It does not matter. You fly this series with Hunter in Rapiers.


6.13.1    Venice 1

Patrol, Silver Star for 155 mp.
Exeter at N1, mines and 2 Jalthis at N2, mines at N3, asteroids at N34, 4 Krants at N4. There may be 4 Grathas and a Ralari at N4, unconfirmed.
No tricks, just kill all the enemies you see.


6.13.2    Venice 2

Strike, with a little help. Take out the Fralthi at N2. No medal...

Launch and rendevous with other Rapiers. 
Approach N1 with asteroids and you’ll run into 4 Grathas, though they should be no problem. 
On the way to N2 you’ll run into 4 Salthi. And finally, at N2 you see the Fralthi with 4 Krants as escort.


6.13.3    Venice 3

Patrol / Strike / Defend. Clear out the way for Tiger’s Claw to get into position to attack the Kilrathi starbase in Venice. 
It may be possible to get a Bronze Star on this mission, though medal points is unclear.

N01 has a minefield. N1 is clear. N12 has 2 Jalthi. N2 is clear. 
N3 has a Ralari and 2 Dralthi. As you reach N4, you see 4 Gratha attacking Tiger’s Claw.


6.13.4    Venice 4

Strike mission: take out the Starbase. 
You can get a Pewter Planet for 243 pts, but you can’t keep it, even though you had to kill just about everything personally to get it. 
The game ends so you can’t save that Pewter planet.

N01 has a minefield. 
At N1 there’s a Fralthi escorted by 4 Krants. 
At N2, 4 Grathas, followed by 4 Salthis, then 4 Jalthis protect the Starbase. When you take out the Starbase and return to the Claw, the game ends. 
You get your debriefing and maybe the medal, then the winning endgame, without a chance to REALLY admire your Pewter Planet you may have won.


#### Hell’s Kitchen

Oh, great. You’ll on the losing track, and you’re in a Scimitar flying with Hunter. As you WILL lose, there’s no point listing the victory points. Is there?

6.14.1    Hell’s Kitchen 1

Escort mission. Go to N1, escort the Drayman in.
Between N01 are 4 Salthis in your way. At N1, 3 Krants will attempt to stop you. Then 2 Krants (including Khajja the Fang) will attack. Drayman jumps in. On the way back, 4 Grathas attack.

6.14.2    Hell’s Kitchen 2

Patrol / Strike. Between N01 is a minefield, and 3-4 Salthis. At N1, you either see 4 Grathas or a Fralthi escorted by 3+3 Grathas.

6.14.3    Hell’s Kitchen 3

There are 4 Salthis in the mine field between N01. 4 Grathas (and 4 Dralthis?) are attacking the Exeter at N1. 
Dakhath, if you haven’t killed him, will be in one of the Dralthis.


6.14.4    Hell’s Kitchen 4

Patrol / Strike, clear the way for Tiger’s Claw’s retreat.
N1 has 2 Grathas and a Ralari. N2 has 4 Salthi. Take care of all the enemies fast, since the Tiger’s Claw won’t wait forever!
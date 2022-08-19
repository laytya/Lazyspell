## LazySpell v0.4 vanilla

LazySpell is addon that provides auto healing spell rank scale for Clique, Classic Mouseover, pfUI and LUNA (/lunamo) depending on unit health deficit. This means it's compatible with all Unit Frames that are supported by these addons.

This addon starts to work when you set up spell with rank 1, all other ranks will be passed unchanged

- Clique: set up by addon GUI
- CM: set up by executable macro like /cmcast Flash of Light(Rank 1)
- pfUI: set up by addon GUI
- LUNA: set up by executable macro like /lunamo Flash of Light(Rank 1)

I decided to include HealComm made by Aviana and fixed by Relapsed to improve communications between addons like LUF and SRF Improved v0.90 - full support(send/receive data about resurrections and incomming heals).
Thanks to _LazySpell and HealComm other Unit Frames will be able to send these informations to addons with full support which makes this solution very interesting especially in the raids where ressurection and inc heal monitor is very appreciated.

You can setup max ranks. persentage of overheal, minrank in options.


## HOWTO Install

- Extract the archive
- Copy "_LazySpell" folder into your "\<WOW FOLDER>/Interface/Addons/" directory


## What you need to make it work

- Bonus Scanner(mandatory)
  - mandatory dependancy
- ClassicMouseover
  - mouseover cast compatible with sRaidFrames
  - macro use example **/cmast Flash of Light** or with rank selected **/cmcast Flash of Light(Rank 1)**

- Clique
  - everybody knows what clique is

- ClassicSnowfall(optional)
  - great addon, accelerates key bindings so that they are activated by key press rather than key release

## HOWTO use

Using:

In Luna Unit Frames there are two options: clickcasting or mouseover.
- Clickcasting. Make bind 1 rank of the desired spell on the selected mouse button.
- Mouseover. Make a macro like **/lunamo Healing Wave (Rank 1)**. Bind macro to the button, move the cursor to the frame of the player and press the button.

Any other addon frame + Clique:

For mouseover functionality need addon Classic Mouseover.

- Сlique: just open the Clique window and click the desired mouse button or its combination on 1 rank of the desired heal spell.
- For the mouseover - make the macro **/cmcast Healing Wave (Rank 1)**

In pfUI :
- Configure clickcast of rank 1 spells in /pfui -> Unit Frames -> Click Casting

Options:

*Overheal Ratio* - Regulates nedoheal-overheal. To avoid overheal or to heal less ranks, use values less than 1.

*Max spell ranks* - The option is responsible for ensuring that the healer does not go out of mana in the raid on long battles. We put the maximum rank of spells that you can afford.

For shamans, there is an option of a minimal Healing Wave rank. Very convenient for setting up the healspam of current tank.


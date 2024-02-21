Directory contains scripts to import data from the Wing Commander resource files into the project as Godot resources 
(tres/tscn files) into the `Assets`, the corresponding GDScript for the different resource types are defined in the `Scripts` folder).

The conversion is split into three parts

1. Extract the game data using the wing commander toolbox
2. Python scripts (because of the wide ecosystem) to convert the xml and gif files in a more Godot friendly format (json and png) and upscale the images (including correction of the coordinates in the corresponding metadata).
3. GDScript import scripts to convert the json files to Godot resources


The python script expects all game assets exported into one folder using `WCToolsCmd WC1:PC:XmlPack source [destination]`.

The Godot scripts expect the complete converted export to be located in [./wc1_xml2json/output] (adapt the location if needed in the scripts).
The imported resources will be created in the [../Assets](Assets) folder by default.



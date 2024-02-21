import logging
import os

import fire

from convert_briefing import convert_briefing_xml
from convert_camp import convert_camp_xml
from convert_comms import convert_comms_xml
from convert_exe import convert_exe_xml
from convert_font import convert_font_xml
from convert_vga import convert_vga_xml
from convert_gamepal import convert_gamepal_xml
from convert_midgame import convert_midgame_xml
from convert_module import convert_module_xml


def _convert_all_briefing_xml(wct_output_path: str, converted_json_output_path: str):
    convert_briefing_xml(os.path.join(wct_output_path, "GAMEDAT", "BRIEFING.000", "BRIEFING.000.xml"),
                         os.path.join(converted_json_output_path, "briefing.000.json"))
    convert_briefing_xml(os.path.join(wct_output_path, "GAMEDAT", "BRIEFING.001", "BRIEFING.001.xml"),
                         os.path.join(converted_json_output_path, "briefing.001.json"))
    convert_briefing_xml(os.path.join(wct_output_path, "GAMEDAT", "BRIEFING.002", "BRIEFING.002.xml"),
                         os.path.join(converted_json_output_path, "briefing.002.json"))


def _convert_all_camp_xml(wct_output_path: str, converted_json_output_path: str):
    convert_camp_xml(os.path.join(wct_output_path, "GAMEDAT", "CAMP.000", "CAMP.000.xml"),
                     os.path.join(converted_json_output_path, "camp.000.json"))
    convert_camp_xml(os.path.join(wct_output_path, "GAMEDAT", "CAMP.001", "CAMP.001.xml"),
                     os.path.join(converted_json_output_path, "camp.001.json"))
    convert_camp_xml(os.path.join(wct_output_path, "GAMEDAT", "CAMP.002", "CAMP.002.xml"),
                     os.path.join(converted_json_output_path, "camp.002.json"))


def _convert_all_comms_xml(wct_output_path: str, converted_json_output_path: str):
    convert_comms_xml(os.path.join(wct_output_path, "GAMEDAT", "COMMSM2.DAT", "COMMSM2.DAT.xml"),
                      os.path.join(converted_json_output_path, "commsm2.dat.json"))
    convert_comms_xml(os.path.join(wct_output_path, "GAMEDAT", "COMMUNIC.DAT", "COMMUNIC.DAT.xml"),
                      os.path.join(converted_json_output_path, "communic.dat.json"))


def _convert_all_midgame_xml(wct_output_path: str,
                             converted_json_output_path: str,
                             image_scale_factor: int):
    convert_midgame_xml(os.path.join(wct_output_path, "GAMEDAT", "MIDGAME.V00", "MIDGAME.V00.xml"),
                        os.path.join(converted_json_output_path, "midgame.v00.json"),
                        image_scale_factor)
    convert_midgame_xml(os.path.join(wct_output_path, "GAMEDAT", "MIDGAME.V01", "MIDGAME.V01.xml"),
                        os.path.join(converted_json_output_path, "midgame.v01.json"),
                        image_scale_factor)
    convert_midgame_xml(os.path.join(wct_output_path, "GAMEDAT", "MIDGAME.V02", "MIDGAME.V02.xml"),
                        os.path.join(converted_json_output_path, "midgame.v02.json"),
                        image_scale_factor)
    convert_midgame_xml(os.path.join(wct_output_path, "GAMEDAT", "MIDGAME.V03", "MIDGAME.V03.xml"),
                        os.path.join(converted_json_output_path, "midgame.v03.json"),
                        image_scale_factor)
    convert_midgame_xml(os.path.join(wct_output_path, "GAMEDAT", "MIDGAME.V04", "MIDGAME.V04.xml"),
                        os.path.join(converted_json_output_path, "midgame.v04.json"),
                        image_scale_factor)
    convert_midgame_xml(os.path.join(wct_output_path, "GAMEDAT", "MIDGAME.V05", "MIDGAME.V05.xml"),
                        os.path.join(converted_json_output_path, "midgame.v05.json"),
                        image_scale_factor)
    convert_midgame_xml(os.path.join(wct_output_path, "GAMEDAT", "MIDGAME.V06", "MIDGAME.V06.xml"),
                        os.path.join(converted_json_output_path, "midgame.v06.json"),
                        image_scale_factor)
    convert_midgame_xml(os.path.join(wct_output_path, "GAMEDAT", "MIDGAME.V07", "MIDGAME.V07.xml"),
                        os.path.join(converted_json_output_path, "midgame.v07.json"),
                        image_scale_factor)
    convert_midgame_xml(os.path.join(wct_output_path, "GAMEDAT", "MIDGAME.V08", "MIDGAME.V08.xml"),
                        os.path.join(converted_json_output_path, "midgame.v08.json"),
                        image_scale_factor)


def _convert_all_modules_xml(wct_output_path: str, converted_json_output_path: str):
    convert_module_xml(os.path.join(wct_output_path, "GAMEDAT", "MODULE.000", "MODULE.000.xml"),
                       os.path.join(converted_json_output_path, "module.000.json"))
    convert_module_xml(os.path.join(wct_output_path, "GAMEDAT", "MODULE.001", "MODULE.001.xml"),
                       os.path.join(converted_json_output_path, "module.001.json"))
    convert_module_xml(os.path.join(wct_output_path, "GAMEDAT", "MODULE.002", "MODULE.002.xml"),
                       os.path.join(converted_json_output_path, "module.002.json"))


def _convert_all_pcship_xml(wct_output_path: str, converted_json_output_path: str, image_scale_factor: int = 4):
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "PCSHIP.V00", "PCSHIP.V00.xml"),
                    os.path.join(converted_json_output_path, "pcship.v00.json"), image_scale_factor)
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "PCSHIP.V01", "PCSHIP.V01.xml"),
                    os.path.join(converted_json_output_path, "pcship.v01.json"), image_scale_factor)
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "PCSHIP.V02", "PCSHIP.V02.xml"),
                    os.path.join(converted_json_output_path, "pcship.v02.json"), image_scale_factor)
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "PCSHIP.V03", "PCSHIP.V03.xml"),
                    os.path.join(converted_json_output_path, "pcship.v03.json"), image_scale_factor)
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "PCSHIP.V04", "PCSHIP.V04.xml"),
                    os.path.join(converted_json_output_path, "pcship.v04.json"), image_scale_factor)
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "PCSHIP.V05", "PCSHIP.V05.xml"),
                    os.path.join(converted_json_output_path, "pcship.v05.json"), image_scale_factor)


def _convert_all_ship_xml(wct_output_path: str, converted_json_output_path: str, image_scale_factor: int = 4):
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "SHIP.V04", "SHIP.V04.xml"),
                    os.path.join(converted_json_output_path, "ship.v04.json"), image_scale_factor)
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "SHIP.V05", "SHIP.V05.xml"),
                    os.path.join(converted_json_output_path, "ship.v05.json"), image_scale_factor)
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "SHIP.V06", "SHIP.V06.xml"),
                    os.path.join(converted_json_output_path, "ship.v06.json"), image_scale_factor)
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "SHIP.V07", "SHIP.V07.xml"),
                    os.path.join(converted_json_output_path, "ship.v07.json"), image_scale_factor)
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "SHIP.V08", "SHIP.V08.xml"),
                    os.path.join(converted_json_output_path, "ship.v08.json"), image_scale_factor)
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "SHIP.V15", "SHIP.V15.xml"),
                    os.path.join(converted_json_output_path, "ship.v15.json"), image_scale_factor)
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "SHIP.V16", "SHIP.V16.xml"),
                    os.path.join(converted_json_output_path, "ship.v16.json"), image_scale_factor)
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "SHIP.V17", "SHIP.V17.xml"),
                    os.path.join(converted_json_output_path, "ship.v17.json"), image_scale_factor)
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "SHIP.V18", "SHIP.V18.xml"),
                    os.path.join(converted_json_output_path, "ship.v18.json"), image_scale_factor)
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "SHIP.V19", "SHIP.V19.xml"),
                    os.path.join(converted_json_output_path, "ship.v19.json"), image_scale_factor)
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "SHIP.V20", "SHIP.V20.xml"),
                    os.path.join(converted_json_output_path, "ship.v20.json"), image_scale_factor)
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "SHIP.V21", "SHIP.V21.xml"),
                    os.path.join(converted_json_output_path, "ship.v21.json"), image_scale_factor)


def _convert_all_shiptype_xml(wct_output_path: str, converted_json_output_path: str, image_scale_factor: int = 4):
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "SHIPTYPE.V00", "SHIPTYPE.V00.xml"),
                    os.path.join(converted_json_output_path, "shiptype.V00.json"), image_scale_factor)
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "SHIPTYPE.V01", "SHIPTYPE.V01.xml"),
                    os.path.join(converted_json_output_path, "shiptype.V01.json"), image_scale_factor)
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "SHIPTYPE.V02", "SHIPTYPE.V02.xml"),
                    os.path.join(converted_json_output_path, "shiptype.V02.json"), image_scale_factor)
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "SHIPTYPE.V03", "SHIPTYPE.V03.xml"),
                    os.path.join(converted_json_output_path, "shiptype.V03.json"), image_scale_factor)
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "SHIPTYPE.V09", "SHIPTYPE.V09.xml"),
                    os.path.join(converted_json_output_path, "shiptype.V09.json"), image_scale_factor)
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "SHIPTYPE.V10", "SHIPTYPE.V10.xml"),
                    os.path.join(converted_json_output_path, "shiptype.V10.json"), image_scale_factor)
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "SHIPTYPE.V11", "SHIPTYPE.V11.xml"),
                    os.path.join(converted_json_output_path, "shiptype.V11.json"), image_scale_factor)
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "SHIPTYPE.V12", "SHIPTYPE.V12.xml"),
                    os.path.join(converted_json_output_path, "shiptype.V12.json"), image_scale_factor)
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "SHIPTYPE.V13", "SHIPTYPE.V13.xml"),
                    os.path.join(converted_json_output_path, "shiptype.V13.json"), image_scale_factor)
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "SHIPTYPE.V14", "SHIPTYPE.V14.xml"),
                    os.path.join(converted_json_output_path, "shiptype.V14.json"), image_scale_factor)
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "SHIPTYPE.V29", "SHIPTYPE.V29.xml"),
                    os.path.join(converted_json_output_path, "shiptype.V29.json"), image_scale_factor)


def _convert_all_vga_xml(wct_output_path: str, converted_json_output_path: str, image_scale_factor: int = 4):
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "ARROW.VGA", "ARROW.VGA.xml"),
                    os.path.join(converted_json_output_path, "arrow.vga.json"),
                    image_scale_factor)
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "BRIEFING.VGA", "BRIEFING.VGA.xml"),
                    os.path.join(converted_json_output_path, "briefing.vga.json"),
                    image_scale_factor)
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "COCKPIT.VGA", "COCKPIT.VGA.xml"),
                    os.path.join(converted_json_output_path, "cockpit.vga.json"),
                    image_scale_factor)
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "OBJECTS.VGA", "OBJECTS.VGA.xml"),
                    os.path.join(converted_json_output_path, "objects.vga.json"),
                    image_scale_factor)
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "PILOTANM.VGA", "PILOTANM.VGA.xml"),
                    os.path.join(converted_json_output_path, "pilotanm.vga.json"),
                    image_scale_factor)
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "PLANETS.VGA", "PLANETS.VGA.xml"),
                    os.path.join(converted_json_output_path, "planets.vga.json"),
                    image_scale_factor)
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "PLANETS1.VGA", "PLANETS1.VGA.xml"),
                    os.path.join(converted_json_output_path, "planets1.vga.json"),
                    image_scale_factor)
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "RECROOM.VGA", "RECROOM.VGA.xml"),
                    os.path.join(converted_json_output_path, "recroom.vga.json"),
                    image_scale_factor)
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "SCRAMBLE.VGA", "SCRAMBLE.VGA.xml"),
                    os.path.join(converted_json_output_path, "scramble.vga.json"),
                    image_scale_factor)
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "SERIES.VGA", "SERIES.VGA.xml"),
                    os.path.join(converted_json_output_path, "series.vga.json"),
                    image_scale_factor)
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "TALKING.VGA", "TALKING.VGA.xml"),
                    os.path.join(converted_json_output_path, "talking.vga.json"),
                    image_scale_factor)
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "TALKING1.VGA", "TALKING1.VGA.xml"),
                    os.path.join(converted_json_output_path, "talking1.vga.json"),
                    image_scale_factor)
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "TITLE.VGA", "TITLE.VGA.xml"),
                    os.path.join(converted_json_output_path, "title.vga.json"),
                    image_scale_factor)
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "TITLE1.VGA", "TITLE1.VGA.xml"),
                    os.path.join(converted_json_output_path, "title1.vga.json"),
                    image_scale_factor)
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "WINGMEN.VGA", "WINGMEN.VGA.xml"),
                    os.path.join(converted_json_output_path, "wingmen.vga.json"),
                    image_scale_factor)
    convert_vga_xml(os.path.join(wct_output_path, "GAMEDAT", "WINGMEN1.VGA", "WINGMEN1.VGA.xml"),
                    os.path.join(converted_json_output_path, "wingmen1.vga.json"),
                    image_scale_factor)


def main(wct_output_path: str, converted_json_output_path: str, image_scale_factor: int = 4):
    convert_exe_xml(os.path.join(wct_output_path, "WC.EXE.xml"),
                    os.path.join(converted_json_output_path, "wc.exe.json"),
                    image_scale_factor)
    _convert_all_briefing_xml(wct_output_path, converted_json_output_path)
    _convert_all_camp_xml(wct_output_path, converted_json_output_path)
    _convert_all_comms_xml(wct_output_path, converted_json_output_path)
    convert_gamepal_xml(os.path.join(wct_output_path, "GAMEDAT", "GAME.PAL", "GAME.PAL.xml"),
                        os.path.join(converted_json_output_path, "game.pal.json"))
    convert_font_xml(os.path.join(wct_output_path, "GAMEDAT", "FONTS.FNT", "FONTS.FNT.xml"),
                     os.path.join(converted_json_output_path, "fonts.fnt.json"),
                     image_scale_factor)
    _convert_all_midgame_xml(wct_output_path, converted_json_output_path, image_scale_factor)
    _convert_all_modules_xml(wct_output_path, converted_json_output_path)
    _convert_all_pcship_xml(wct_output_path, converted_json_output_path, image_scale_factor)
    _convert_all_ship_xml(wct_output_path, converted_json_output_path, image_scale_factor)
    _convert_all_shiptype_xml(wct_output_path, converted_json_output_path, image_scale_factor)
    _convert_all_vga_xml(wct_output_path, converted_json_output_path, image_scale_factor)


if __name__ == "__main__":
    logging.basicConfig(level=logging.DEBUG)
    fire.Fire(main)

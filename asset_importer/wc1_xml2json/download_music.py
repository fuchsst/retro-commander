# see https://www.wcnews.com/wcpedia/Category:Wing_Commander#Music

import logging
import os
import zipfile
from io import BytesIO

import fire
import requests


def download_and_extract_specific_folder(zip_url, specific_folder, output_directory):
    """
    Downloads a ZIP file from a given URL, and extracts a specific folder to the output directory.

    Parameters:
    - zip_url: The URL to the ZIP file.
    - specific_folder: The specific folder within the ZIP file to extract.
    - output_directory: The directory to extract the specific folder to.
    """

    # Make sure the output directory exists
    if not os.path.exists(output_directory):
        os.makedirs(output_directory)

    # Download the ZIP file
    response = requests.get(zip_url)
    if response.status_code == 200:
        zip_file = zipfile.ZipFile(BytesIO(response.content))

        # Extract the specific folder
        for file_info in zip_file.infolist():
            print(file_info.filename)
            if file_info.filename.startswith(specific_folder) and file_info.filename != specific_folder:
                target_path = os.path.join(output_directory, os.path.basename(file_info.filename))

                # Extract the file to the new path
                source = zip_file.open(file_info.filename)
                target = open(target_path, "wb")
                with source, target:
                    target.write(source.read())
        logging.info(f"Successfully extracted '{specific_folder}' to '{output_directory}'")
    else:
        logging.error(f"Failed to download the ZIP file. Status code: {response.status_code}")


def main(target_path: str):
    download_and_extract_specific_folder(
        "http://download.wcnews.com/music/wc1/wc_amiga_mp3.zip",
        "Wing Commander Amiga OST/mix/",
        target_path)


if __name__ == "__main__":
    logging.basicConfig(level=logging.DEBUG)
    fire.Fire(main)

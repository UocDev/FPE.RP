import os
import subprocess
from datetime import datetime

GAME_NAME = "MyAwesomeGame"
PLACE_FILE = "game.rbxlx"
ROJO_PROJECT = "default.project.json"
OUTPUT_DIR = "out"
ROBLOX_CLI = "roblox-cli"

def run_command(command):
    try:
        result = subprocess.run(command, shell=True, check=True, text=True, capture_output=True)
        return result.stdout
    except subprocess.CalledProcessError as e:
        print(f"Command failed: {e.stderr}")
        exit(1)

def main():
    print("Cleaning previous build...")
    if os.path.exists(OUTPUT_DIR):
        for file in os.listdir(OUTPUT_DIR):
            os.remove(os.path.join(OUTPUT_DIR, file))
        os.rmdir(OUTPUT_DIR)
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    print("Building with Rojo...")
    run_command(f"rojo build {ROJO_PROJECT} -o {os.path.join(OUTPUT_DIR, PLACE_FILE)}")

    if not os.path.exists(os.path.join(OUTPUT_DIR, PLACE_FILE)):
        print("Build failed - no place file created")
        exit(1)

    print("Uploading to Roblox...")
    description = f"Automated deployment {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}"
    run_command(f"{ROBLOX_CLI} upload --place {os.path.join(OUTPUT_DIR, PLACE_FILE)} --name {GAME_NAME} --description '{description}'")

    print("Deployment complete!")

if __name__ == "__master__":
    main()

# WSL Debian Docker Azerothcore-Playerbots Installation

## Table of Contents

- [Requirements](#requirements)
- [Git Cloning](#git-cloning)
- [WSL Installation](#wsl-installation)
- [Docker Installation](#docker-installation)
- [Azerothcore-Playerbots Introduction](#azerothcore-playerbot)
- [AzerothCore Bot Installation](#azerothcore-bot-installation)
- [Credits](#credits)

## Requirements
 - Windows 11
 - Windows 10 version 1903 (build 18362) atleast or later
 - wsl2
 
## Git Cloning
1. Clone Repository:
	```cmd
	git clone https://github.com/notepadguyOfficial/Debian-Docker-Azerothcore-Playerbot.git
	```
 
## WSL Installation
1. Open cmd/Powershell and run this command:
	```cmd
	wsl --insall -d Debian
	```

2. Once Installed, Export the a backup to the desired location:
	```cmd
	wsl --export Debian C:\Example
	```
	or
	```cmd
	wsl --export Debian D:\Example
	```

3. Unregister the Original Debian Image from WSL:
	```cmd
	wsl --unregister Debian
	```

4. Import it back into your chosen location:
	```cmd
	wsl --import Debian C:\Debian C:\Example\Debian.tar --version 2
	```
	or
	```cmd
	wsl --import Debian D:\Debian D:\Example\Debian.tar --version 2
	```
	
 - (Optional) Delete the .tar file to free space:
	```cmd
	Remove-Item D:\Example\Debian.tar
	```
5. Launch Debian:
	```cmd
	wsl -d Debian
	```

## Docker Installation
1. see [Git Cloning](#git-cloning)

2. Run WSL via cmd/Powershell:
    ```cmd
    wsl -d Debian
    ```

3. Navigate to repository:
    ```cmd
    cd /mnt/c/to-your-cloned-repository-directory
    ```
    or if you cloned the repository in another drive:
	```cmd
    cd /mnt/d/to-your-cloned-repository-directory
    ```

4. run the sh file:
	```cmd
	./setup-docker-wsl.sh
	```

 - (!Note) If you run the script but with error, This usually means Windows-style line endings instead of the Unix-style.
	To fix this run this command
	```cmd
	sudo apt install dos2unix

	#then

	dos2unix *.sh

	#final command

	chmod +x *.sh
	```

5. wait until done then restart wsl:
	```cmd
	wsl --shutdown
	```
	then start the wsl service again
	```
	wsl -d Debian
	```
	
## Azerothcore-Playerbot
Includes:
 - MariaDB-Client (This is only client and will install only if you dont have the mysql command...)
 - Azeroth Core - Playerbots branch
 - mod-playerbots
 - mod-aoe-loot (optional)
 - mod-learn-spells (optional)
 - mod-fireworks-on-level (optional)
 - mod-individual-progression (optional)
 - mod-junk-to-gold (optional)
 - mod-DungeonRespawn (optional)

### Update
 - To update and get the latest versions, you can run `./uninstall.sh` without deleting the volumes and run `./setup.sh` again. It will prompt you if you want to delete the volumes.

 - You can add modules to the `setup.sh` file by scrolling to the "install_mod" section and add the entries you'd like. Or you could do it manually by putting the modules folders into the `azerothcore-wotlk/modules` folder. `setup.sh` will automatically add the sql. See

 - Running `setup.sh` will not install anything over again unless you delete a modules folder or the `azerothcore-wotlk` folder before. You can run it if you only want to install new modules youve added, it will skip if you already downloaded the repos. 

- If you delete modules, remember to run `clear_custom_sql.sh` first and remove the respective tables in the db.

## AzerothCore Bot Installation
1. Run Setup sh Script:
	```cmd
	./setup.sh
	```

2. choose if you want to install modules besides the given one.
 - (Optional) You can edit `setup.sh` to add another modules
 
3. Wait for docker to install the images.

4. If no error then attach to ac-worldserver by running this command:
	```cmd
	docker attach ac-worldserver
	```
	(!Note) You can dettach from attached service by pressing `ctrl+p` and `ctrl+q`.
	
5. Create Azerothcore Account
	```cmd
	account create <username> <password>
	```
	
6. Find WSL IP Address
	```cmd
	ip addr show eth0
	```
	(!Important) when connecting to database or game use the wsl ip address.
	
7. Edit your `<your wow root directory>\Data\enUS\realmlist.wtf` and type in the wsl ip address you get in the end of installing.

```
set realmlist 172.17.0.1
```

8. Run the Game and your done.

## Credits
 - Special thanks to [coc0nut](https://github.com/coc0nut) for the Script Base [Repository](https://github.com/coc0nut/AzerothCore-with-Playerbots-Docker-Setup).
 - Special thanks to [Jérémie Panzer](https://gist.github.com/Athou) for the insallation Script of Docker [Script-Link](https://gist.github.com/Athou/022c67de48f1cf6584ce6c194af71a09).
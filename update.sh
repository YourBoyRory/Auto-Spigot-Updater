#!/bin/bash

#    _____        _____
#   / _ \ \      / / _ \
#  | | | \ \ /\ / / | | |
#  | |_| |\ V  V /| |_| |
#   \___/  \_/\_/  \___/
# Organized Web Operations
# YourBoyRory

## CONFIG ##

# BuildTools
buildtools_DIR="/servers/minecraftserver/"
install_DIR="/servers/minecraftserver/"
rev="latest" # latest
delbackups=1

# Java
javaVer="17" # normally use '8' or for minecraft 1.18+ use '17' 
updatejava=1


## NO TOUCHY >w< ##

# Update Java Version
if [ $updatejava -eq 1 ] ; then
	sudo yum update
	sudo yum install java-$javaVer-openjdk
fi

# Updates BuildTools
wget -O $buildtools_DIR/BuildTools.jar https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar

# Creates Backups
mv $install_DIR/Bukkit $install_DIR/Bukkit.bak
mv $install_DIR/BuildData $install_DIR/BuildData.bak
mv $install_DIR/CraftBukkit $install_DIR/CraftBukkit.bak
mv $install_DIR/Spigot $install_DIR/Spigot.bak
mv $install_DIR/work $install_DIR/work.bak
apacheVersion=$(ls -d apache-maven-*)
mv $install_DIR/apache-maven-* $install_DIR/apache-old.bak
spigotVersion=$(ls spigot-*.jar)
mv $install_DIR/spigot-*.jar $install_DIR/spigot-old.jar.bak

# Fresh Installs Spigot
cd $install_DIR
java -jar $buildtools_DIR/BuildTools.jar --rev $rev
if [ $? -eq 0 ] ; then
    echo -e "\e[93mSuccess!\e[0m"
	# Dels Backups if set to
    if [ $delbackups -eq 1 ] ; then
        echo -e "\e[93mRemoving Backups\e[0m"
        rm -rf $install_DIR/Bukkit.bak
        rm -rf $install_DIR/BuildData.bak
        rm -rf $install_DIR/CraftBukkit.bak
        rm -rf $install_DIR/Spigot.bak
        rm -rf $install_DIR/work.bak
        rm -rf $install_DIR/apache-old.bak
        rm -rf $install_DIR/spigot-old.jar.bak
    fi
else
	# If update fails it attepts to restore
    echo -e "[\e[31mERROR\e[0m] Server Update \e[31m\e[1mFAILED!\e[0m I have no fucking clue why..."
    echo -e "\e[93mRestoing Backups\e[0m"
    rm -rf $install_DIR/Bukkit
    rm -rf $install_DIR/BuildData
    rm -rf $install_DIR/CraftBukkit
    rm -rf $install_DIR/Spigot
    rm -rf $install_DIR/work
    rm -rf $install_DIR/apache-maven-*
    rm -rf $install_DIR/spigot-*.jar
    mv $install_DIR/Bukkit.bak  $install_DIR/Bukkit
    mv $install_DIR/BuildData.bak $install_DIR/BuildData
    mv $install_DIR/CraftBukkit.bak $install_DIR/CraftBukkit
    mv $install_DIR/Spigot.bak $install_DIR/Spigot
    mv $install_DIR/work.bak $install_DIR/work
    mv $install_DIR/apache-maven.bak $install_DIR/$apacheVersion
    mv $install_DIR/spigot.jar.bak $install_DIR/$spigotVersion
fi

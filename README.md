# Supported tags and respective `Dockerfile` links
-	[`base`, `latest` (*bullseye/Dockerfile*)](https://github.com/CM2Walki/TF2/blob/master/bullseye/Dockerfile)
-	[`metamod` (*bullseye-metamod/Dockerfile*)](https://github.com/CM2Walki/TF2/blob/master/bullseye-metamod/Dockerfile)
-	[`sourcemod` (*bullseye-sourcemod/Dockerfile*)](https://github.com/CM2Walki/TF2/blob/master/bullseye-sourcemod/Dockerfile)

# What is Team Fortress 2?
Nine distinct classes provide a broad range of tactical abilities and personalities. Constantly updated with new game modes, maps, equipment and, most importantly, hats!
This Docker image contains the dedicated server of the game.

>  [TF2](https://store.steampowered.com/app/440/Team_Fortress_2/)

<img src="https://1000logos.net/wp-content/uploads/2020/09/Team-Fortress-2-logo.png" alt="logo" width="300"/></img>

# How to use this image
## Hosting a simple game server

Running on the *host* interface (recommended):<br/>
```console
$ docker run -d -it --net=host --name=tf2-dedicated -e SRCDS_TOKEN={YOURTOKEN} cm2network/tf2
```

Running using a bind mount for data persistence on container recreation:
```console
$ mkdir -p $(pwd)/tf2-data
$ chmod 777 $(pwd)/tf2-data # Makes sure the directory is writeable by the unprivileged container user
$ docker run -d -it --net=host -v $(pwd)/tf2-data:/home/steam/tf-dedicated/ --name=tf2-dedicated -e SRCDS_TOKEN={YOURTOKEN} cm2network/tf2
```

Running multiple instances (increment SRCDS_PORT and SRCDS_TV_PORT):
```console
$ docker run -d -it --net=host --name=tf2-dedicated2 -e SRCDS_PORT=27016 -e SRCDS_TV_PORT=27021 -e SRCDS_TOKEN={YOURTOKEN} cm2network/tf2
```

`SRCDS_TOKEN` **is required to be listed & reachable. Generate one here using AppID `440`:**  
[https://steamcommunity.com/dev/managegameservers](https://steamcommunity.com/dev/managegameservers)<br/><br/>
`SRCDS_WORKSHOP_AUTHKEY` **is required to use workshop features:**  
[https://steamcommunity.com/dev/apikey](https://steamcommunity.com/dev/apikey)<br/>

**It's also recommended to use "--cpuset-cpus=" to limit the game server to a specific core & thread.**<br/>
**The container will automatically update the game on startup, so if there is a game update just restart the container.**

# Configuration
## Environment Variables
Feel free to overwrite these environment variables, using -e (--env): (NO DEFAULTS CURRENTLY SET)
```dockerfile
SRCDS_PORT=27015
SRCDS_CLIENT_PORT=
SRCDS_IP=
SRCDS_MAXPLAYERS=
SRCDS_STARTMAP=
SRCDS_CFG= (server.cfg)
SRCDS_CYCLE= (mapcycle_<name>.conf)

```
## Config
The image contains static copies of the competitive config files from [UGC League](https://www.ugcleague.com/files_tf26.cfm#) and [RGL.gg](https://rgl.gg/Public/About/Configs.aspx?r=24). 

You can edit the config using this command:
```console
$ docker exec -it tf2-dedicated nano /home/steam/tf-dedicated/tf/cfg/server.cfg
```

If you want to learn more about configuring a TF2 server check this [documentation](https://wiki.teamfortress.com/wiki/Dedicated_server_configuration).

# Image Variants:
The `moevstf2` images come in three flavors, each designed for a specific use case.

## `moevstf2:latest`
This is the defacto image. If you are unsure about what your needs are, you probably want to use this one. It is a bare-minimum TF2 dedicated server containing no 3rd party plugins.<br/>

## `moevstf2:metamod`
This is a specialized image. It contains the plugin environment [Metamod:Source](https://www.sourcemm.net) which can be found in the addons directory. You can find additional plugins [here](https://www.sourcemm.net/plugins).

## `moevstf2:sourcemod`
This is another specialized image. It contains both [Metamod:Source](https://www.sourcemm.net) and the popular server plugin [SourceMod](https://www.sourcemod.net) which can be found in the addons directory. [SourceMod](https://www.sourcemod.net) supports a wide variety of additional plugins that can be found [here](https://www.sourcemod.net/plugins.php).


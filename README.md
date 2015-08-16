SpigotMC Minecraft
==================

 Key references:
  * Download, build, and install SpigotMC's BuildTool and SpigotMC [1](https://www.spigotmc.org/wiki/buildtools/)
  * Configure SpigotMC [2](https://www.spigotmc.org/wiki/spigot-installation/)

Build customization is performed via ENV settings:
  * SPIGOT_REV specifies the version of Spigot built (default: 1.8.8)
  * SPIGOT_BUILD_REV specifies the version of Spigot source code to pull (default: latest)
  * JVM_OPT_XmX sets the JVM option for maximum memory size (default: -Xmx1024M)
  * JVM_OPT_Xms sets the JVM option for starting memory size (default: -Xms512M)
  * MINECRAFT_BASE is the top-level directory for the rest (default: /minecraft)
  * MINECRAFT_BUILD directory for Spigot build files (default: /minecraft/build)
  * MINECRAFT_JAR directory for newly-built Spigot jar files (default: /minecraft/jar)
  * MINECRAFT_SERVER directory for Spigot configuration files (default: /minecraft/server)
  * JAR_TO_RUN sets the server .jar file to run (default: ${MINECRAFT_JAR}/spigot-${SPIGOT_REV}.jar)
  * FILE_BUILDTOOL sets download location for Spigot's BuildTools [download](https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar)

Exposed ports:
  * 25565/tcp (Minecraft standard)
  * 25575/tcp (Minecraft remote console port)

Exposed VOLUMES:
  * VOLUME ${MINECRAFT_JAR} (default: /minecraft/jar)
  * VOLUME ${MINECRAFT_SERVER} (default: /minecraft/server)

SpigotMC Minecraft
==================
This [Docker][1] image auto-creates a recent [SpigotMC][2] server.

Image Customization
-------------------
Change the following [ENV][3] settings to affect the image build or container runtime.

Image building settings include:
  * `SPIGOT_REV` specifies the version of Spigot built (default: `1.8.8`). Must be kept
    in sync with the upstream, or exactly match `SPIGOT_BUILD_REV` if an older version is needed.
  * `SPIGOT_BUILD_REV` specifies the version of Spigot source code to pull (default: `latest`)
  * `MINECRAFT_BASE` is the top-level directory for the rest (default: `/minecraft`),
    indirectly used by the volume settings.
  * `MINECRAFT_BUILD` directory for Spigot build files (default: `/minecraft/build`), not
    retained outside of the build-time (in the running container).
  * `MINECRAFT_JAR` volume for newly-built Spigot jar files (default: `/minecraft/jar`).
  * `MINECRAFT_SERVER` volume for Spigot server configuration files (default: `/minecraft/server`).
  * `FILE_BUILDTOOL` sets download location for Spigot's BuildTools [SpigotMC's BuildTools][4].

The following settings affect the container runtime, and can be readily overridden on
the command-line or a docker-compose configuration.
  * `SPIGOT_OPTS` provides options to Spigot runtime (default: `--noconsole`).

      `--noconsole` is needed to avoid 100% CPU from a detached console.
  * `JVM_OPTS` sets the JVM options, such as memory size and garbage collection.

    Default:
      `-Xms512M -Xmx512M -XX:+UseConcMarkSweepGC -XX:+CMSIncrementalPacing -XX:+AggressiveOpts`
  * `JAR_TO_RUN` sets the server .jar file to run (default: `${MINECRAFT_JAR}/spigot-${SPIGOT_REV}.jar`).

Exposed VOLUMES
---------------
  * `VOLUME ${MINECRAFT_SERVER}` (default: `/minecraft/server`), for the server configuration directory. Must be provided from outside the image to retain persistence. If an external volume is not provided, a new server will be created, then automatically abort since the EULA has not been accepted.
  * `VOLUME ${MINECRAFT_JAR}` (default: `/minecraft/jar`), for the server .jar files. 

Exposed Ports
-------------
  * `25565/tcp` (Minecraft standard)
  * `25575/tcp` (Minecraft remote console port)

Additional Information
----------------------
Inside the container, user/group `minecraft` is created. This user is used to build
and run the Spigot server.

Source references:
  * Download, build, and install: [SpigotMC Build][5]
  * Configure the [SpigotMC Installation][6]

[1]: https://www.docker.io/                                 "Docker"
[2]: https://www.spigotmc.org/                              "SpigotMC"
[3]: https://docs.docker.com/reference/builder/#env         "ENV"
[4]: https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar     "SpigotMC's BuildTools"
[5]: https://www.spigotmc.org/wiki/buildtools/              "SpigotMC Build"
[6]: https://www.spigotmc.org/wiki/spigot-installation/     "SpigotMC Installation"

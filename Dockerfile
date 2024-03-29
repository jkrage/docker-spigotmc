FROM debian:unstable
MAINTAINER Joshua Krage <jkrage@guisarme.us>
### Image customization:
###   SPIGOT_REV specifies the version of Spigot built (default: 1.16)
###   SPIGOT_BUILD_REV specifies the version of Spigot source code to pull (default: latest)
###   SPIGOT_OPTS provides options to Spigot runtime (default: nogui --noconsole)
###   JVM_OPTS sets the JVM options, such as memory size and garbage collection
###     Default:
###       -Xms512M -Xmx512M -XX:+UseConcMarkSweepGC -XX:+CMSIncrementalPacing -XX:+AggressiveOpts
###   MINECRAFT_BASE is the top-level directory for the rest (default: /minecraft)
###   MINECRAFT_BUILD directory for Spigot build files (default: /minecraft/build)
###   MINECRAFT_JAR directory for newly-built Spigot jar files (default: /minecraft/jar)
###   MINECRAFT_SERVER directory for Spigot configuration files (default: /minecraft/server)
###
###   JAR_TO_RUN sets the server .jar file to run (default: ${MINECRAFT_JAR}/spigot-${SPIGOT_REV}.jar)
###   FILE_BUILDTOOL sets download location for Spigot's BuildTools
###     (default: https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/    BuildTools.jar)
###
ENV JVM_OPTS="-Xms512M -Xmx512M"
ENV SPIGOT_OPTS="nogui --noconsole"
ARG SPIGOT_REV="1.16"
ARG SPIGOT_BUILD_REV="1.16"
#
ENV MINECRAFT_BASE /minecraft
ENV MINECRAFT_BUILD ${MINECRAFT_BASE}/build
ENV MINECRAFT_JAR ${MINECRAFT_BASE}/jar
ENV MINECRAFT_SERVER ${MINECRAFT_BASE}/server
#
ENV JAR_TO_RUN="${MINECRAFT_JAR}/spigot-${SPIGOT_REV}.jar"
ENV FILE_BUILDTOOL https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar

# System setup
RUN apt-get update && apt-get -y install \
        git \
        tar \
        wget \
        openjdk-16-jre-headless \
    && apt-get --reinstall install ca-certificates-java \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd -r minecraft \
    && useradd -m -g minecraft -d ${MINECRAFT_BASE} minecraft \
    && mkdir -p ${MINECRAFT_BUILD} ${MINECRAFT_JAR} ${MINECRAFT_SERVER} \
    && chown minecraft:minecraft ${MINECRAFT_BUILD} ${MINECRAFT_JAR} ${MINECRAFT_SERVER}

# SpigotMC build and setup
USER minecraft
WORKDIR ${MINECRAFT_BUILD}
RUN wget -O BuildTools.jar ${FILE_BUILDTOOL} \
    && java -jar BuildTools.jar --rev ${SPIGOT_BUILD_REV} \
    && mv spigot-${SPIGOT_REV}.jar ${MINECRAFT_JAR} \
    && rm -rf ${MINECRAFT_BUILD}/*

# Switch to where the server will run
WORKDIR ${MINECRAFT_SERVER}

# Allow jars and server files to be accessed via volumes
VOLUME ${MINECRAFT_JAR}
VOLUME ${MINECRAFT_SERVER}

# Expose the standard Minecraft port, and remote console port
EXPOSE 25565
EXPOSE 25575

# Need to use "sh -c" to interpret the ENV values
CMD [ "/bin/sh", "-c", "/usr/bin/java ${JVM_OPTS} -jar ${JAR_TO_RUN} ${SPIGOT_OPTS}" ]

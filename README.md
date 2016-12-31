# Tomcat + SLF4J + Logback #

[![Build Status](https://travis-ci.org/tomcat-slf4j-logback/tomcat-slf4j-logback.svg?branch=master)](https://travis-ci.org/tomcat-slf4j-logback/tomcat-slf4j-logback)
[![Dependency Status](https://www.versioneye.com/user/projects/55ff4f0b601dd9001f000142/badge.svg?style=flat)](https://www.versioneye.com/user/projects/55ff4f0b601dd9001f000142)
[![Project Stats](https://www.openhub.net/p/tomcat-slf4j-logback/widgets/project_thin_badge.gif)](https://www.openhub.net/p/tomcat-slf4j-logback)
[![Github All Releases](https://img.shields.io/github/downloads/tomcat-slf4j-logback/tomcat-slf4j-logback/total.svg)]()

Tomcat SLF4J Logback is a drop in replacement to tomcat allowing full all internal logging to use our favorite slf4j/logback libraries.

## NOTICE ##

As of logback 1.1.7, it is no longer necessary to include `${catalina.home}` in server.xml for logback-access.  We have also realligned our code to better match logback in all ways.
Throughout this documentation you will read about the prior setup and the new setup.  Both should work without problems.

Drop in support 'server.xml' is correct on latest release.  Issues existed in tomcat 8.0, 8.5, and 9.0 with Jasper listener being present.  Remove that listener to use older builds.

## RELEASES ##

Releases are grouped by tomcat version.  Pick the version most appropriate to your usecase.  If you would like a prebuilt version not listed please open an issue.

[tomcat6](https://github.com/tomcat-slf4j-logback/tomcat-slf4j-logback/releases/tag/tomcat6)
[![Maven central](https://maven-badges.herokuapp.com/maven-central/com.github.tomcat-slf4j-logback/tomcat6-slf4j-logback/badge.svg)](https://maven-badges.herokuapp.com/maven-central/com.github.tomcat-slf4j-logback/tomcat6-slf4j-logback)

[tomcat7](https://github.com/tomcat-slf4j-logback/tomcat-slf4j-logback/releases/tag/tomcat7)
[![Maven central](https://maven-badges.herokuapp.com/maven-central/com.github.tomcat-slf4j-logback/tomcat7-slf4j-logback/badge.svg)](https://maven-badges.herokuapp.com/maven-central/com.github.tomcat-slf4j-logback/tomcat7-slf4j-logback)

[tomcat8](https://github.com/tomcat-slf4j-logback/tomcat-slf4j-logback/releases/tag/tomcat8)
[![Maven central](https://maven-badges.herokuapp.com/maven-central/com.github.tomcat-slf4j-logback/tomcat8-slf4j-logback/badge.svg)](https://maven-badges.herokuapp.com/maven-central/com.github.tomcat-slf4j-logback/tomcat8-slf4j-logback)

[tomcat85](https://github.com/tomcat-slf4j-logback/tomcat-slf4j-logback/releases/tag/tomcat85)
[![Maven central](https://maven-badges.herokuapp.com/maven-central/com.github.tomcat-slf4j-logback/tomcat85-slf4j-logback/badge.svg)](https://maven-badges.herokuapp.com/maven-central/com.github.tomcat-slf4j-logback/tomcat85-slf4j-logback)

[tomcat9](https://github.com/tomcat-slf4j-logback/tomcat-slf4j-logback/releases/tag/tomcat9)
[![Maven central](https://maven-badges.herokuapp.com/maven-central/com.github.tomcat-slf4j-logback/tomcat9-slf4j-logback/badge.svg)](https://maven-badges.herokuapp.com/maven-central/com.github.tomcat-slf4j-logback/tomcat9-slf4j-logback)

## Quick Start ##

If you quickly want to configure Tomcat to use Slf4J and Logback, just download latest package available
from github [releases](https://github.com/tomcat-slf4j-logback/tomcat-slf4j-logback/releases)
into $CATALINA_HOME.  Be advised doing so will replace server.xml with default version and logging valve!

Some rather old versions are not predefined for direct exploding into $CATALINA_HOME.  If you would like that changed,
please raise an issue.

The following directions are for manual setup.

After downloading copy as follows:

* `bin/tomcat-juli.jar` to `$CATALINA_HOME/bin` (replacing existing `tomcat-juli.jar`)
* `bin/setenv.sh` or `bin\setenv.bat` to `$CATALINA_HOME/bin` (this script contains proper variable name
and doesn't require any changes, unless you have your own version of `setenv.sh`/`setenv.bat` script)
* `conf/logback.xml` to `$CATALINA_HOME/conf`
* `conf/logback-access.xml` to `$CATALINA_HOME/conf` (older version was called `logback-access-localhost.xml`)
* `conf/server.xml` to `$CATALINA_HOME/conf` (this file contains proper valve and doesn't require any
changes, unless you have your own version of `server.xml`)
* `lib/logback-core-1.1.8.jar` to `$CATALINA_HOME/lib`
* `lib/logback-access-1.1.8.jar` to `$CATALINA_HOME/lib`

Delete `$CATALINA_HOME/conf/logging.properties`. This will turn off `java.util.logging` completely.

`conf/logback.xml` tries to reflect original Tomcat logging configuration. Feel free to change it.

When using your own preconfigured `server.xml`, the following will need applied.

Add (if using legacy `logback-access-localhost.xml`):

    <Valve className="ch.qos.logback.access.tomcat.LogbackValve" quiet="true"
       filename="${catalina.home}/conf/logback-access-localhost.xml" />

    note: if using logback 1.1.7+, the `${catalina.home}` can be removed

Add (if using logback defined naming `logback-access.xml` which allows it to auto discover)

    <Valve className="ch.qos.logback.access.tomcat.LogbackValve" quiet="true" />

to `$CATALINA_HOME/conf/server.xml`.

Remove:

    <Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs"
        prefix="localhost_access_log." suffix=".txt"
        pattern="%h %l %u %t &quot;%r&quot; %s %b" />

from `$CATALINA_HOME/conf/server.xml`.

Final step: run `$CATALINA_HOME/bin/startup.sh` (or `startup.bat`). Voila!

## Git Bash ##

Git Bash in Windows now supports *nix based running.  This was accomplished by removing undocumented logback
setting `file:` from logback.configurationFile.

## Maven Central Distribution ##

Maven central distribution is available.  Zip binaries contain same as github releases.  Below are tomcat-juli jars.

For users to get release, use dependency as follows.

```xml
<dependency>
    <groupId>com.github.tomcat-slf4j-logback</groupId>
    <artifactId>tomcat6-slf4j-logback</artifactId>
	<version>${tomcat.version}</version>
</dependency>
```

```xml
<dependency>
    <groupId>com.github.tomcat-slf4j-logback</groupId>
    <artifactId>tomcat7-slf4j-logback</artifactId>
	<version>${tomcat.version}</version>
</dependency>
```

```xml
<dependency>
    <groupId>com.github.tomcat-slf4j-logback</groupId>
    <artifactId>tomcat8-slf4j-logback</artifactId>
	<version>${tomcat.version}</version>
</dependency>
```

```xml
<dependency>
    <groupId>com.github.tomcat-slf4j-logback</groupId>
    <artifactId>tomcat85-slf4j-logback</artifactId>
	<version>${tomcat.version}</version>
</dependency>
```

```xml
<dependency>
    <groupId>com.github.tomcat-slf4j-logback</groupId>
    <artifactId>tomcat9-slf4j-logback</artifactId>
	<version>${tomcat.version}</version>
</dependency>
```

The tomcat-slfj4-logback binary must be renamed as tomcat-juli to use within a tomcat build.

## Site Page ##

Site page is located [here](https://tomcat-slf4j-logback.github.io/tomcat-slf4j-logback/)

## Details ##

This project allows using SLF4J and Logback in Apache Tomcat absolutely without the need for commons-
logging, log4j, and java.util.logging.

This project's main and only goal is to allow the following:

* redirect all `org.apache.commons.logging` (repackaged to `org.apache.juli.logging`) calls to `org.slf4j`
  (repackaged to `org.apache.juli.logging.org.slf4j`) - i.e. handle internal tomcat logging with slf4j and
  logback binding,
* make still possible to use logback-access with `logback-access.xml` config - using standard functionality
  of logback-access,
* make possible to use independent configuration of slf4j+logback from all web applications which may carry
  their own slf4j-api, logback-core, and logback-classic in their `WEB-INF/lib` directory.

Using only Mavens `pom.xml` file, proper source JARs are downloaded from maven repository and unpacked.
Then all classes are refactored under `org.apache.juli.logging` package/subpackages and then compiled.

To allow web applications to use their own slf4j-api and logback-classic, classes used by Tomcat (particularly
jcl-over-slf4j) must go into different, non-standard packages. According to 
[Tomcat Documentation](https://tomcat.apache.org/tomcat-7.0-doc/class-loader-howto.html#Class_Loader_Definitions)
web application looks up classes in their `WEB-INF/classes` directory and `WEB-INF/lib/*.jar` files before looking
them in `$CATALINA_HOME/lib`, but **after** looking them in _system class loader_. So Tomcat needs only to
have `tomcat-juli` replaced with versions of `jcl-over-slf4j`, `slf4j-api`, `logback-core`, and `logback-classic`
refactored into different packages.

Finally, in order to keep the classpath clean, I've chosen the method of selecting Logback's configuration file
using `juli-logback.configurationFile` system property. It is renamed in source files during _refactoring_
phase. Leaving standard `logback.configurationFile` property would cause selecting this file in all web
applications despite of having dedicated, classpath-based `logback.xml` configuration files.

There are four JARs involved in the process transformed into `org.apache.juli.logging` exactly the same way
as commons-logging is transformed in Tomcat's build process. It is eventually compiled into `tomcat-juli.jar`
 - `tomcat-juli` is mandatory, because it is directly referenced during Tomcat's startup process while
   constructing _system class loader_. This JAR is transformed and placed in
   `$CATALINA_HOME/bin/tomcat-juli.jar` file.:

* `jcl-over-slf4j` - commons logging over SLF4J JAR.
* `slf4j-api` - main SLF4J JAR.
* `logback-core` - core Logback JAR.
* `logback-classic` - actual SLF4J binding JAR.

Prior builds of this project contained 4 separate jars where tomcat-juli noted these in the manifest in
order to avoid further touching of tomcat configuration files for security purposes.  Current build 
results in a single tomcat-juli file and thus no longer requires this.

## Installation ##

Launching the build requires Maven install - everything will be downloaded upon build.

Type:

    mvn clean install

Tomcat versions for 6, 7, 8, 8.5, and 9 will build.  Specifically for tomcat 6, it will only use Logback below version 1.0.0!

And move tomcat-juli JAR for your tomcat version from `target` directory to `$CATALINA_HOME/bin` directory.

More detailed instruction:

1. edit file `pom.xml` to update tomcat/slf4j/logback dependencies
2. run `mvn clean install` to build jar, javadoc, and source
3. run `mvn site` to generate site page
4. move `tomcat-juli.jar` from `target` directory to `$CATALINA_HOME/bin`.

After changing versions (e.g. for Tomcat), run `mvn clean install`.

Running Tomcat now will use default (very verbose) configuration of Logback. To change Logback's
configuration, run Tomcat with the following system variable (using your favorite method of setting such
variables - in `catalina.sh`, `setenv.sh` or other):

    -Djuli-logback.configurationFile=file:<logback.xml location>

Alternative to allow git bash, remove the `file:` marker.  This works on newer tomcat versions but has not been
tested on older copies.  It works using the bat or sh in this mode.
	
	-Djuli-logback.configurationFile=<logback.xml location>

## Configuration ##

Now you can configure whatever logging technology you want for your web applications. I recommend SLF4J
and Logback because from now on, it will not collide with Tomcat's logging configuration.

While configuring Tomcat's logging, keep in mind that you have to use renamed packages in `logback.xml`
config file, e.g.:

    <configuration>
        <appender name="CONSOLE" class="org.apache.juli.logging.ch.qos.logback.core.ConsoleAppender">
            <encoder>
                <pattern>%d{HH:mm:ss.SSS} %-5level {%thread} [%logger{20}] : %msg%n</pattern>
            </encoder>
        </appender>
        <logger name="org.apache.catalina.core.ContainerBase.[Catalina].[localhost]" level="INFO"
                additivity="false">
            <appender-ref ref="FILE-LOCALHOST" />
        </logger>
        <root level="INFO">
            <appender-ref ref="CONSOLE" />
        </root>
    </configuration>

Configuration of logback-access doesn't require renamed packages, as the required JARs are loaded from
_common class loader_.

Sample `logback.xml` reflecting the configuration from standard `$CATALINA_HOME/conf/logging.properties`
can be found in conf/logback.xml from github [releases] (https://github.com/tomcat-slf4j-logback/tomcat-slf4j-logback/releases).


## Tomcat Customization ##

#### Tomcat 6.0.x 7.0.x 8.0.x 8.5.x 9.0.x ####

After unpacking `apache-tomcat-6.0.x.zip`, `apache-tomcat-7.0.x.zip`, `apache-tomcat-8.0.x.zip`, `apache-tomcat-8.5.x.zip`
or `apache-tomcat-9.0.x.zip` one can run Tomcat by executing `$CATALINA_HOME/bin/startup.sh`. This will cause running
Tomcat with standard java.util.logging enabled. The standard commandline is:

    "java" \
        -Djava.util.logging.config.file="$CATALINA_HOME/conf/logging.properties"
        -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager
        -Djava.endorsed.dirs="$CATALINA_HOME/endorsed"
        -classpath "$CATALINA_HOME\bin\bootstrap.jar"
        -Dcatalina.base="$CATALINA_HOME"
        -Dcatalina.home="$CATALINA_HOME"
        -Djava.io.tmpdir="$CATALINA_HOME"
        org.apache.catalina.startup.Bootstrap start

Deleting `$CATALINA_HOME/conf/logging.properties` will replace `-Djava.util.logging.config.file` with
`-Dnop`.

Finally we must configure our tomcat-slf4j-logback integration:

* place our tomcat-juli JAR in `$CATALINA_HOME/bin`
* add `-Djuli-logback.configurationFile=<logback.xml location>` to `$JAVA_OPTS` in `setenv.sh`
* if the above add does not work, add `file:` before `<logback.xml location>`

Now Tomcat's internal logging goes through `org.apache.juli.logging.org.slf4j` and 
`org.apache.juli.logging.ch.qos.logback` to appenders configured in `$CATALINA_HOME/conf/logback.xml` (or
whatever file you set `juli-logback.configurationFile` variable to).

The final step is to configure `logback-access`. Now we don't have to deal with package manipulation. Just add:

Add (if using legacy `logback-access-localhost.xml`):

    <Valve className="ch.qos.logback.access.tomcat.LogbackValve" quiet="true"
        filename="${catalina.home}/conf/logback-access-localhost.xml" />

	note: if using logback 1.1.7+, the `${catalina.home}` can be removed

Add (if using logback defined naming `logback-access.xml` which allows it to auto discover)

    <Valve className="ch.qos.logback.access.tomcat.LogbackValve" quiet="true" />
		
to `$CATALINA_HOME/conf/server.xml`, place properly configured `logback-access-localhost.xml` on
`$CATALINA_HOME/conf` and place `logback-core` and `logback-access` JARs into `$CATALINA_HOME/lib`. This
won't cause problems with individual WARs' slf4j+logback configuration, because `logback.xml` is read by
`logback-classic` which is recommended to reside in `WEB-INF/lib`. The only additional benefit is that WARs
will see `logback-core` through _common class loader_.

## Using Tomcat in Eclipse ##

1. Go to Window › Preferences › Server › Runtime Environments and add your server runtime as always
1. Go to Servers view and add server instance as always
1. Open server definition (RMB, Open or `F3`) and click <u>open launch configuration</u>
1. On _Arguments_ tab in _VM arguments_ add
    `-Djuli-logback.configurationFile="<absolute tomcat home path>/conf/logback.xml"`

That's all. While creating server runtime instance, eclipse generates VM arguments using absolute paths (no
variables), so just copy the Tomcat home path and add `-Djuli-logback.configurationFile` argument.

Remember - Tomcat installation must be configured according to **Quick Start**.

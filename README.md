# Tomcat + SLF4J + Logback #

[![Download tomcat-slf4j-logback](https://img.shields.io/sourceforge/dw/tc-slf4jlogback.svg)](https://sourceforge.net/projects/tc-slf4jlogback/files/latest/download)
[![Build Status](https://travis-ci.org/hazendaz/tomcat-slf4j-logback.svg?branch=master)](https://travis-ci.org/hazendaz/tomcat-slf4j-logback)
[![Dependency Status](https://www.versioneye.com/user/projects/55ff4f0b601dd9001f000142/badge.svg?style=flat)](https://www.versioneye.com/user/projects/55ff4f0b601dd9001f000142)

## NOTICE ##

Build pom is configured to allow for building out the tomcat embedded juli version but as of 11/14/2014 has not be tested.  Please feel
free to test this functionality and report back.

## Quick Start ##

If you quickly want to configure Tomcat to use Slf4J and Logback, just download latest package available
from [SourceForge](https://sourceforge.net/projects/tc-slf4jlogback/files/) and explode zip file directly
into $CATALINA_HOME.  Beware! - doing so will replace server.xml with default version and logging valve.

Previous versions are available and may be downloaded from [SourceForge](https://sourceforge.net/projects/tc-slf4jlogback/files/)

New versions are available and may be downloaded from github [releases](https://github.com/grgrzybek/tomcat-slf4j-logback/releases)

Some rather old versions are not predefined for direct exploding into $CATALINA_HOME.

The following directions are for manual setup.

After downloading copy as follows:

* `bin/tomcat-juli.jar` to `$CATALINA_HOME/bin` (replacing existing `tomcat-juli.jar`)
* `bin/setenv.sh` or `bin\setenv.bat` to `$CATALINA_HOME/bin` (this script contains proper variable name
and doesn't require any changes, unless you have your own version of `setenv.sh`/`setenv.bat` script)
* `conf/logback*.xml` to `$CATALINA_HOME/conf`
* `conf/server.xml` to `$CATALINA_HOME/conf` (this file contains proper valve and doesn't require any
changes, unless you have your own version of `server.xml`)
* `lib/logback-core-1.1.7.jar` to `$CATALINA_HOME/lib`
* `lib/logback-access-1.1.7.jar` to `$CATALINA_HOME/lib`

Delete `$CATALINA_HOME/conf/logging.properties`. This will turn off `java.util.logging` completely.

`conf/logback.xml` tries to reflect original Tomcat logging configuration. Feel free to change it.

When using your own preconfigured `server.xml`, the following will need applied.

Add:

    <Valve className="ch.qos.logback.access.tomcat.LogbackValve" quiet="true"
       filename="${catalina.home}/conf/logback-access-localhost.xml" />

to `$CATALINA_HOME/conf/server.xml`.

Remove:

    <Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs"
        prefix="localhost_access_log." suffix=".txt"
        pattern="%h %l %u %t &quot;%r&quot; %s %b" />

from `$CATALINA_HOME/conf/server.xml`.

Final step: run `$CATALINA_HOME/bin/startup.sh` (or `startup.bat`). Voila!

## Maven Central Distribution ##

Maven central distribution is primarily for users building tomcat distributions.

For developers to release, source jar and zip need deleted on distribution before release can proceed.

For users to get release, use dependency as follows.

```xml
<dependency>
    <groupId>com.github.grgrzybek</groupId>
    <artifactId>tomcat-slf4j-logback</artifactId>
	<version>${tomcat.version}</artifactId>
</dependency>
```

The tomcat-slfj4-logback binary must be renamed as tomcat-juli to use within a tomcat build.

## Site Page ##

Site page is located [here](http://grgrzybek.github.io/tomcat-slf4j-logback/)

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
[Tomcat Documentation](http://tomcat.apache.org/tomcat-7.0-doc/class-loader-howto.html#Class_Loader_Definitions)
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

* *jcl-over-slf4j* - commons logging over SLF4J JAR.
* *slf4j-api* - main SLF4J JAR.
* *logback-core* - core Logback JAR.
* *logback-classic* - actual SLF4J binding JAR.

Prior builds of this project contained 4 separate jars where tomcat-juli noted these in the manifest in
order to avoid further touching of tomcat configuration files for security purposes.  Current build 
results in a single tomcat-juli file and thus no longer requires this.

## Installation ##

Launching the build requires Maven install - everything will be downloaded upon build.

Type:

    mvn clean install

If you want to do a build for different Tomcat versions (Tomcat 7 and above), just append
`-Dtomcat.version=x.x.x` option.

If you want to build for Tomcat 6 (only Logback versions below 1.0.0!), type:

    mvn clean install -Ptomcat6 -P-tomcat7+

And move tomcat-juli JAR from `target` directory to `$CATALINA_HOME/bin` directory.

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
can be found in conf/logback.xml from github [releases] (https://github.com/grgrzybek/tomcat-slf4j-logback/releases).


## Tomcat Customization ##

#### Tomcat 6.0.x 7.0.x 8.0.x 8.5.x 9.0.x ####

After unpacking `apache-tomcat-6.0.x.tgz`, `apache-tomcat-7.0.x.tgz`, `apache-tomcat-8.0.x.tgz`, `apache-tomcat-8.5.x.tgz`
or `apache-tomcat-9.0.x.tgz` one can run Tomcat by executing `$CATALINA_HOME/bin/startup.sh`. This will cause running
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
* add `-Djuli-logback.configurationFile=file:<logback.xml location>` to `$JAVA_OPTS` in `setenv.sh`

Now Tomcat's internal logging goes through `org.apache.juli.logging.org.slf4j` and 
`org.apache.juli.logging.ch.qos.logback` to appenders configured in `$CATALINA_HOME/conf/logback.xml` (or
whatever file you set `juli-logback.configurationFile` variable to).

The final step is to configure `logback-access`. Now we don't have to deal with package manipulation. Just add:

    <Valve className="ch.qos.logback.access.tomcat.LogbackValve" quiet="true"
        filename="${catalina.home}/conf/logback-access-localhost.xml" />

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

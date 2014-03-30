# Tomcat + SLF4J + Logback #

## Notice ##

The current ant/ivy build will soon be replaced with a maven build.  A maven branch currently
exists and is ready for user feedback.  The build time is rather quick.  One major change 
will be occurring with this.  Currently this project requires 4 jars to be placed
into tomcat/bin directory.  Once the maven build is merged into master, it will
simply contain a single shaded jar file for tomcat-juli containing all that everyone is
familiar with.  No other changes are necessary.

Additionally, sourceforge builds have not been updated recently.  Grzegorz has been quite
busy and I have picked up building out this conversion to maven.  We hope to have this
resolved shortly.  In the meantime, feel free to pull down the maven branch and give it
a try.

Additionally, as it has been raised multiple times, there are no current plans to move
this to maven central.  However, that might be an option for those that want to run
embedded tomcat.  This will be determined at a later time.

## Quick Start ##

If you quickly want to configure Tomcat to use Slf4J and Logback, just download
one of the packages available from [this
location](https://sourceforge.net/projects/tc-slf4jlogback/files/).

The latest version (Tomcat 7.0.50, Slf4j 1.7.5, Logback 1.1.0) may be
downloaded from
[SourceForge](https://sourceforge.net/projects/tc-slf4jlogback/files/).

After downloading copy (from the archive):

* `bin/*.jar` to `$CATALINA_HOME/bin` (replacing existing `tomcat-juli.jar`)
* `bin/setenv.sh` or `bin\setenv.bat` to `$CATALINA_HOME/bin` (this script
  contains proper variable name and doesn't require any changes, unless you have
  your own version of `setenv.sh`/`setenv.bat` script)
* `conf/logback*.xml` to `$CATALINA_HOME/conf`

Copy (from e.g. Maven Central or [logback
site](http://logback.qos.ch/download.html)):

* `logback-core-1.1.0.jar` to `$CATALINA_HOME/lib`
* `logback-access-1.1.0.jar` to `$CATALINA_HOME/lib`

Delete `$CATALINA_HOME/conf/logging.properties`. This will turn off
`java.util.logging` completely.

`conf/logback.xml` tries to reflect original Tomcat logging configuration. Feel
free to change it.

Add:

	<Valve className="ch.qos.logback.access.tomcat.LogbackValve" quiet="true" filename="${catalina.home}/conf/logback-access-localhost.xml" />

to `$CATALINA_HOME\conf\server.xml`.

Remove:

	<Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs"
		prefix="localhost_access_log." suffix=".txt"
		pattern="%h %l %u %t &quot;%r&quot; %s %b" />

from `$CATALINA_HOME\conf\server.xml`.

Final step: run `$CATALINA_HOME/bin/startup.sh` (or `startup.bat`). Voila!

## Introduction ##

This project allows using SLF4J and Logback in Apache Tomcat absolutely without
the need for commons-logging, log4j and java.util.logging.

This project's main and only goal is to allow the following:

* redirect all `org.apache.commons.logging` (repackaged to
  `org.apache.juli.logging`) calls to `org.slf4j` (repackaged to
  `org.apache.juli.logging.org.slf4j`) - i.e. handle internal tomcat logging
  with slf4j and logback binding,
* make still possible to use logback-access with `logback-access.xml` config -
  using standard functionality of logback-access,
* make possible to use independent configuration of slf4j+logback from all web
  applications which may carry their own slf4j-api, logback-core and
  logback-classic in their `WEB-INF/lib` directory.

Using only ANT's `build.xml` file (based on the file provided with Tomcat),
proper source JARs are downloaded from maven repository and unpacked. Then all
classes are refactored under `org.apache.juli.logging` package, subpackages and
then compiled.

To allow web applications to use their own slf4j-api and logback-classic,
classes used by Tomcat (particularly jcl-over-slf4j) must go into different,
non-standard packages. According to [Tomcat
Documentation](http://tomcat.apache.org/tomcat-7.0-doc/class-loader-howto.html#Class_Loader_Definitions)
web application looks up classes in their `WEB-INF/classes` directory and
`WEB-INF/lib/*.jar` files before looking them in `$CATALINA_HOME/lib`, but
**after** looking them in _system class loader_. So Tomcat needs not only to
have tomcat-juli replaced with tweaked jcl-over-slf4j but also the remaining
JARs (slf4j-api, logback-core and logback-classic) must be refactored into
different packages. Also, to put the three remaining JARs under Tomcat's _system
class loader_, they must be referenced from `tomcat-juli.jar` using
`META-INF/MANIFEST.MF`'s `Class-Path` mechanism.

Finally, in order to keep the classpath clean, I've chosen the method of
selecting Logback's configuration file using `juli-logback.configurationFile`
system property. It is renamed in source files during _refactoring_ phase.
Leaving standard `logback.configurationFile` property would cause selecting this
file in all web applications despite of having dedicated, classpath-based
`logback.xml` configuration files.

There are four JARs involved in the process:

* *jcl-over-slf4j* - this JAR is transformed into `org.apache.juli.logging`
  exactly the same way as commons-logging is transformed in Tomcat's build
  process. It is eventually compiled into `tomcat-juli.jar` - this name is
  mandatory, because it is directly referenced during Tomcat's startup process
  while constructing _system class loader_. This JAR is transformed and placed
  in `$CATALINA_HOME/bin/tomcat-juli.jar` file.
* *slf4j-api* - main SLF4J JAR. Transformed into
  `$CATALINA_HOME/bin/tomcat-juli-slf4j-api-<version>.jar` file.
* *logback-core* - core Logback JAR. Transformed into
  `$CATALINA_HOME/bin/tomcat-juli-logback-core-<version>.jar` file.
* *logback-classic* - actual SLF4J binding. Transformed into
  `$CATALINA_HOME/bin/tomcat-juli-logback-classic-<version>.jar` file.


## Installation ##

Launching the build doesn't require installed Ivy anymore - everything will be
downloaded upon build. Also proper `tomcat-juli.jar` version will be downloaded
from Maven Central.

Type:

	ant

And move four JARs from `_dist` directory to `$CATALINA_HOME/bin` directory.

More detailed instruction:

1. edit file `build.properties`, which may contain custom values for properties
	hardcoded in `build.properties.default`. e.g. `tomcat.version`
2. run `ant`
5. move JARs from `_dist` directory to `$CATALINA_HOME/bin`.

After changing versions (e.g. for Tomcat), run `ant clean`.

Running Tomcat now will use default (very verbose) configuration of Logback. To
change Logback's configuration, run Tomcat with the following system variable
(using your favorite method of setting such variables - in `catalina.sh`,
`setenv.sh` or other):

	-Djuli-logback.configurationFile=file:<logback.xml location>


## Configuration ##

Now you can configure whatever logging technology you want for your web
applications. I recommend SLF4J and Logback because from now on, it will not
collide with Tomcat's logging configuration.

While configuring Tomcat's logging, keep in mind that you have to use renamed
packages in `logback.xml` config file, e.g.:

	<configuration>
		<appender name="CONSOLE" class="org.apache.juli.logging.ch.qos.logback.core.ConsoleAppender">
			<encoder>
				<pattern>%d{HH:mm:ss.SSS} %-5level {%thread} [%logger{20}] : %msg%n</pattern>
			</encoder>
		</appender>
		<logger name="org.apache.catalina.core.ContainerBase.[Catalina].[localhost]" level="INFO" additivity="false">
			<appender-ref ref="FILE-LOCALHOST" />
		</logger>
		<root level="INFO">
			<appender-ref ref="CONSOLE" />
		</root>
	</configuration>

Configuration of logback-access doesn't require renamed packages, as the
required JARs are loaded from _common class loader_.

Sample `logback.xml` reflecting the configuration from standard
`$CATALINA_HOME/conf/logging.properties` can be found
[here](https://github.com/grgrzybek/tomcat-slf4j-logback/blob/master/sample/tomcat-logback.xml).


## Tomcat Customization ##

#### Tomcat 6.0.x ####

After unpacking `apache-tomcat-6.0.x.tgz`, one can run Tomcat by executing
`$CATALINA_HOME/bin/startup.sh`. This will cause running Tomcat with standard
java.util.logging enabled. The standard commandline is:

	"java" \
		-Djava.util.logging.config.file="$CATALINA_HOME/conf/logging.properties"
		-Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager
		-Djava.endorsed.dirs="$CATALINA_HOME/endorsed"
		-classpath "$CATALINA_HOME\bin\bootstrap.jar"
		-Dcatalina.base="$CATALINA_HOME"
		-Dcatalina.home="$CATALINA_HOME"
		-Djava.io.tmpdir="$CATALINA_HOME"
		org.apache.catalina.startup.Bootstrap start

Deleting `$CATALINA_HOME/conf/logging.properties` will replace
`-Djava.util.logging.config.file` with `-Dnop` - first step to remove
`j.u.logging`. To get rid of `-Djava.util.logging.manager` we must explicitely set
the following environment property in setenv.sh:

	LOGGING_MANAGER=-Dnop

Finally we must configure our tomcat-slf4j-logback integration:

* place all 4 JARs in `$CATALINA_HOME/bin`
* add `-Djuli-logback.configurationFile=file:<logback.xml location>` to
  `$JAVA_OPTS` in `setenv.sh`

Now Tomcat's internal logging goes through `org.apache.juli.logging.org.slf4j`
and `org.apache.juli.logging.ch.qos.logback` to appenders configured in
`$CATALINA_HOME/conf/logback.xml` (or whatever file you set
`juli-logback.configurationFile` variable to).

The final step is to configure `logback-access`. Now we don't have to deal with
package manipulation. Just add:

	<Valve className="ch.qos.logback.access.tomcat.LogbackValve" quiet="true"
		filename="${catalina.home}/conf/logback-access-localhost.xml" />

to `$CATALINA_HOME/conf/server.xml`, place properly configured
`logback-access-localhost.xml` on `$CATALINA_HOME/conf` and place `logback-core`
and `logback-access` JARs into `$CATALINA_HOME/lib`. This won't cause problems
with individual WARs' slf4j+logback configuration, because `logback.xml` is read
by `logback-classic` which is recommended to reside in `WEB-INF/lib`. The only
additional benefit is that WARs will see `logback-core` through _common class
loader_.

#### Tomcat 7.0.x ####

With logback-1.0.0 the LBACCESS-17 is finally resolved, so there's no need to
fix anything in logback-access :).


## Using Tomcat in Eclipse ##

1. Go to Window › Preferences › Server › Runtime Environments and add your
	server runtime as always
1. Go to Servers view and add server instance as always
1. Open server definition (RMB, Open or `F3`) and click <u>open launch
	configuration</u>
1. On _Arguments_ tab in _VM arguments_ add
	`-Djuli-logback.configurationFile="<absolute tomcat home
	path>\conf\logback.xml"`

That's all. While creating server runtime instance, eclipse generates VM
arguments using absolute paths (no variables), so just copy the Tomcat home path
and add `-Djuli-logback.configurationFile` argument. There's no need to
configure `LOGGING_MANAGER=-Dnop` environment variable (I'm not quite sure
why...).

Remember - Tomcat installation must be configured according to **Quick Start**.

# Tomcat + SLF4J + Logback #

## Introduction ##

This project allows using SLF4J and Logback in Apache Tomcat absolutely without
the need for commons-logging, log4j and java.util.logging.

This project's main and only goal is to allow the following:

* redirect all `org.apache.commons.logging` (repackaged to
  `org.apache.juli.logging`) calls to `org.slf4j` (repackaged to
  `org.apache.juli.logging.org.slf4j`) - i.e. handle internal tomcat logging
  with slf4j with logback binding
* make still possible to use logback-access with `logback-access.xml` config -
  using standard functionality of logback-access
* make possible to use independent configuration of slf4j+logback from all web
  applications which may carry their own slf4j-api, logback-core and
  logback-classic in `WEB-INF/lib` directory

Using only ANT's `build.xml` file (based on the file provided with Tomcat),
proper source JARs are downloaded from maven repository and unpacked. Then all
classes are refactored under `org.apache.juli.logging` package and then
compiled.

To allow web applications to use their own slf4j-api and logback-classic,
classes used by Tomcat (particularly jcl-over-slf4j) must go into different,
non-standard packages. According to [Tomcat
Documentation](http://tomcat.apache.org/tomcat-7.0-doc/class-loader-howto.html#Class_Loader_Definitions)
web application looks up classes in their `WEB-INF/classes` directory and
`WEB-INF/lib/*.jar` files before looking them in `$TOMCAT_HOME/lib`, but after
looking them in _system class loader_. So Tomcat needs not only to have
tomcat-juli replaced with tweaked jcl-over-slf4j but also the remaining JARs
(slf4j-api, logback-core and logback-access). Also, to put the three remaining
JARs under Tomcat's _system class loader_, they must be referenced from
`tomcat-juli.jar` using `META-INF/MANIFEST.MF`'s `Class-Path` mechanism.

Finally, in order to keep the classpath clean, I've chosen the method of
selecting Logback's configuration file using 1juli-logback.configurationFile1
system property. It is renamed in source files during _refactoring_
phase. Leaving standard `logback.configurationFile` property would cause using
this file in all web applications despite of having dedicated, classpath-based
`logback.xml` configuration files.

There are four JARs involved in the process:

* *jcl-over-slf4j* - this JAR is transformed into `org.apache.juli.logging`
  exactly the same way as commons-logging is transformed in Tomcat's build
  process. It is eventually compiled into `tomcat-juli.jar` - this name is
  mandatory, because it is directly referenced during Tomcat's startup process
  while constructing _system class loader_. This JAR is transformed and placed
  in `$TOMCAT_HOME/bin/tomcat-juli.jar` file.
* *slf4j-api* - main SLF4J JAR. Transformed into
  `$TOMCAT_HOME/bin/tomcat-juli-slf4j-api-<version>.jar` file.
* *logback-core* - core Logback JAR. Transformed into
  `$TOMCAT_HOME/bin/tomcat-juli-logback-core-<version>.jar` file.
* *logback-classic* - actual SLF4J binding. Transformed into
  `$TOMCAT_HOME/bin/tomcat-juli-logback-classic-<version>.jar` file.


## Installation ##

Before launching the build, place JMS API jar in `_external` directory, as this
JAR is not redistributed in Maven/Ivy repositories (do we still live in XX
century?).

Type:

	ant

And move four JARs from `_dist` directory to `$TOMCAT_HOME/bin` directory.

Running Tomcat now will use default (very verbose) configuration of
Logback. To change Logback's configuration, run Tomcat with the
following system variable (using your favorite method of setting such
variables - in `catalina.sh`, `setenv.sh` or other):

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
`$TOMCAT_HOME/conf/logging.properties` can be found
[here](https://github.com/grgrzybek/tomcat-slf4j-logback/blob/master/sample/tomcat-logback.xml).


## Tomcat Customization ##

#### Tomcat 6.0.x ####

After unpacking apache-tomcat-6.0.29.zip, one can run Tomcat by executing
`$TOMCAT_HOME/bin/startup.sh`. This will cause running Tomcat with standard
java.util.logging enabled. The standard commandline (on Windows) is:

	"C:\Dev\Java\javase\jdk1.6.0_22\bin\java" \
		-Djava.util.logging.config.file="c:\Dev\Java\servers\apache-tomcat-6.0.29\conf\logging.properties"
		-Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager
		-Djava.endorsed.dirs="c:\Dev\Java\servers\apache-tomcat-6.0.29\endorsed"
		-classpath "c:\Dev\Java\servers\apache-tomcat-6.0.29\bin\bootstrap.jar"
		-Dcatalina.base="c:\Dev\Java\servers\apache-tomcat-6.0.29"
		-Dcatalina.home="c:\Dev\Java\servers\apache-tomcat-6.0.29"
		-Djava.io.tmpdir="c:\Dev\Java\servers\apache-tomcat-6.0.29\temp"
		org.apache.catalina.startup.Bootstrap  start

Deleting `$TOMCAT_HOME/conf/logging.properties` will replace
`-Djava.util.logging.config.file` with `-Dnop` - first step to remove
j.u.logging. To get rid of `-Djava.util.logging.manager` we must explicitely set
the following environment property in setenv.sh:

	LOGGING_MANAGER=-Dnop

Finally we must configure our tomcat-slf4j-logback integration:

* place all 4 JAR in `$TOMCAT_HOME/bin`
* add `-Djuli-logback.configurationFile=file:<logback.xml location>` to
  `$JAVA_OPTS` in `setenv.sh`

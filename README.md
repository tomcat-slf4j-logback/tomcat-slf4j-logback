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
web application looks up classes in their WEB-INF/classes and WEB-INF/lib/*.jar
before looking them in $TOMCAT_HOME/lib, but after looking them in "system"
class loader. So Tomcat needs not only to have tomcat-juli replaced with tweaked
jcl-over-slf4j but also the remaining JARs (slf4j-api, logback-core and
logback-access). Also, to put the three remaining JARs under Tomcat's "system"
class loader, they must be referenced from "tomcat-juli.jar" using
META-INF/MANIFEST.MF's Class-Path mechanism.

Finally, in order to keep the classpath clean, I've chosen the method of
selecting Logback's configuration file using "juli-logback.configurationFile"
system property. It is renamed in source files during "refactoring"
phase. Leaving standard "logback.configurationFile" property would cause using
this file in all web applications despite of having dedicated, classpath-based
logback.xml configuration files.

There are four JARs involved in the process:
 * jcl-over-slf4j - this JAR is transformed into org.apache.juli.logging exactly
   the same way as commons-logging is transformed in Tomcat's build process. It
   is eventually compiled into tomcat-juli.jar - this name is mandatory, because
   it is directly referenced during Tomcat's startup process while constructing
   "system" class loader. This JAR is transformed and placed in
   $TOMCAT_HOME/bin/tomcat-juli.jar file.
 * slf4j-api - main SLF4J JAR. Transformed into
   $TOMCAT_HOME/bin/tomcat-juli-slf4j-api-<version>.jar file.
 * logback-core - core Logback JAR. Transformed into
   $TOMCAT_HOME/bin/tomcat-juli-logback-core-<version>.jar file.
 * logback-classic - actual SLF4J binding. Transformed into
   tomcat-juli-logback-classic-<version>.jar file.


INSTALLATION

Before launching the build, place JMS API jar in _external directory, as this
JAR is not redistributed in Maven/Ivy repositories (do we still live in XX
century?).

Type:
	$ ant

And move four JARs from _dist directory to $TOMCAT_HOME/bin directory.

Running Tomcat now will use default (very verbose) configuration of
Logback. To change Logback's configuration, run Tomcat with the
following system variable (using your favorite method of setting such
variables - in catalina.sh, setenv.sh or other):
	-Djuli-logback.configurationFile=file:<logback.xml location>
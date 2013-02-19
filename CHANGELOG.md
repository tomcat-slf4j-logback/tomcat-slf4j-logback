Next Release
============

Misc
----
* [#15](https://github.com/grgrzybek/tomcat-slf4j-logback/pull/8): Ivy and Third Party Updates - [@hazendaz](https://github.com/hazendaz).
  * Updated all third party jars to latest
  * Reworked ivy layout to not copy local from cache - simply use cache for all items

* [#14](https://github.com/grgrzybek/tomcat-slf4j-logback/pull/14): Parametrization of ivy*.xml - (@grgrzybek](https://github.com/grgrzybek).

* [#12](https://github.com/grgrzybek/tomcat-slf4j-logback/pull/12): Updated Tomcat and Groovy - [@hazendaz](https://github.com/hazendaz).

* [#12](https://github.com/grgrzybek/tomcat-slf4j-logback/pull/10): Updated slf4j and Groovy - [@hazendaz](https://github.com/hazendaz).

* [#8](https://github.com/grgrzybek/tomcat-slf4j-logback/pull/8): Minor Corrections - [@hazendaz](https://github.com/hazendaz).

* [#7](https://github.com/grgrzybek/tomcat-slf4j-logback/pull/7): Slf4j & Ivy Updates - [@hazendaz](https://github.com/hazendaz).
  * Source artifacts are no longer downloaded from explicit Maven repository. They're Ivy dependencies.

* [#6](https://github.com/grgrzybek/tomcat-slf4j-logback/pull/6): Tomcat / Servlet Update - [@hazendaz](https://github.com/hazendaz).

* [#5](https://github.com/grgrzybek/tomcat-slf4j-logback/pull/5): Ivy Enhancement, Logback and Janino Upgrade - [@hazendaz](https://github.com/hazendaz).
  * Ivy is no longer a manual dependency to build

* [#4](https://github.com/grgrzybek/tomcat-slf4j-logback/pull/4): Line ending normalization - [@hazendaz](https://github.com/hazendaz).

* [#3](https://github.com/grgrzybek/tomcat-slf4j-logback/pull/3): refactor logback.ContextSelector to juli-logback.ContextSelector - [@dretzlaff](https://github.com/dretzlaff).

* [#2](https://github.com/grgrzybek/tomcat-slf4j-logback/pull/2): Tomcat Update - [@hazendaz](https://github.com/hazendaz).
  * Added CHANGELOG.md
  * Updated slf4j to 1.6.6
  * Updated logback to 1.0.6
  * Updated tomcat to 7.0.29
  * Changed java target to 1.6 as this targets java 6 due to tomcat / logback
  * Updated dependency javax.mail to 1.4.5
  * Updated dependency janino to 2.5.16
  * Updated dependency groovy to 2.0.0
  * Modified tomcat juli inclusion changes from [@arnou](https://github.com/arnou)

* [#1](https://github.com/grgrzybek/tomcat-slf4j-logback/issues/1): Include tomcat-juli.jar in external - (@grgrzybek](https://github.com/grgrzybek).
Notable Changes
---------------
* [#124](https://github.com/grgrgzybek/tomcat-slf4j-logback/pull/124): Correct server.xml per version [@hazendaz]

* [#120](https://github.com/grgrgzybek/tomcat-slf4j-logback/pull/120): Multi-module revamp [@hazendaz]

* [#111](https://github.com/grgrgzybek/tomcat-slf4j-logback/pull/111): Better sonatype support [@hazendaz]

* [#108](https://github.com/grgrgzybek/tomcat-slf4j-logback/pull/108): Revamp logback support [@hazendaz]

* [#107](https://github.com/grgrgzybek/tomcat-slf4j-logback/pull/107): Drop sourceforce [@hazendaz]

* [#73](https://github.com/grgrgzybek/tomcat-slf4j-logback/pull/73): Add versioneye [@hazendaz]

* [#62](https://github.com/grgrzybek/tomcat-slf4j-logback/pull/62): Aligning to maven central [@hazendaz]

* [#57](https://github.com/grgrzybek/tomcat-slf4j-logback/pull/57): Embedded breakout [@hazendaz](https://github.com/hazendaz).
  * Embedded support was listed mixed throughout and commented out.  Now it is a profile as 'embedded'

* [#53](https://github.com/grgrzybek/tomcat-slf4j-logback/pull/53): Cleanup build / support embedded [@hazendaz]

* [#48](https://github.com/grgrzybek/tomcat-slf4j-logback/pull/48): Added travis-ci [@hazendaz]

* [#33](https://github.com/grgrzybek/tomcat-slf4j-logback/pull/33): Merged Maven to Master [@hazendaz](https://github.com/hazendaz).
  * Maven build merged to master removing prior ant/ivy build

* [#32](https://github.com/grgrzybek/tomcat-slf4j-logback/pull/32): GitHub Site Pages [@hazendaz](https://github.com/hazendaz).
  * Added GitHub Site Pages

* [#30](https://github.com/grgrzybek/tomcat-slf4j-logback/pull/30): Maven Shade Plugin [@hazendaz](https://github.com/hazendaz).
  * Corrected POM order of assembly & shade plugin as order matters to generate assembly
  * Modified assembly to include source & jar in separate folders
  * Added enforcer plugin to enforce use of maven 3
  * Added git plugins
  * Added more information to manifest

* [#29](https://github.com/grgrzybek/tomcat-slf4j-logback/pull/29): Maven Shade Plugin [@hazendaz](https://github.com/hazendaz).
  * Switched to maven shade plugin due to null issues with jarjar
  * Added all licenses to jar build
  * Restored source generation
  * Cleaner maven manifest build (prior way was from legacy ant build which duplicate items)
  * Updated license files

* [#28](https://github.com/grgrzybek/tomcat-slf4j-logback/pull/28): Maven Finalization [@hazendaz](https://github.com/hazendaz).
  * Added assembly to build out releases for sourceforge

* [#25](https://github.com/grgrzybek/tomcat-slf4j-logback/pull/25): Maven Finalization [@hazendaz](https://github.com/hazendaz).
  * Replaced majority of plugins with jarjar which more quickly builds project in about 5 seconds
  * Still using single jar, now includes all maven artifacts for slf4j/logback/tomcat-juli
  * Dropped support of building out javadoc & sources as jarjar is working against classes only

* [#24](https://github.com/grgrzybek/tomcat-slf4j-logback/pull/24): Maven [@hazendaz](https://github.com/hazendaz).
  * Additional tweaks to maven setup

* [#23](https://github.com/grgrzybek/tomcat-slf4j-logback/pull/23): POM Updates [@hazendaz](https://github.com/hazendaz).
  * Applied #21 to maven build

* [#22](https://github.com/grgrzybek/tomcat-slf4j-logback/pull/22): Changing version to fix #21 - [@dgomesbr](https://github.com/dgomesbr).
  * Request to upgrade tomcat due to cve-2014-0050. However, this had zero impact to this project as this only deals with classloader
  * of tomcat-juli.

* [#20](https://github.com/grgrzybek/tomcat-slf4j-logback/pull/20): Build Updates - [@hazendaz](https://github.com/hazendaz).
  * Mavenized project
  * License included as link in pom for site page
  * Ant/Ivy settings removed
  * Reworked README.md

* [#17](https://github.com/grgrzybek/tomcat-slf4j-logback/pull/17): Build Updates - [@hazendaz](https://github.com/hazendaz).
  * Added missing condition property to skip ivy downloads
  * Switched taskdef to more modern componentdef
  * Updated mail, jms, and groovy to more recent copies - all minor revisions

* [#15](https://github.com/grgrzybek/tomcat-slf4j-logback/pull/15): Ivy and Third Party Updates - [@hazendaz](https://github.com/hazendaz).
  * Updated all third party jars to latest
  * Reworked ivy layout to not copy local from cache - simply use cache for all items

* [#14](https://github.com/grgrzybek/tomcat-slf4j-logback/pull/14): Parametrization of ivy*.xml - (@grgrzybek](https://github.com/grgrzybek).

* [#12](https://github.com/grgrzybek/tomcat-slf4j-logback/pull/12): Updated Tomcat and Groovy - [@hazendaz](https://github.com/hazendaz).

* [#10](https://github.com/grgrzybek/tomcat-slf4j-logback/pull/10): Updated slf4j and Groovy - [@hazendaz](https://github.com/hazendaz).

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
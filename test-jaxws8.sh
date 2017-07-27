#!/bin/bash
mkdir -p /home/errorprone/examples
cd /home/errorprone/examples
if [ ! -x jaxws8 ]; then
	hg clone http://hg.openjdk.java.net/jdk8/jdk8/jaxws jaxws8
	cd jaxws8
	hg update 468
else
	cd jaxws8
	find . -name "*.class" -exec rm \{\} \;
fi
cd src/share/jaxws_classes
/usr/bin/java -Xbootclasspath/p:/home/errorprone/error-prone/ant/target/error_prone_ant-2.0.21.jar com.google.errorprone.ErrorProneCompiler -XepDisableAllChecks -XepDisableAllChecks -Xep:ArgumentSelectionDefectChecker:WARN -source 1.7 -target 1.7 `find . -name "*.java"`

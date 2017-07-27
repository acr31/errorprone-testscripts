#!/bin/bash
mkdir -p /home/errorprone/examples
cd /home/errorprone/examples
if [ ! -x jdk8 ]; then
	hg clone http://hg.openjdk.java.net/jdk8/jdk8/jdk jdk8
	cd jdk8
	hg update 9107
else
	cd jdk8
	find . -name "*.class" -exec rm \{\} \;
fi
cd src/share/classes
/usr/bin/java -Xbootclasspath/p:/home/errorprone/error-prone/ant/target/error_prone_ant-2.0.21.jar com.google.errorprone.ErrorProneCompiler -XepDisableAllChecks -Xep:ArgumentSelectionDefectChecker:WARN -source 1.8 -target 1.8 `find java -name "*.java"`

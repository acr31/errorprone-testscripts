#!/bin/bash

mkdir -p /home/errorprone/examples
cd /home/errorprone/examples
if [ ! -x asm ]; then
    wget -O- http://download.forge.ow2.org/asm/asm-6.0_BETA.tar.gz | tar xz
    mv asm-6.0_BETA asm
    cd asm
    wget http://download.forge.ow2.org/monolog/ow_util_ant_tasks_1.3.2.zip
    unzip -p ow_util_ant_tasks_1.3.2.zip  output/lib/ow_util_ant_tasks.jar > asm/ow_util_ant_tasks.jar
    mkdir config
    cd config
    wget http://central.maven.org/maven2/biz/aQute/bnd/biz.aQute.bndlib/3.3.0/biz.aQute.bndlib-3.3.0.jar
    cd ..
    patch <<EOF
--- build.xml	2017-07-16 08:51:32.000000000 +0100
+++ build.xml	2017-07-27 10:28:36.684217355 +0100
@@ -181,7 +181,15 @@
 	</target>
 
 	<target name="compile-debug" depends="init,compile-init,compile-config">
-		<javac destdir="\${out.build}/tmp" debug="on" source="1.5" target="1.5">
+  	        <javac destdir="\${out.build}/tmp" debug="on" source="1.8" target="1.8"
+           	       compiler="com.google.errorprone.ErrorProneAntCompilerAdapter"
+		       encoding="UTF-8"
+		       includeantruntime="false">
+			<compilerclasspath>
+			        <pathelement location="/home/errorprone/error-prone/ant/target/error_prone_ant-2.0.21.jar"/>
+			</compilerclasspath>
+			<compilerarg value="-XepDisableAllChecks"/>
+			<compilerarg value="-Xep:ArgumentSelectionDefectChecker:WARN"/>
 			<classpath>
 				<pathelement location="\${out.build}/tmp" />
 				<pathelement location="\${config}/\${biz.aQute.bnd.path}" />
EOF
    patch <<EOF
--- build.properties	2017-07-16 09:47:18.000000000 +0100
+++ build.properties	2017-07-27 10:29:30.920556512 +0100
@@ -52,7 +52,8 @@
 # Class path for the ObjectWeb utility Ant tasks (version 1.3.2 or higher)
 # See http://forge.objectweb.org/projects/monolog
 
-# objectweb.ant.tasks.path ow_util_ant_tasks.jar
+objectweb.ant.tasks.path ow_util_ant_tasks.jar
+biz.aQute.bnd.path biz.aQute.bndlib-3.3.0.jar
 
 # Class path for bdn
 # bnd.path biz.aQute.bnd.jar 
EOF
else
    cd asm
    ant clean
fi
ant compile-debug

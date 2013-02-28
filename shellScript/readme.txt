shellScript/readme.txt

This example shows how to run a shell script as part of a deployment. 

TODO...

copy command plugin

first try:

Manifest-Version: 1.0
Deployit-Package-Format-Version: 1.3
CI-Application: <application>
CI-Version: 1.0-<timestamp>

Name: resources
CI-Type: file.Folder
CI-TargetPath: /tmp
CI-order: 50

Name: ls
CI-Type: cmd.Command
CI-commandLine: ls -ltra /tmp
CI-order: 60

doesn't work because ....????
see commitid:  b91d89996ba1e29491d8e0954c6bf627f0369af0 [b91d899]


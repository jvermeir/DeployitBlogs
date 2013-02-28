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

doesn't work because there's no ci-order on a file.Folder
see commitid:  b91d89996ba1e29491d8e0954c6bf627f0369af0 [b91d899]

see referencemanual.html, search for '0 = PRE_FLIGHT'

correct solution:
Manifest-Version: 1.0
Deployit-Package-Format-Version: 1.3
CI-Application: <application>
CI-Version: 1.0-<timestamp>

Name: ls
CI-Type: cmd.Command
CI-Order: 79
CI-commandLine: ls -ltra /tmp
CI-dependencies-EntryValue-1: resources/<timestamp>.txt

Name: resources/<timestamp>.txt
CI-Type: file.File
CI-TargetPath: /tmp
CI-Name: resource

tried using file.Folder, doesn't work:
Import failed with the following validation errors
[ValidationMessage[id=Applications/script/1.0-20130228-073404/ls,
field=dependencies, message=Cannot set [cmd.Command.dependencies] with
ci [Applications/script/1.0-20130228-073404/resource] as it is not of
type [file.File]]]

TODO: gebruik environment var ($HOME) in target.
TODO: file.Folder accepteert alleen directories?

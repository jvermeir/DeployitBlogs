#
# Utility functions to assist deployment and management of packages
#

import string

def deleteApp(appName):
    versions = repository.search('udm.DeploymentPackage', 'Applications/' + appName )
    print "deleting: " + str(versions)
    for version in versions:
       app = repository.read(version)
       print "deleting: " + version
       try:
           print "undeploy: " + str(version)
           appInEnv = 'Environments/localenv/' + appName
           taskID = deployment.undeploy(appInEnv).id
           deployit.startTaskAndWait(taskID)
       except:
           print "Ignoring exception on undeploy, version is probably not deployed"

       try:
           print "Removing application: " + str(app.id)
           repository.delete(app.id)
       except:
           print "Failed to remove application: " + app.id

    deployit.runGarbageCollector()

def getAppName(fileName):
    print "Find app id for '" + fileName + "'"
    parts=string.split(fileName,'/')
    darFile=parts[len(parts)-1]
    appName=string.split(darFile,'.')[0]
    print "appName: " + appName
    return appName

def deployApp(fileName):
    print "Deploying application from file: '" + fileName + "'"
    try:
       appName=getAppName(fileName)
       deleteApp(appName)
       print "import and deploy"
       darId=deployit.importPackage(fileName)
       initialDeployment = deployment.prepareInitial(str(darId), "Environments/localenv")
       deployeds = deployment.generateAllDeployeds(initialDeployment)
       taskID = deployment.deploy(deployeds).id
       deployit.startTaskAndWait(taskID)
    except Exception, detail:
       print "Failed to deploy application: '" + fileName + "'"
       print detail


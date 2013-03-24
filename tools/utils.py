#
# Utility functions to assist deployment and management of packages
#

import string

#
# Main entry points to the library are deleteApp() and deployApp()
#

def deleteApp(appName):
    print "delete app named '" + appName + "'"
    undeployApps(appName)
    deleteVersions(appName)
    deployit.runGarbageCollector()

def deployApp(fileName, environmentName):
    print "Deploying application from file: '" + fileName + "' to environment '" + environmentName + "'"
    try:
       appName=getAppName(fileName)
       deleteApp(appName)
       print "import and deploy"
       darId=deployit.importPackage(fileName)
       initialDeployment = deployment.prepareInitial(str(darId), "Environments/" + environmentName)
       deployeds = deployment.generateAllDeployeds(initialDeployment)
       taskID = deployment.deploy(deployeds).id
       deployit.startTaskAndWait(taskID)
       print "OK"
    except Exception, detail:
       print "Failed to deploy application: '" + fileName + "'"
       print detail

#
# Helper functions
#
def undeployApps(appName):
    print "undeploying all versions of '" + appName + "'"
    ids = repository.searchByName(appName)
    for id in ids:
       ci = repository.read(id)
       if ci.type == "udm.DeployedApplication":
          print "undeploying: " , id
          undeployApp(ci)

def deleteVersions(appName):
    ids = repository.searchByName(appName)
    for id in ids:
       print "deleting: " , id
       deleteVersion(id)

def undeployApp(app):
    try:
       print "undeploy: " , app
       taskID = deployment.undeploy(app.id).id
       deployit.startTaskAndWait(taskID)
    except:
       print "Ignoring exception on undeploy, version is probably not deployed"

def deleteVersion(appVersion):
    try:
       print "Removing application: " , appVersion
       repository.delete(appVersion)
    except:
       print "Failed to remove application: " + str(appVersion.id)

def getAppName(fileName):
    print "Find app id for '" + fileName + "'"
    parts=string.split(fileName,'/')
    darFile=parts[len(parts)-1]
    appName=string.split(darFile,'.')[0]
    print "appName: " + appName
    return appName


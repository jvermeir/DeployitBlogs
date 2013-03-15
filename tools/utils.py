#
# Utility functions to assist deployment and management of packages
#

import string

def undeployApps(appName):
    ids = repository.searchByName(appName)
    for id in ids:
       ci = repository.read(id)
       if ci.type == "udm.DeployedApplication":
         undeployApp(ci)

def deleteVersions(appName):
    appVersions = repository.search('udm.Application')
    for appVersion in appVersions:
       if appVersion.endswith(appName):
           appId = repository.read(appVersion)
           print "deleting: " , appId
           deleteVersion(appId)

def undeployApp(app):
    try:
       print "undeploy: " , app
       taskID = deployment.undeploy(app.id).id
       deployit.startTaskAndWait(taskID)
    except:
       print "Ignoring exception on undeploy, version is probably not deployed"

def deleteApp(appName):
    print "delete app named '" + appName + "'"
    undeployApps(appName)
    deleteVersions(appName)
    deployit.runGarbageCollector()

def deleteVersion(appVersion):
    try:
       print "Removing application: " + appVersion.id
       repository.delete(appVersion.id)
    except:
       print "Failed to remove application: " + str(appVersion.id)

def getAppName(fileName):
    print "Find app id for '" + fileName + "'"
    parts=string.split(fileName,'/')
    darFile=parts[len(parts)-1]
    appName=string.split(darFile,'.')[0]
    print "appName: " + appName
    return appName

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


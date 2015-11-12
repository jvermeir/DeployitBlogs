**Some examples of how to use Maven to deploy stuff**

Create test data:

    ./bin/generateTestData.sh 
    
Then build a sample dar file using

    mvn install
    
Execute a default Tomcat install. 
Add the Tomcat server to the XLDeploy infrastructure
Create a oneHost environment based no the Tomcat host in the infrastructure just created.
Create a test environment including the Tomcat host, server and vhost.

**Deploy a hello world page to Tomcat using XLDeploy and Maven**

Make sure you have your XLDeploy server defined in $M2_HOME/settings.xml by adding a <server> tag to the list of <servers>:

    <server>
          <id>deployit-credentials</id>
    	  <username><!-- add username here --></username>
      	  <password><!-- add password here --></password>
    </server>

(see settings.sample for an example)

deploy using:

mvn -f tomcatPom.xml deployit:deploy

**File experiments**

mvn -f filePom.xml deployit:deploy

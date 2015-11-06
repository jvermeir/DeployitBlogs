**Deploy a hello world page to Tomcat using XLDeploy and Maven**

Make sure you have your XLDeploy server defined in $M2_HOME/settings.xml by adding a <server> tag to the list of <servers>:

    <server>
          <id>deployit-credentials</id>
    	  <username><!-- add username here --></username>
      	  <password><!-- add password here --></password>
    </server>

(see settings.sample for an example)

deploy using:

mvn -f XLDeployPom.xml deployit:deploy
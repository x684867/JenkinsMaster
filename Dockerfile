# Docker Container for Ubuntu 14.04 x64
# (c) 2014 EdgeCase, Inc.  sam@edgecase.io
# 
FROM x684867/ubuntucore14.04
MAINTAINER Sam Caldwell <mail@samcaldwell.net>

#Install all supporting scripts.
ADD files/bin/createKeys /usr/bin/
ADD files/bin/installJenkins /usr/bin/
ADD files/bin/installJenkinsDependencies /usr/bin/
ADD files/bin/installNginx /usr/bin/
ADD files/bin/nginxEnableSite /usr/bin/
ADD files/bin/startServer /usr/bin/
ADD files/bin/installJavaRe /usr/bin/

#Regenerate self-signed certificate
RUN /usr/bin/generateSelfSignedCert

#Install Java Runtime Environment (JRE) for Jenkins
RUN /usr/bin/installJavaRe

#Install Jenkins server software
RUN /usr/bin/installJenkins
# ToDo: Configure Jenkins

#Create the Jenkins SSH Keys
RUN /usr/bin/createKeys

RUN /usr/bin/installNginx

#Install jenkinsProxy vhost
ADD files/vhost/jenkinsProxy /etc/nginx/sites-available/jenkinsProxy
RUN /usr/bin/nginxEnableSite jenkinsProxy

#Install publicKeys vhost
ADD files/vhost/publicKeys /etc/nginx/sites-available/
RUN /usr/bin/nginxEnableSite publicKeys

EXPOSE 443

#default command when docker image is run
CMD ["/usr/bin/startServer"]
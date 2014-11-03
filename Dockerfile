# Docker Container for Ubuntu 14.04 x64
# (c) 2014 EdgeCase, Inc.  sam@edgecase.io
# 
FROM x684867/ubuntucore14.04
MAINTAINER Sam Caldwell <mail@samcaldwell.net>

#Install all supporting scripts.
ADD files/bin/installJenkins /usr/bin/
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

#Install Error Pages
ADD files/sites/400.html /usr/share/nginx/html/
ADD files/sites/401.html /usr/share/nginx/html/
ADD files/sites/402.html /usr/share/nginx/html/
ADD files/sites/403.html /usr/share/nginx/html/
ADD files/sites/404.html /usr/share/nginx/html/
ADD files/sites/500.html /usr/share/nginx/html/


#Install jenkinsProxy vhost
ADD files/vhost/jenkinsProxy /etc/nginx/sites-available/jenkinsProxy
RUN /usr/bin/nginxEnableSite jenkinsProxy

#Install publicKeys vhost
ADD files/sites/publicKeys /usr/share/nginx/html/
ADD files/vhost/publicKeys /etc/nginx/sites-available/
RUN /usr/bin/nginxEnableSite publicKeys

#Install any custom configuration files.
ADD files/conf.d/jenkins.model.JenkinsLocationConfiguration.xml /home/jenkins/
ADD files/conf.d/config.xml /home/jenkins/config.xml


RUN su -l jenkins -c 'cat /dev/zero | ssh-keygen -t rsa -b 2048 -q -N ""' &> /dev/null && cat /home/jenkins/.ssh/id_rsa.pub >> /usr/share/nginx/html/publicKeys


EXPOSE 443
EXPOSE 80

#default command when docker image is run
CMD ["/usr/bin/startServer"]
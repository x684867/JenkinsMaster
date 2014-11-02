JenkinsMaster
=============

This project creates a jenkins master server container.

Usage
-----
(1) Jenkins Master IMHO should not run actual jobs, but it should instead be a master-control server for n-number of slave servers that perform all actual work.  This keeps Jenkins manageable and stable with subsequent upgrades and such.

(2) The container created by this project can be run as--

    docker run -i -P -t x684867/jenkinsMaster

    and this command will start Jenkins and expose it to the wider network where users can interact to configure and operate the server.

(3) The container exposes SSH public keys as http://<ipaddr>:80/publicKeys


Changes:
--------
2 Nov 2014: Finished first working version.

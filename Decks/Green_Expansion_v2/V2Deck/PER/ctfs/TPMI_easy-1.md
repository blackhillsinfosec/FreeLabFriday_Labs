![image](/FilesForLabs/images/blueantisyphon.png)

## Tainted Package

A developer pulls in a popular open-source logging library for their Node.js project. They run `npm install` and the package installs without errors. A week later, the security team notices outbound traffic to an unknown IP coming from that same server.

The package version installed was `logger-utils@2.3.1`. The official version on the registry is `logger-utils@2.3.0`.

# Running KICS in Jenkins



## Plugins

- [HTML Publisher Plugin](https://plugins.jenkins.io/htmlpublisher/)
- [Docker Plugin](https://plugins.jenkins.io/docker-plugin/)
- [Docker Pipeline Plugin](https://plugins.jenkins.io/docker-workflow/)

```groovy
System.setProperty("hudson.model.DirectoryBrowserSupport.CSP", "sandbox allow-scripts; default-src *; style-src * http://* 'unsafe-inline' 'unsafe-eval'; script-src 'self' http://* 'unsafe-inline' 'unsafe-eval'");
```

```
The default Content-Security-Policy is currently overridden using the hudson.model.DirectoryBrowserSupport.CSP system property, which is a potential security issue when browsing untrusted files. As an alternative, you can set up a resource root URL that Jenkins will use to serve some static files without adding Content-Security-Policy headers.
```


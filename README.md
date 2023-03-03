# atg-api-tests-task

## Contents

* [Overview](#overview)
* [karate-framework](#karate-framework)
* [how-to-run-and-setup](#how-to-run-and-setup)
* [potential-improvements-for-testing-codebase](#potential-improvements-for-testing-codebase)




## Overview
ATG tech home task to automate PET endpoint of https://petstore.swagger.io/
Karate framework was chosen to leverage as it is ready to use tool. I would rather prefer to avoid complexity if this is not required.
I invest that time into test coverage for endpoint, instead of writing all that Java/any other language custom code for testing.
You can find 16 automated tests cases here.

## Karate framework
https://github.com/karatelabs/karate

## How to run and setup
It is required to install before start:
 - Java, maven
 - Idea or any other IDE (I would recommend Idea since it is being used during development)
 - Idea plugins: maven, cucumber, karate, cucumber for java


In order to run the tests you will need to create Run/Debug configuration (please find the example in atg/docs/example.png).

You can find report with test results within target/cucumber-html-reports
You can find the captured video of the execution of the tests (in case something goes wrong with execution on your end) in atg/docs/video.mov

## Potential improvements for testing codebase
Currently, I didn't manage to generate bearer token automatically due to lack of time.
In general, Oauth token has some expiration time equals 60 days. It should be enough for testing purposes.
But, it is achievable to automate ouath token generation. 
As per now, token is mocked in auth helper file, but it is real token obtained during the interception.
The best practise is not to share the token like that but as the exception I would not encapsulate it.
It is being used as it is in the code. In real life, the easiest we can do is to put into env variable.
Session, auth features, different tokens are not covered by auto tests here, but there are some placeholders to extend.
Also, it worth to create coverage for xml format, filters, mutability, latency, load, but it requires more time.


## Potential improvements for api
api returns not correct responses status, can be invoked without authorization, permissions, roles are not working...
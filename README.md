
AWS configuration loader
========================

This utility loads parameters stored in the AWS SSM (Simple Systems Manager) service into a processes environment

Problematic
===========

Applications need configurations to be able to address external elements (like databases, queues, etc). In the cloud
the ability to create these elements on-demand and programatically enable developers and system administrators to 
deploy their applications as many times as needed at will, but that also means that external elements can also get
created with new names. When we prepare an application for the cloud, we have to start caring about configuring the 
applications, handling secrets for connecting to databases, etc.

These configurations are often stored on services like etcd, zookeeper, consul, etc, which you have to manage, and pay for servers. It's not always trivial! See: https://crewjam.com/etcd-aws/, https://github.com/stylight/etcd-bootstrap,
https://limecodeblog.wordpress.com/2016/09/19/consul-cluster-in-aws-with-auto-scaling/.

AWS provides a service called SSM that exposes an API for storing parameters. These parameters can be strings and encrypted
strings (enabled for storing secrets). This utility leverages the SSM Parameters API to expose parameters in a way
that your application doesn't have to become aware of the SSM service. It does this exposing the parameters stored
in the service via environment variables to your application. This practice is inspired by https://12factor.net/es/config 
(Twelve factor App). Note that once your application is configured via environment variables, it is independent of where
the configuration is stored (you can easily adopt the same method if you are using etcd or consul).

Usage
=====

Create SSM parameters with names that follow this structure: `/APP_NAME/ENVIRONMENT_NAME/ENVIRONMENT_VARIABLE`.

When you invoke

```
bin/load_ssm_to_env APP_NAME:ENVIRONMENT_NAME:region your_app
```

`your_app` will have all the SSM parameters' values that start with `/APP_NAME/ENVIRONMENT_NAME/` accessible as environment variables:

`/appname/pre/DBHOST` will be accessible in the environment as `DBHOST`
`/appname/pre/DBPASS` will be accessible in the environment as `DBPASS`

Parameter creation
==================

You can create the parameters from the AWS console manually. Go to the console -> EC2 -> SYSTEMS MANAGER SHARED RESOURCES -> Parameter Store

You can also create the parameters with CloudFormation (see the example in the examples dir). This lets you create resources, and save
them as parameters so that later your application can read them.

Security
========
You can limit an instance, via an Instance Role to only be able to access the set of parameters for it's environment via an IAM policy:

```
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Effect":"Allow",
         "Action":[
            "ssm:DescribeParameterByPath",
         ],
         "Resource":"/myapp/pre/*",
      }
   ]
}
```
See [http://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-paramstore-working.html]

License
=======

This software is released under the Apache 2 License

Author
======

Jose Luis Martinez

Copyright
=========

(c) 2017 CAPSiDE SL

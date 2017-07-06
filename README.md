
AWS configuration loader
========================

This utility loads parameters stored in the AWS SSM (Simple Systems Manager) service into a processes environment

Usage
=====

Create SSM parameters with names that follow this structure: `/ENVIRONMENT_NAME/ENVIRONMENT_VARIABLE`.

When you invoke

```
bin/load_ssm_to_env ENVIRONMENT_NAME:region your_app
```

`your_app` will have all the SSM parameters' values that start with `/ENVIRONMENT_NAME/` accessible as environment variables:

`/pre/DBHOST` will be accessible in the environment as `DBHOST`

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
         "Resource":"/pre/*",
      }
   ]
}
```
See [http://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-paramstore-working.html]

example_stack:
	paws CloudFormation --region eu-west-1 CreateStack StackName preprod TemplateBody "`cat example/stack.json`" Parameters [ { ParameterKey StackName ParameterValue pre } ] Capabilities [ CAPABILITY_IAM ]

destroy_example_stack:
	paws CloudFormation --region eu-west-1 DeleteStack StackName preprod

get_parameters:
	paws SSM --region eu-west-1 GetParameters Names [ /pre/QUEUE_NAME /pre/QUEUE_REGION ]

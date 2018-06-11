import json
import model
import time
import boto3
import args


def get_default(fn, default=None, ignore_error=True, **kwargs):
    value = default

    try:
        result = fn(**kwargs)
        if result:
            value = result
    except Exception as error:
        print(f"catching error: {str(error)}")
        if not ignore_error:
            value = error

    return value


def handler(fn_handler, action, event=None):
    args.arguments.logger.info(f"Boto version: {boto3.__version__}")
    args.arguments.logger.info(f"event= {event}")
    args.arguments.logger.info(f'"{args.arguments.api_caller}" calling API "{action.lower()}"')
    args.arguments.event = event

    response = {
        "statusCode": 200,
        "body": {
            "action": action,
            "success": True
        }
    }

    try:
        resources = None
        if args.arguments.resources_type.is_iam_group():
            resources = model.IamGroups(iam_groups=args.arguments.resources)

        if args.arguments.resources_type.is_ec2_security_group():
            pass

        if not resources:
            raise UnboundLocalError("Resources is empty")

        fn_handler(resources)

        if resources.errors:
            response['statusCode'] = 400
            response['body']['success'] = False
            response['body']['error'] = {
                'message': 'Some errors occurred when sending commands to AWS',
                'details': resources.errors
            }

    except Exception as error:
        response['statusCode'] = 500
        response['body']['success'] = False
        response['body']['error'] = {
            'message': getattr(error, 'msg', str(error)),
            'details': f'type of error {type(error).__name__}'
        }

    response['body'] = json.dumps(response['body'])
    args.arguments.logger.debug("response: %s", response)
    return response


def json_loads(json_str):
    try:
        print(f"loading json {json_str}")
        return json.loads(json_str) if json_str else None
    except json.JSONDecodeError as e:
        print(f"json_loads error: {e}")
    return json_loads(json_str[1:-1])


def str_isotime(ddate):
    return f'{ddate.isoformat()}{time.strftime("%z")}'

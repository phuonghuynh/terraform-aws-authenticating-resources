import json
import helper
import logging


class Arguments:
    EXPIRED_AT = 'expired-at-%s'
    FAKE_POLICY_NAME = 'fake-policy-%s'
    FAKE_POLICY_DOC = json.dumps({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "%s",
                "Action": "s3:GetObject",
                "Resource": "arn:aws:s3:::%s"
            }
        ]
    })
    DEFAULT_EVENT = {
        "requestContext": {
            "identity": {
                "userArn": None
            }
        }
    }

    def __init__(self):
        self.event = Arguments.DEFAULT_EVENT
        self.iam_groups_dict = {}

        self.__time_to_expire = None
        self.__logger = None
        self.__module_name = None
        self.__api_caller = ""

        self.__resources = None
        self.__resources_type = None

    @property
    def logger(self):
        if not self.__logger:
            self.__logger = logging.Logger(name=self.module_name)
            self.__logger.setLevel(helper.get_default(
                fn=lambda: int(logging.getLevelName("${log_level}")),
                default="INFO",
            ))

            handler = logging.StreamHandler()
            formatter = logging.Formatter(f"[%(levelname)s] [%(name)s] - %(message)s")
            handler.setFormatter(formatter)
            self.__logger.addHandler(handler)

        return self.__logger

    @property
    def module_name(self):
        if self.__module_name is None:
            self.__module_name = helper.get_default(fn=lambda: str("${module_name}"), default="dln")
        return self.__module_name

    @property
    def resources(self):
        if not self.__resources:
            self.__resources = helper.json_loads('''${resources}''')
        return self.__resources

    @resources.setter
    def resources(self, resources):
        self.__resources = resources

    @property
    def time_to_expire(self):
        if self.__time_to_expire is None:
            self.__time_to_expire = helper.get_default(fn=lambda: int('${time_to_expire}'), default=600)
        return self.__time_to_expire

    @time_to_expire.setter
    def time_to_expire(self, seconds):
        self.__time_to_expire = int(seconds)

    @property
    def api_caller(self):
        if not self.__api_caller:
            user_arn = self.event['requestContext']["identity"]["userArn"]
            if user_arn:
                self.__api_caller = user_arn.split("/")[-1]

        if self.__api_caller:
            return self.__api_caller

        return "system"

    @property
    def resources_type(self):
        if not self.__resources_type:
            self.resources_type = '${resources_type}'
        return self.__resources_type

    @resources_type.setter
    def resources_type(self, rtype):
        self.__resources_type = ResourceType(rtype)


class ResourceType:

    def __init__(self, typ_e):
        if not isinstance(typ_e, str):
            raise TypeError(f"{typ_e} is not a string")
        self.__type = typ_e

    def __str__(self):
        return str(self.__type)

    def is_iam_group(self):
        return self.__type.lower() == 'iam_group'

    def is_ec2_security_group(self):
        return self.__type.lower() == 'ec2_security_group'


arguments = Arguments()

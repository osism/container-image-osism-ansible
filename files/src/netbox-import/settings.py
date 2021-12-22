import os
from dotenv import load_dotenv
load_dotenv()

NETBOX_URL = os.getenv("NETBOX_URL")
NETBOX_TOKEN = os.getenv("NETBOX_TOKEN")
IGNORE_SSL_ERRORS = (os.getenv("IGNORE_SSL_ERRORS", "False") == "True")

BASE_PATH = os.getenv("BASE_PATH", "/opt/netbox-import/devicetype-library/device-types/"

# optionnally load vendors through a space separated list as env var
VENDORS = os.getenv("VENDORS", "").split()

MANDATORY_ENV_VARS = ["NETBOX_URL", "NETBOX_TOKEN"]

for var in MANDATORY_ENV_VARS:
    if var not in os.environ:
        raise EnvironmentError("Failed because {} is not set.".format(var))

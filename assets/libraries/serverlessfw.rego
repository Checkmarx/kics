package generic.pulumi

import data.generic.common as common_lib

is_serverless_file(resource){
    common_lib.valid_key(resource, "service")
    common_lib.valid_key(resource, "frameworkVersion")
    common_lib.valid_key(resource, "provider")
}

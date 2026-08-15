locals {
    common-tags = {
        project = var.project
        environment = var.environment
        terraform = false
}

vpc-final-tags = merge(
                    local.common-tags,
                     {
                        Name = "${var.project}-${var.environment}"
                    },
                    var.vpc-final-tags
                )
}
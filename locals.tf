locals {
    common-tags = {
        project = var.project
        environment = var.environment
        terraform = true
}

vpc-final-tags = merge(
                    locals.common-tags,
                     {
                        Name = "${var.project}-${var.environment}"
                    },
                    var.vpc-final-tags
                )
}
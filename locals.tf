locals {
    common-tags = {
        project = var.project
        environment = var.environment
        terraform = true
}

vpc-final-tags = merge(
                    local.common-tags,
                     {
                        Name = "${var.project}-${var.environment}"
                    },
                    var.vpc-final-tags
                )


igw-final-tags = merge(
        local.common-tags,
        {
        Name = "${var.project}-${var.environment}"
        },
        var.igw-final-tags
)

zone-names = slice(data.aws_availability_zones.available.names,0,2)
}
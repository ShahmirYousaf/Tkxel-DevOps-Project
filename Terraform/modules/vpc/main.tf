resource "aws_vpc" "Proj_Shahmir_Vpc" {
    cidr_block = var.vpc_cidr
}

resource "aws_subnet" "Proj_Shahmir_Subnet" {
    vpc_id = aws_vpc.Proj_Shahmir_Vpc.id
    cidr_block = var.subnet_cidr
    availability_zone = "us-east-1a"
    tags = {
        Name = "main-subnet"
    }
}

resource "aws_internet_gateway" "Proj_Shahmir_IGW" {
    vpc_id = aws_vpc.Proj_Shahmir_Vpc.id
    tags = {
        Name = "main-igw"
    }
}

resource "aws_route_table" "Proj_Shahmir_Route_Table" {
    vpc_id = aws_vpc.Proj_Shahmir_Vpc.id
    tags = {
        Name = "main-route-table"
    }
}

resource "aws_route" "Proj_Shahmir_internet-access" {
    route_table_id = aws_route_table.Proj_Shahmir_Route_Table.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Proj_Shahmir_IGW.id
}

resource "aws_route_table_association" "Proj_Shahmir_Subnet_Association" {
    subnet_id = aws_subnet.Proj_Shahmir_Subnet.id
    route_table_id = aws_route_table.Proj_Shahmir_Route_Table.id

}

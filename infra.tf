provider "aws" {
    region = "us-east-1"
}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  enable_dns_support = true
  enable_dns_hostnames = true

  tags {
      Name = "test_vpc_redash"
    }
}

resource "aws_subnet" "test_redash" {
  count = 2
  cidr_block = "${cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  vpc_id = "${aws_vpc.main.id}"
  map_public_ip_on_launch = true
  tags {
    Name = "test_vpc_redash_subnet_${data.aws_availability_zones.available.names[count.index]}"
  }
}

resource "aws_internet_gateway" "test_redash" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
      Name = "test_vpc_redash_gateway"
  }
}

resource "aws_route_table" "test_redash" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.test_redash.id}"
  }

  tags {
      Name = "test_vpc_redash_route_table"
  }
}

resource "aws_route_table_association" "test_redash_route_table_association" {
  count          = 2
  subnet_id      = "${element(aws_subnet.test_redash.*.id, count.index)}"
  route_table_id = "${aws_route_table.test_redash.id}"
}

resource "aws_db_subnet_group" "test_redash" {
  name        = "test_redash"
  subnet_ids  = ["${aws_subnet.test_redash.*.id}"]
}

resource "aws_security_group" "test_redash" {
  name = "test_redash_sg"
  description = "allows access to redash servers"
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ASG
/*
resource "aws_autoscaling_group" "redash_cluster" {
  name                  = "${var.name_prefix}..."                
  vpc_zone_identifier
  min_size
  max_size
  desired_capacity
  launch_configuration
} 
*/

data "aws_ami" "ubuntu" {
  filter {
    name = "image-id"
    values = ["ami-2757f631"] # locking, this is used by individually launched instances
  }

  owners = ["099720109477"] # Canonical
}

# resource config.
resource "aws_instance" "cook_me_a_vpc" {
    ami = "${data.aws_ami.ubuntu.id}"
    key_name = "nwebz"
    instance_type = "t2.micro"
    subnet_id = "${aws_subnet.test_redash.0.id}"
    vpc_security_group_ids = ["${aws_security_group.test_redash.id}"]

    tags {
      Name = "test_redash.data.phila.gov"
    }
}

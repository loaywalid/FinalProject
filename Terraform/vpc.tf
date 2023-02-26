resource "aws_vpc" "eks-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "eks-vpc"
  }
}

resource "aws_subnet" "eks-pub1" {
  vpc_id     = aws_vpc.eks-vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-west-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-sub1"
    "kubernetes.io/cluster/EKS-Cluster" = "owned"
    "kubernetes.io/role/internal-elb" = 1
  }
}

resource "aws_subnet" "eks-pub2" {
  vpc_id     = aws_vpc.eks-vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-west-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-sub2"
    "kubernetes.io/cluster/EKS-Cluster" = "owned"
    "kubernetes.io/role/internal-elb" = 1
  }
}

resource "aws_subnet" "eks-pv1" {
  vpc_id     = aws_vpc.eks-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-1b"
  tags = {
    Name = "private-sub1"
    "kubernetes.io/cluster/EKS-Cluster" = "owned"
    "kubernetes.io/role/internal-elb" = 1
  }
}

resource "aws_subnet" "eks-pv2" {
  vpc_id     = aws_vpc.eks-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-west-1c"
  tags = {
    Name = "private-sub2"
    "kubernetes.io/cluster/EKS-Cluster" = "owned"
    "kubernetes.io/role/internal-elb" = 1
  }
}

resource "aws_internet_gateway" "os-gw" {
  vpc_id = aws_vpc.eks-vpc.id

  tags = {
    Name = "eks-gw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.eks-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.os-gw.id
  }

  tags = {
    Name = "eks-rw"
  }
}


resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.eks-pub1.id
  tags = {
    Name = "eks-nat-gw"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.eks-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "eks-rw-private"
  }
}

resource "aws_route_table_association" "pub1" {
  subnet_id      = aws_subnet.eks-pub1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "pub2" {
  subnet_id      = aws_subnet.eks-pub2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "pv1" {
  subnet_id      = aws_subnet.eks-pv1.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "pv2" {
  subnet_id      = aws_subnet.eks-pv2.id
  route_table_id = aws_route_table.private.id
}


resource "aws_security_group" "eks" {
  name        = "eks-sec-group"
  description = "Allow HTTP traffic from anywhere"
  vpc_id = aws_vpc.eks-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
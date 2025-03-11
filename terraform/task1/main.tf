provider "aws" {
  region = "us-east-1" 
}

resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"  
    enable_dns_support = true
    enable_dns_hostnames = true
   
}

# Create internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

}

# Create public subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

# Create private subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"
}

# Create EC2 instance in public subnet
resource "aws_instance" "public_ec2" {
  ami           = "ami-04b4f1a9cf54c11d0" 
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
  key_name      = "my"
  

  # Local provisioner to save EC2 IP
  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ec2-ip.txt"
  }
}

# Create DB Subnet Group with two subnets in the same AZ
resource "aws_db_subnet_group" "private_rds_subnet_group" {
  name       = "private-rds-subnet-group"
  subnet_ids = [aws_subnet.private.id, aws_subnet.private2.id]
}

# Create RDS instance in private subnet
resource "aws_db_instance" "private_rds" {
  allocated_storage    = 20
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"
  identifier         = "my-rds-instance"
  db_subnet_group_name  =  aws_db_subnet_group.private_rds_subnet_group.name
  username           = "admin"
  password           = "admin123" 
  skip_final_snapshot = true
}

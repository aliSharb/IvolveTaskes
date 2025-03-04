# Lab 12: Launching an EC2 Instance

## Objective
Create a Virtual Private Cloud (VPC) with:
- A **public subnet** with an EC2 instance (Bastion Host).
- A **private subnet** with an EC2 instance.
- A security group for the private EC2 to allow inbound SSH only from the public EC2.
- Use the public EC2 to SSH into the private EC2.

## Steps

### 1. Create a VPC
1. Go to **AWS Management Console** > **VPC**.
2. Click **Create VPC**.
3. Enter details:
   - **Name tag**: `Lab12-VPC`
   - **IPv4 CIDR block**: `10.1.0.0/16`
4. Click **Create VPC**.

### 2. Create Subnets
#### Public Subnet
1. Go to **Subnets** > **Create Subnet**.
2. Choose **Lab12-VPC**.
3. Enter:
   - **Name**: `Public-Subnet`
   - **CIDR block**: `10.1.1.0/24`
4. Click **Create Subnet**.

#### Private Subnet
1. Click **Create Subnet** again.
2. Choose **Lab12-VPC**.
3. Enter:
   - **Name**: `Private-Subnet`
   - **CIDR block**: `10.1.2.0/24`
4. Click **Create Subnet**.

### 3. Create an Internet Gateway
1. Go to **Internet Gateways** > **Create Internet Gateway**.
2. Enter **Name**: `Lab12-IGW`
3. Click **Create Internet Gateway** > Attach to `Lab12-VPC`.

### 4. Configure Route Tables
#### Public Route Table
1. Go to **Route Tables** > **Create Route Table**.
2. Enter **Name**: `Public-RT`.
3. Choose **Lab12-VPC**.
4. Click **Create Route Table**.
5. Select `Public-RT` > Click **Edit Routes**.
6. Add Route:
   - **Destination**: `0.0.0.0/0`
   - **Target**: `Lab12-IGW`
7. Click **Save routes**.
8. Associate with `Public-Subnet`.

#### Private Route Table
1. Click **Create Route Table**.
2. Enter **Name**: `Private-RT`.
3. Choose **Lab12-VPC**.
4. Click **Create Route Table**.
5. Associate with `Private-Subnet`.

### 5. Create Security Groups
#### Public EC2 (Bastion Host)
1. Go to **Security Groups** > **Create Security Group**.
2. **Name**: `Public-EC2-SG`
3. **VPC**: `Lab12-VPC`
4. **Inbound Rules**:
   - Allow SSH (`22`) from **your IP** (`0.0.0.0/0` for testing).
5. Click **Create Security Group**.

#### Private EC2
1. Go to **Security Groups** > **Create Security Group**.
2. **Name**: `Private-EC2-SG`
3. **VPC**: `Lab12-VPC`
4. **Inbound Rules**:
   - Allow **SSH (`22`)** only from the **Public EC2’s Security Group**.
5. Click **Create Security Group**.

### 6. Launch EC2 Instances
#### Public EC2 (Bastion Host)
1. Go to **EC2** > **Launch Instance**.
2. **Name**: `Bastion-Host`
3. Choose **Amazon Linux 2**.
4. **Instance type**: `t2.micro`.
5. **Key Pair**: Create or use an existing key.
6. **Network settings**:
   - **VPC**: `Lab12-VPC`
   - **Subnet**: `Public-Subnet`
   - **Security Group**: `Public-EC2-SG`
   - Enable **Auto-assign Public IP**.
7. Click **Launch**.

#### Private EC2
1. Go to **EC2** > **Launch Instance**.
2. **Name**: `Private-EC2`
3. Choose **Amazon Linux 2**.
4. **Instance type**: `t2.micro`.
5. **Key Pair**: Use the same key as the Bastion Host.
6. **Network settings**:
   - **VPC**: `Lab12-VPC`
   - **Subnet**: `Private-Subnet`
   - **Security Group**: `Private-EC2-SG`
   - Disable **Auto-assign Public IP**.
7. Click **Launch**.

### 7. Connect to Private EC2 via Bastion Host
#### 1. SSH into Public EC2
```sh
ssh  ubuntu@public-ec2-ip
```
copy key to public ec2

2. Change permissions:
   ```sh
   chmod 0600 ~/.ssh/key.pem
   ```
3. SSH into the **Private EC2**:
   ```sh
   ssh -i ~/.ssh/key.pem ubuntu@private-ec2-ip
   ```

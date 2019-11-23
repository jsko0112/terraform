# Terraform Example for AWS
# author  : jsko
# since : 2019.11.11

provider "aws" {
        region = "ap-northeast-2"
}

resource "aws_instance" "example" {
        ami  =  "ami-02b3330196502d247"
        instance_type = "t2.micro"
        vpc_security_group_ids = ["${aws_security_group.instance.id}"]

        # <<-EOF, EOF 표시는 새로운 줄에 문자를 매번 추가하는 것이 아니라 여러 줄의 단락으로 처리하는 Terraform의 Heredoc 문법
        user_data = <<-EOF
                    #!/bin/bash
                    echo "Hello world" > index.html
                    nohup busybox httpd  -f  -p "${var.server_port}" &
                    EOF
        tags = {
                Name  = "terraform-example"
        }
}

resource "aws_security_group" "instance" {
        name = "terraform-example-instance"

        ingress {
                from_port = "${var.server_port}" 
                to_port = "${var.server_port}" 
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
        }
}

# Terraform 코드의 중복 방지를 위한 변수 사용
variable "server_port" {
	description = "The port the server will use for HTTP requests"
	
	default  = 8080
}


# Terraform 출력 변수 처리
output "public_ip" {
	value = "${aws_instance.example.public_ip}"
}

# ELB 설정
resource "aws_elb" "example"  {
	name = "terraform_asg_example"
	availability_zone = ["${data.aws_availability_zones.all.names}"]
}

#VSC - git 연동

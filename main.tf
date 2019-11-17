# Terraform Example for AWS
# author  : jsko

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
                    nohup busybox httpd  -f  -p 8080 &
                    EOF
        tags = {
                Name  = "terraform-example"
        }
}

resource "aws_security_group" "instance" {
        name = "terraform-example-instance"

        ingress {
                from_port = 8080
                to_port = 8080
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
        }
}

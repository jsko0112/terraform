# Terraform Example for AWS
# Web Server Cluster
# author  : jsko

resource  "aws_launch_configuration" "example" {
	image_id = ""
	instance_type = "t2.micro"
	security_groups = ["${aws_security_group.instance_id}"]
	
	user_data = <<-EOF
		    #!/bin/bsh
		    echo "Hello World" > index.html
		    nohup busybox httpd -f -p "${var.server_port}" &
		    EOF

	# Auto Scaling Group 을 위해 추가
	lifecycle {
		#Terraform은 항상 기존  리소스가 삭제되기  전에 새로운 리소스 생
		create_before_destroy = true
	}
}

resource "aws_security_group" "instance" {
	name = "terraform_example_instance"

	ingress {
		from_port = "${var.server_port}"
		to_port = "${var.server_port}"
		protocol  = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	# Auto Scaling Group 을 위해 추가
	lifecycle {
		#Terraform은 항상 기존  리소스가 삭제되기  전에 새로운 리소스 생
		create_before_destroy = true
	}
}

# Auto Scaling Group 설정
resource "aws_autoscaling_group" "example" {
	launch_configuration = "${aws_launch_configuration.example_id}"

	min_size =  2
	max_size = 10

	tag {
		key			= "Name"
		value			= "terraform_awg_example"
		propagate_at_launch 	= true
	}
}

#  ASG를 원활하게 동작시키기 위해서는 availability_zones 값을 하나 이상 정의해야 함
data "aws_avilability_zones" "all" {}

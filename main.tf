provider "aws" {
	region = "ap-northeast-2"
}

resource "aws_instance" "example" {
	ami  =  "ami-02b3330196502d247"
	instance_type = "t2.micro"

	tags = {
		Name  = "terraform-example"
	}
}

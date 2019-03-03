# data "aws_ami" "ubuntu" {
#   most_recent = true # if multiple results come back from AMI search, use most recent
#   # search filters for image
#   filter {
#     name = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
#   }
#   filter {
#     name = "virtualization-type"
#     values = ["hvm"]
#   }
#   # owner of the image 'Canonical' in this case that distributes ubuntu
#   owners = ["099720109477"]
# }
# resource "aws_instance" "first_server" {
#   # take result from 'data' block aboce and assign to ami property of instance
#   ami = "${data.aws_ami.ubuntu.id}"
#   instance_type = "t2.micro"
#   tags {
#     Name = "identifiertag"
#   }
#   # assign this instance to subnet 2 created in resources.tf file
#   subnet_id = "${aws_subnet.blog-private-subnet.id}"
# }


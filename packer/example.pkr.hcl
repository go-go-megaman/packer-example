packer {
  required_plugins {
    amazon = {
      version = "= 1.1.5"
      source  = "github.com/hashicorp/amazon"
    }
  }

  required_plugins {
    git = {
      version = "= 0.3.2"
      source  = "github.com/ethanmdavidson/git"
    }
  }
}

data "git-commit" "cwd-head" {}

locals {
  commit_id = substr(data.git-commit.cwd-head.hash, 0, 8)
}

source "amazon-ebs" "example" {
  ami_name      = "example-${local.commit_id}"
  instance_type = "t2.micro"

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }

  ssh_username = "ubuntu"

  vpc_filter {
    filters = {
      "tag:Class" : "packer",
      "isDefault" : "false"
    }
  }

  subnet_filter {
    filters = {
      "tag:Class" : "packer"
    }
    most_free = true
    random    = false
  }

  security_group_filter {
    filters = {
      "tag:Class" : "packer"
    }
  }
}

build {
  name = "build-example"
  sources = [
    "source.amazon-ebs.example"
  ]
}

resource "aws_docdb_cluster_parameter_group" "parameter_group" {
  name        = var.parameter_group_name
  family      = var.parameter_group_family
  description = "Custom parameter group for DocumentDB"

  parameter {
    name  = "tls"
    value = "disabled"
  }

  tags = {
    Name = var.parameter_group_name
  }
}

resource "aws_docdb_subnet_group" "subnet_group" {
  name       = var.subnet_group_name
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = var.subnet_group_name
  }
}

resource "aws_docdb_cluster" "cluster" {
  cluster_identifier              = var.cluster_identifier
  engine                          = "docdb"
  engine_version                  = var.engine_version
  master_username                 = var.master_username
  master_password                 = var.master_password
  vpc_security_group_ids          = [var.security_group_id]
  db_subnet_group_name            = aws_docdb_subnet_group.subnet_group.name
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.parameter_group.name
  storage_encrypted               = true
  skip_final_snapshot             = true
  deletion_protection             = false

  tags = {
    Name = var.cluster_identifier
  }
}

resource "aws_docdb_cluster_instance" "cluster_instance" {
  count              = var.instance_count
  identifier         = "${var.cluster_identifier}-instance-${count.index + 1}"
  cluster_identifier = aws_docdb_cluster.cluster.id
  instance_class     = var.instance_class

  tags = {
    Name = "${var.cluster_identifier}-instance-${count.index + 1}"
  }
}

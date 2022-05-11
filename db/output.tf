output "MYSQL_ENDPOINT" {
  value = aws_db_instance.mysql.address
}

output "MONGODB_ENDPOINT" {
  value = aws_docdb_cluster.docdb.endpoint
}
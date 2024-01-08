resource "aws_dynamodb_table" "interview-ace-websocket-connections-dynamodb-table" {
  name           = "interview-ace-websocket-connections"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "connection_id"

  attribute {
    name = "connection_id"
    type = "S"
  }

  tags = {
    Name        = "interview-ace-websocket-connections"
    Environment = "production"
  }
}

resource "aws_dynamodb_table" "interview-ace-websocket-connections-history-dynamodb-table" {
  name           = "interview-ace-websocket-connections-history"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "connection_id"

  attribute {
    name = "connection_id"
    type = "S"
  }

  tags = {
    Name        = "interview-ace-websocket-connections-history"
    Environment = "production"
  }
}

output "connections-table-name" {
  value = resource.aws_dynamodb_table.interview-ace-websocket-connections-dynamodb-table.name
}

output "connections-history-table-name" {
  value = resource.aws_dynamodb_table.interview-ace-websocket-connections-history-dynamodb-table.name
}
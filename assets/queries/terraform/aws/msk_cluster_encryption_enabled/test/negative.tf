resource "aws_msk_cluster" "example1" {  
  encryption_info {
    encryption_at_rest_kms_key_arn = aws_kms_key.kms.arn
  }
}

resource "aws_msk_cluster" "example2" {  
  encryption_info {
    encryption_at_rest_kms_key_arn = aws_kms_key.kms.arn
    encryption_in_transit {
      client_broker = "TLS"
      in_cluster = true
    }
  }
}

resource "aws_msk_cluster" "example3" {  
  encryption_info {
    encryption_at_rest_kms_key_arn = aws_kms_key.kms.arn
    encryption_in_transit {
      client_broker = "TLS"
    }
  }
}

resource "aws_msk_cluster" "example4" {  
  encryption_info {
    encryption_at_rest_kms_key_arn = aws_kms_key.kms.arn
    encryption_in_transit {
      in_cluster = true
    }
  }
}
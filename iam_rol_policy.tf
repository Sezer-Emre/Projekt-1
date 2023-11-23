resource "aws_iam_instance_profile" "test_profile" {        ## Bu kismi Ec2 baglamak icin olusturuyoruz.
  name = "test-profile"

  role = aws_iam_role.Grafana_role.name
}


resource "aws_iam_role" "Grafana_role" {
  name               = "Grafana-role"
 # assume_role_policy = aws_iam_policy.Grafana_policy.arn
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",                      ##Bu kisim ile rolü Ec2 larin kulnacagini belirtiyor sanirim.
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "Grafana_policy" {
  name        = "Grafana-policy"
  description = "Example IAM policy"
  
  # JSON dosyasının içeriğini al ve IAM politikası olarak kullan
  policy = file("./user_data_file/policy.json")    ## path degistirebilirim
}

resource "aws_iam_role_policy_attachment" "example_attachment" {            # Bu kisim ile policy Role bagliyoruz.
  role       = aws_iam_role.Grafana_role.name
  policy_arn = aws_iam_policy.Grafana_policy.arn
}




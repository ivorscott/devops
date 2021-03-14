output "public_ip" {
  description = "The public ip address of the web server"
  value = aws_instance.example.public_ip
}

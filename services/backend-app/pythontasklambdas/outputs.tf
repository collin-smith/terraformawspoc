output "A_base_url" {
  description = "API Gateway URL"
  value = "${aws_api_gateway_deployment.api_deployment.invoke_url}/}"
}

output "B_gettasks_GET" {
  description = "GetTasks Lambda URL"
  value = "GET ${aws_api_gateway_deployment.api_deployment.invoke_url}/${aws_api_gateway_resource.tasks.path_part}"
}

output "C_gettask_GET" {
  description = "GetTask  Lambda URL"
  value = "GET ${aws_api_gateway_deployment.api_deployment.invoke_url}/${aws_api_gateway_resource.tasks.path_part}/{id}"
}

output "D_createtask_POST" {
  description = "CreateTask  Lambda URL"
  value = "POST (with body) ${aws_api_gateway_deployment.api_deployment.invoke_url}/${aws_api_gateway_resource.tasks.path_part}"
}
output "E_updatetask_PUT" {
  description = "UpdateTask  Lambda URL"
  value = "PUT (with body) ${aws_api_gateway_deployment.api_deployment.invoke_url}/${aws_api_gateway_resource.tasks.path_part}"
}
output "F_deletetask_DELETE" {
  description = "DeleteTask  Lambda URL"
  value = "DELETE (with body) ${aws_api_gateway_deployment.api_deployment.invoke_url}/${aws_api_gateway_resource.tasks.path_part}"
}





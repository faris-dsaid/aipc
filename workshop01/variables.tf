variable DO_token {
    type = string
    sensitive = true
}

variable ports{
    type = list(number)
    default=[8080,8081,8082,8083]
}  



variable mynet {
    type = string
    default = "mynet"
}
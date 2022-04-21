module "mongodb" {
  source                = "./mongodb"
  ENV                   = var.ENV
  MONGODB_INSTANCE_TYPE = var.MONGODB_INSTANCE_TYPE

}

module "rabbitmq" {
  source                 = "./rabbitmq"
  ENV                    = var.ENV
  RABBITMQ_INSTANCE_TYPE = var.RABBITMQ_INSTANCE_TYPE
}



module "mysql" {
  source = "./mysql"
  ENV    = var.ENV
}

module "redis" {
  source = "./redis"
  ENV    = var.ENV
}



output "redis" {
  value = module.redis.redis
}
#ENV                    = "prod"
#MONGODB_INSTANCE_TYPE  = "t3.micro"
#RABBITMQ_INSTANCE_TYPE = "t3.micro"
ENV            = "prod"
WORKSTATION_IP = "172.31.15.197/32"

# RDS_MYSQL
RDS_MYSQL_PORT     = 3306
RDS_MYSQL_STORAGE  = 10
RDS_ENGINE_VERSION = "5.7"
RDS_INSTANCE_TYPE  = "db.t3.micro"

DOCUMENTDB_PORT           = 27017
DOCUMENTDB_INSTANCE_CLASS = "db.t3.medium"
DOCUMENTDB_INSTANCE_COUNT = 1

RABBITMQ_PORT           = 5672
RABBITMQ_ENGINE_VERSION = "3.9.13"
RABBITMQ_INSTANCE_TYPE  = "mq.t3.micro"

ELASTICACHE_NODE_TYPE      = "cache.t3.small"
ELASTICACHE_NODE_COUNT     = 1
ELASTICACHE_PORT           = 6379
ELASTICACHE_ENGINE_VERSION = "6.x"
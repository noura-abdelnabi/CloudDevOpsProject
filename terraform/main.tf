module "network" {
  source      = "./modules/network"
  vpc_cidr    = "10.0.0.0/16"
  subnet_cidr = "10.0.1.0/24"
}

module "server" {
  source    = "./modules/server"
  vpc_id    = module.network.vpc_id
  subnet_id = module.network.public_subnet_id
}
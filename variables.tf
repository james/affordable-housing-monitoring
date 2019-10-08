variable "container_command" {
  description = "command to run in container"
  type        = "list"
  default     = ["bundle", "exec", "puma"]
}

variable "additional_domains" {
  description = "Additional domains"
  type        = "list"
  default     = []
}

variable "rds_engine_version" {
  description = "RDS Engine Version"
  default     = "11.4"
}

variable "rds_instance_class" {
  description = "RDS Instance Class"
  default     = "db.t2.small"
}

variable "rds_allocated_storage" {
  description = "RDS allocated storage"
  default     = "20"
}

variable "rds_db_name" {
  description = "RDS DB Name"
  default     = "ahm"
}

variable "rds_db_username" {
  description = "RDS DB Username"
  default     = "ahm"
}

variable "rds_db_password" {
  description = "RDS DB Password"
}

variable "rds_backup_window" {
  description = "RDS Backup window"
  default     = "00:00-01:00"
}

variable "rds_maintenance_window" {
  description = "RDS maintenance window"
  default     = "mon:22:00-mon:22:30"
}

variable "rds_db_parameter_group" {
  description = "RDS DB Parameter Group"
  default     = "postgres11"
}

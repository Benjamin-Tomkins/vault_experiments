pid_file = "/var/run/vault-agent.pid"

listener "tcp" {
  address     = "127.0.0.1:8100"
  tls_disable = true
}

template_config {
  static_secret_render_interval = "5m"
  exit_on_retry_failure         = true
  max_connections_per_host      = 10
}

vault {
  address = "http://vault:8200"
  token = "root"
  retry {
    num_retries = 5
  }
}

env_template "MY_SECRET_MY_KEY" {
  contents             = "{{ with secret \"kv/my-secret\" }}{{ .Data.my-key }}{{ end }}"
  error_on_missing_key = true
}

exec {
  command                   = ["/usr/sbin/nginx", "-g", "'daemon", "off;'"]
  restart_on_secret_changes = "always"
  restart_stop_signal       = "SIGTERM"
}

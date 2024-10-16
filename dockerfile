# Stage 1: Vault base image
FROM hashicorp/vault:1.17.5 AS vault-base

# Stage 2: Nginx base image
FROM nginx:1.22

# Install necessary tools
RUN apt-get update && apt-get install -y wget procps net-tools curl

# Create necessary directories for Vault Agent
RUN mkdir -p /vault/agent

# Set permissions for the /vault/agent directory
RUN chmod -R 777 /vault/agent

# Copy the Vault binary from the first stage
COPY --from=vault-base /bin/vault /usr/local/bin/vault

# Copy Vault Agent configuration
COPY vault-agent.hcl /etc/vault-agent.hcl

# Copy Nginx configuration (optional)
COPY nginx.conf /etc/nginx/nginx.conf

# Expose Nginx port
EXPOSE 8080

# Set the Vault root token (you can replace 'root' with a secure token)
ENV VAULT_TOKEN=root

# Start Vault Agent in supervisor mode
CMD ["vault", "agent", "-config=/etc/vault-agent.hcl", "-log-level=error"] 

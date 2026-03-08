{ pkgs, ... }:
{
  virtualisation.oci-containers.containers = {
    db = {
      image = "postgres:17";
      environment = {
        POSTGRES_DB = "authabong";
        POSTGRES_USER = "\${DB_USER}";
        POSTGRES_PASSWORD = "\${DB_PASSWORD}";
      };
      ports = [ "5432:5432" ];
      volumes = [ "postgres_data:/var/lib/postgresql/data" ];
    };

    redis = {
      image = "redis:alpine";
      ports = [ "6379:6379" ];
      volumes = [ "redis_data:/data" ];
    };

    api = {
      image = "ghcr.io/sjallabong/authabong-api:latest";
      environmentFiles = [ /path/to/.env ];
      ports = [ "3001:3001" ];
      volumes = [ "/path/to/jwt.key:/run/secrets/jwt_key:ro" ];
      dependsOn = [
        "db"
        "redis"
      ];
    };

    web = {
      image = "ghcr.io/sjallabong/authabong-web:latest";
      environmentFiles = [ /path/to/.env ];
      ports = [ "3000:3000" ];
      dependsOn = [ "api" ];
    };
  };
}

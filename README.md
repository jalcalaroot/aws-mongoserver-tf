# MongoDB Server on EC2 (Terraform)

Terraform example (originally "mongoserver-tf") that launches a single Ubuntu EC2 instance in an existing VPC/subnet in
`us-east-1` and installs MongoDB 4.0 through a user-data script.

> **Status:** legacy reference (2019), written for Terraform 0.11-era syntax (`"${...}"` interpolation, `type = "string"`, `tags {}` blocks), not actively maintained. Review and update providers/syntax before using.

## Architecture

- Provider pinned to region `us-east-1`, credentials from variables.
- Security group `<servername>-sg`: SSH 22 and MongoDB range 27000-28000 open from `0.0.0.0/0`, all egress.
- `aws_key_pair` named `mongo` from an embedded public key (same key as `mongo.pub`).
- `aws_instance` (hardcoded Ubuntu AMI, `t2.small`, 100 GB gp2 root volume) in the given subnet.
- `deploy.sh` (user data): adds the MongoDB 4.0 apt repo (Ubuntu trusty), installs `mongodb-org`, creates a systemd unit,
  writes `/etc/mongod.conf` with `bindIp: 0.0.0.0` and no `security:` section, then tries to run `/tmp/create-dbs.js`
  (that file is not part of this repo).

## Inputs

| Name | Description | Default |
|------|-------------|---------|
| `access_key` | AWS access key ID | none (required) |
| `secret_key` | AWS secret access key | none (required) |
| `servername` | Name tag for the instance and SG prefix | none (required) |
| `vpc_id` | Existing VPC ID (`vpc-xxxxxxxx`) | none (required) |
| `subnetid_1` | Existing subnet ID for the instance (`subnet-xxxxxxxx`) | none (required) |

## Usage

```bash
terraform init
terraform plan  -var 'servername=mongo01' -var 'vpc_id=<VPC_ID>' -var 'subnetid_1=<SUBNET_ID>' \
                -var 'access_key=<ACCESS_KEY_ID>' -var 'secret_key=<SECRET_ACCESS_KEY>'
terraform apply -var 'servername=mongo01' -var 'vpc_id=<VPC_ID>' -var 'subnetid_1=<SUBNET_ID>' \
                -var 'access_key=<ACCESS_KEY_ID>' -var 'secret_key=<SECRET_ACCESS_KEY>'
```

No backend is configured; state is local. Replace the embedded public key with your own (`<KEY_PAIR_NAME>`).

## Security notes

- MongoDB listens on all interfaces with **no authentication**, and ports 27000-28000 are open to `0.0.0.0/0`:
  anyone can read/write the database if the subnet is public.
- SSH (22) open to `0.0.0.0/0`.
- AWS credentials passed as plain variables and stored in local state.
- Root volume not encrypted; MongoDB 4.0 and the Ubuntu trusty repo are end-of-life.
- `chmod 777` on `/tmp/create-dbs.js`; local state, no provider version pinning.

## Cleanup

```bash
terraform destroy
```

## License

MIT — see [LICENSE](LICENSE).

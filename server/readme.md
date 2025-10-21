## Install ssh public key github
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/1xtier/script/refs/heads/main/srvadmin/ssh_add_key.sh)"
sh -c "$(wget https://raw.githubusercontent.com/1xtier/script/refs/heads/main/srvadmin/ssh_add_key.sh -O -)"
```

## rapidctl
```bash
touch system_package.yaml
```
#### file contents

```yaml
update: true | false
package:
  - name_packages
```

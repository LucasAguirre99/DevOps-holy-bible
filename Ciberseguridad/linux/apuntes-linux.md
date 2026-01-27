# 🐧 Linux & Bash Cheatsheet

### 📌 Apuntes personales – DevOps | Seguridad | Scripting

> Guía rápida de comandos Linux, Bash, redirecciones, permisos, redes y utilidades que uso en el día a día.
> Pensado como **chuleta práctica**, no teoría extensa.

---

# 📚 Tabla de contenidos

* Usuario y sistema
* PATH y binarios
* Flujo y redirecciones
* Permisos y usuarios
* SUID / Capabilities
* Directorios Linux
* Pipes y filtros (awk/sed/grep)
* find
* Procesos
* Red y puertos
* SSH / Netcat / Nmap
* tmux
* Vim
* Cron
* Bash scripting
* Tips pro

---

---

# 👤 Usuario y sistema

```bash
whoami          # usuario actual
id              # UID, GID y grupos
groups          # grupos
```

### Archivos importantes

```bash
cat /etc/passwd     # usuarios + home + shell
cat /etc/group      # grupos
cat /etc/shadow     # hashes (root)
cat /etc/shells     # shells disponibles
```

---

# 🔎 PATH y binarios

```bash
echo $PATH      # orden de búsqueda de ejecutables
which python
command -v python   # más portable (mejor)
```

👉 Linux busca los binarios **de izquierda a derecha en $PATH**

---

# 🔗 Control de flujo

```bash
cmd1 ; cmd2      # siempre ejecuta ambos
cmd1 && cmd2     # si cmd1 OK
cmd1 || cmd2     # si cmd1 falla
echo $?          # exit code (0 = OK)
```

---

# 🔁 Redirecciones y descriptores

| FD | Canal  |
| -- | ------ |
| 0  | stdin  |
| 1  | stdout |
| 2  | stderr |

```bash
cmd > out.txt
cmd 2> err.txt
cmd &> all.txt
cmd > /dev/null 2>&1
```

### Segundo plano

```bash
process &>/dev/null & disown
```

* `&` → background
* `disown` → no muere al cerrar terminal

---

# 🧠 Descriptores avanzados (exec)

```bash
exec 3> log.txt
echo "hola" >&3
exec 3>&-
```

Muy útil para:

* logs
* sockets
* scripts grandes

---

# 🔐 Permisos

Formato:

```
-rwxr-xr--
```

| Pos  | Significado |
| ---- | ----------- |
| 1    | tipo        |
| 2-4  | owner       |
| 5-7  | group       |
| 8-10 | others      |

```bash
chmod 755 file
chmod u+rwx,g+rw,o+r file
```

---

# 👥 Usuarios y grupos

```bash
useradd lucas -s /bin/bash -d /home/lucas
passwd lucas
groupadd devops
usermod -aG devops lucas
```

```bash
chown user:group file
chgrp group file
```

---

# 📌 Sticky bit

Evita que otros borren tus archivos dentro del dir.

```bash
chmod +t shared_dir
```

Ejemplo real: `/tmp`

---

# 🧬 lsattr / chattr

```bash
lsattr file
chattr +i file   # inmutable (ni root borra)
```

---

# 🚨 SUID / SGID

Permite ejecutar con permisos del dueño.

```bash
find / -perm -4000 2>/dev/null
```

| Tipo | Valor |
| ---- | ----- |
| SUID | 4000  |
| SGID | 2000  |

⚠️ Riesgo de escalada → revisar siempre

---

# 🛡 Capabilities

Más seguras que SUID:

```bash
getcap -r /
setcap cap_setuid+ep binary
```

---

# 📂 Directorios importantes

| Ruta  | Uso              |
| ----- | ---------------- |
| /bin  | comandos básicos |
| /sbin | root             |
| /etc  | configs          |
| /var  | logs             |
| /tmp  | temporales       |
| /proc | procesos         |
| /home | usuarios         |
| /root | root             |

---

# 🔥 Pipes y filtros

## awk

```bash
awk '{print $1}'
awk 'NF{print $NF}'
```

## cut

```bash
cut -d ' ' -f1
```

## sed

```bash
sed 's/a/b/g'
```

## grep

```bash
grep texto file
grep -r texto .
grep -v texto
grep -E "a|b"
```

## sort / uniq

```bash
sort file | uniq -u
```

## strings

```bash
strings binary
```

## tr (ROT13)

```bash
tr '[A-Za-z]' '[N-ZA-Mn-za-m]'
```

## xxd

```bash
xxd file
xxd -r file
```

---

# 🔎 find (MUY usado)

```bash
find / -name file
find . -type f
find . -perm 777
find . -size 10M
find . -user lucas
find . -name "*.sh"
```

---

# ⚙️ Procesos

```bash
ps faux
top
htop
lsof -i:80
```

---

# 🌐 Red y puertos

```bash
ss -nltp
netstat -tulpn
cat /proc/net/tcp
```

### Test puerto con bash

```bash
echo > /dev/tcp/127.0.0.1/80
```

---

# 📡 Netcat

```bash
nc -nlvp 4444
ncat --ssl ip 443
```

---

# 🔎 Nmap

```bash
nmap --open -T5 -n -p1-1000 192.168.0.1
```

---

# 🔐 SSH

```bash
ssh user@ip
ssh user@ip command
sshpass -p pass ssh user@ip
```

---

# 🖥 tmux

```bash
tmux new -s dev
```

| Shortcut | Acción           |
| -------- | ---------------- |
| Ctrl+b c | nueva ventana    |
| Ctrl+b % | split vertical   |
| Ctrl+b " | split horizontal |
| Ctrl+b o | cambiar panel    |
| Ctrl+b d | detach           |

---

# ✍️ Vim rápido

| Tecla     | Acción         |
| --------- | -------------- |
| dd        | borrar línea   |
| dw        | borrar palabra |
| yy        | copiar         |
| p         | pegar          |
| .         | repetir        |
| :%s/a/b/g | reemplazar     |

---

# ⏰ Cron

Formato:

```
* * * * *  (min hora día mes semana)
```

```bash
*/5 * * * * script.sh
```

---

# 🐚 Bash scripting

## Argumentos

```bash
$0 $1 $2
$#
$*
```

## trap (CTRL+C)

```bash
trap ctrl_c INT
```

## mktemp

```bash
mktemp -d
```

---

# 🔧 getopts

```bash
while getopts "m:uh" arg; do
 case $arg in
  m) name=$OPTARG ;;
  u) flag=true ;;
 esac
done
```

* `:` → requiere valor
* sin `:` → flag

---

# ⚡ Tips PRO (DevOps real)

## Debug scripts

```bash
set -euo pipefail
set -x
```

## Historial

```bash
history
!!
!100
```

## Permisos recursivos

```bash
chmod -R 755 dir
chown -R user:group dir
```

## Ver logs en vivo

```bash
tail -f file.log
```

## Comprimir rápido

```bash
tar -czvf file.tar.gz dir
```

---

# 📚 Recursos útiles

* OverTheWire Bandit
* GTFOBins
* explainshell.com
* tldr pages (`tldr <cmd>`)

---


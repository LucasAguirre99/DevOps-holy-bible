# Backups automaticos

Para poder generar los backups de forma automatica en n8n estando en kubernetes, primero vamos a crear un pvc y un cronjob que entra dentro del pod genera un .tar con todos los datos. Por defecto n8n utiliza SQLite para almacenar los datos como base de datos, en caso de que se haya elegido otra base de datos hay que agregarle la forma de hacer un dump de la misma.

Para esto vamos a crear: 

- pvc-backup.yaml

- job-backup.yaml

Esto va a crear los backups todos los días a las 2AM 

# Restaurar los backups

Una vez creados, debemos de elegir el nombre del backup, vamos a pasar del pvc del backup al nuevo pvc donde vamos a restaurar, y creamos un pod de n8n o el mismo que ya tenemos utilizando este pvc donde ya está el backup. Para esto aplicamos los manifiestos en el siguiente orden

1- pvc-to-restore.yaml

2- pod-restore.yaml

3- pod-restaured.yaml

Con esto ya podremos entrar y trendremos restaurado el entorno de n8n
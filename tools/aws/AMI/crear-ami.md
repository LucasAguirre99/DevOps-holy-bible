# 🚀 Instalación de una imagen ISO en VirtualBox y Creación de AMI en AWS

## 🧹 1. Preparativos

El primer paso es montar la imagen ISO dentro de **VirtualBox**.
👉 **Asegúrate de tener la última versión**, ya que versiones anteriores **no son compatibles con imágenes personalizadas**.

---

## 💻 2. Instalación de Ubuntu Server

Cuando inicies la máquina virtual por primera vez:

1. Se instalará **Ubuntu Server**.
2. Al finalizar, la VM se reiniciará automáticamente.
3. En el reinicio, elige la unidad de **CD/DVD** como fuente de arranque.
4. Comenzará la instalación de la ISO.

Una vez finalizada la instalación, puedes cerrar la VM y comenzar con el siguiente proceso.

---

## 📁 3. Convertir el disco a formato VMDK

Nos movemos a la carpeta raíz de VirtualBox:

```bash
cd ~/VirtualBox\ VMs/<nombre-de-nuestra-VM>
```

Dentro encontrarás las unidades de memoria del entorno. Ejecuta:

```bash
VBoxManage clonemedium <file.vdi> <file.vmdk> --format VMDK --variant Stream
```

---

### En caso de que esto de problemas por ya estar creado, lo podemos borrar
```bash
Cannot register the hard disk '/home/lucas/VirtualBox VMs/iso-24/iso-24.vmdk' with UUID {07417a69-2bbc-4de9-a5fb-fa86adcf20bf} already exists
```

## ☁️ 4. Subir imagen a AWS S3

Desde la consola de AWS:

1. Crea un **bucket** en S3.
2. Sube el archivo `.vmdk`:

```bash
aws s3 cp <file.vmdk> s3://<nuestro-bucket>/
```

---

## 💠 5. Crear la AMI

Usamos el siguiente comando para importar la imagen:

```bash
aws ec2 import-image \
  --disk-containers '[{
    "Description": "<Descripción>",
    "Format": "vmdk",
    "UserBucket": {
      "S3Bucket": "<nuestro-bucket>",
      "S3Key": "<file.vmdk>"
    }
  }]' \
  --region eu-west-3 \
  --architecture x86_64 \
  --platform Linux \
  --role-name vmimport
```

---

## 📊 6. Monitorear progreso de importación

Este proceso puede tardar hasta **20 minutos**.
Puedes revisar el estado con:

```bash
aws ec2 describe-import-image-tasks \
  --region eu-west-3 \
  --query 'ImportImageTasks[].{Status: Status, Progress: Progress, ImageId: ImageId}'
```

Guarda el `ImageId` que aparece en la salida para los siguientes pasos.

---

## 📝 7. Renombrar la AMI

Desde la consola de AWS verás la imagen con un nombre genérico tipo `import-ami-xxxxxx`.
Para renombrarla, copia la imagen:

```bash
aws ec2 copy-image \
  --source-image-id AMI_ID \
  --source-region eu-west-3 \
  --region eu-west-3 \
  --name "<Nombre de nuestra imagen>" \
  --description "<Descripción>"
```

---

## 🌍 8. Hacer pública la AMI (opcional)

Si deseas que otros puedan usar tu AMI:

```bash
aws ec2 modify-image-attribute \
  --image-id ami-nuevoid \
  --launch-permission "Add=[{Group=all}]" \
  --region eu-west-3
```

---

## 🎉 9. ¡Listo!

Ahora puedes crear instancias EC2 utilizando tu AMI personalizada como imagen base 🚀

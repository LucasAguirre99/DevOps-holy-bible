# Expansión de Espacio en Disco en Instancias AWS

Cuando levantamos una instancia a partir de una AMI (Amazon Machine Image), el espacio en disco puede estar limitado al tamaño definido en la AMI. Esto significa que, aunque hayamos adjuntado un disco adicional a la instancia, este espacio no se reflejará automáticamente. Para solucionar este problema y asignar correctamente el espacio del disco, sigue los pasos a continuación:

## Pasos para Asignar el Espacio de Disco

1. **Verificar los discos disponibles**  
    Ejecuta el siguiente comando para listar los discos y particiones, incluyendo aquellos que no están configurados correctamente:
    ```bash
    lsblk -f
    ```

2. **Expandir la partición**  
    Usa `growpart` para expandir la partición correspondiente. Por ejemplo:
    ```bash
    sudo growpart /dev/nvme0n1 3
    ```
    Si `growpart` no está instalado, instálalo con:
    ```bash
    sudo apt-get update && sudo apt-get install -y cloud-guest-utils
    ```

3. **Redimensionar el volumen físico**  
    Redimensiona el volumen físico para reflejar el nuevo tamaño:
    ```bash
    sudo pvresize /dev/nvme0n1p3
    ```

4. **Verificar el grupo de volúmenes**  
    Comprueba el estado del grupo de volúmenes:
    ```bash
    sudo vgdisplay
    ```

5. **Extender el volumen lógico**  
    Extiende el volumen lógico para usar todo el espacio libre disponible:
    ```bash
    sudo lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
    ```

6. **Redimensionar el sistema de archivos**  
    Ajusta el sistema de archivos para que utilice el nuevo espacio:
    ```bash
    sudo resize2fs /dev/ubuntu-vg/ubuntu-lv
    ```

7. **Verificar el cambio**  
    Asegúrate de que el espacio se haya asignado correctamente ejecutando nuevamente:
    ```bash
    sudo resize2fs /dev/ubuntu-vg/ubuntu-lv
    ```

## Notas Adicionales

- **Precaución**: Antes de realizar cualquier cambio en los discos, asegúrate de tener un respaldo de los datos importantes.
- **Compatibilidad**: Estos pasos están diseñados para sistemas basados en Ubuntu. Si usas otra distribución, los comandos pueden variar.
- **Documentación**: Consulta la [documentación oficial de AWS](https://docs.aws.amazon.com/) para más detalles sobre la administración de discos en instancias EC2.

Con estos pasos, deberías poder asignar correctamente el espacio de disco adicional a tu instancia y aprovechar al máximo los recursos disponibles.

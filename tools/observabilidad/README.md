# Documentación: Uso de Helmfile

## Introducción
Helmfile es una herramienta que facilita la gestión de múltiples charts de Helm en Kubernetes. Permite definir configuraciones en un archivo único y aplicar cambios de manera eficiente.

## Pasos para completar y aplicar un Helmfile

### 1. Crear un archivo `helmfile.yaml`
El archivo `helmfile.yaml` contiene la configuración de los charts de Helm que deseas instalar. A continuación, un ejemplo básico:

```yaml
repositories:
    - name: stable
        url: https://charts.helm.sh/stable

releases:
    - name: my-app
        chart: stable/my-chart
        namespace: default
        values:
            - values.yaml
```

### 2. Completar el archivo `values.yaml`
El archivo `values.yaml` contiene los valores específicos para personalizar el chart. Por ejemplo:

```yaml
replicaCount: 2
image:
    repository: my-app-image
    tag: latest
service:
    type: ClusterIP
    port: 80
```

### 3. Aplicar el Helmfile
Una vez configurados los archivos, puedes aplicar los cambios con los siguientes comandos:

```bash
# Verificar la configuración antes de aplicar
helmfile diff

# Aplicar los cambios
helmfile apply
```

### 4. Comandos adicionales
- **Actualizar dependencias**: Si el chart tiene dependencias, ejecuta `helmfile deps`.
- **Eliminar recursos**: Para eliminar los recursos instalados, usa `helmfile destroy`.

## Conclusión
Helmfile simplifica la gestión de múltiples charts en Kubernetes, permitiendo una configuración declarativa y fácil de aplicar.

## Referencias
- [Documentación oficial de Helmfile](https://github.com/helmfile/helmfile)
- [Helm Charts](https://helm.sh/docs/topics/charts/)
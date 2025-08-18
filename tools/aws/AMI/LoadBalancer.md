# Configuración de un Dominio en un LoadBalancer Administrado por Elastic Beanstalk

En este documento se detallan los pasos para resolver conflictos y configurar correctamente un dominio en un LoadBalancer administrado por Elastic Beanstalk.

## Pasos para la Configuración

### 1. Solicitar un Certificado con ACM (Certificate Manager)
- Creamos una solicitud de certificado en **AWS Certificate Manager (ACM)**.
- Esto generará dos valores que debemos agregar en nuestro proveedor de DNS como registros CNAME.
- **Nota importante**: AWS proporciona el dominio completo en el nombre del registro. Es crucial usar solo la parte correspondiente al subdominio, ya que de lo contrario, el registro no funcionará correctamente.

### 2. Crear un Registro CNAME en el Proveedor de DNS
- Una vez aceptado el certificado, procedemos a crear un registro CNAME en el proveedor de DNS.
- Este registro debe apuntar al subdominio y como valor debe llevar el DNS del LoadBalancer.

### 3. Configurar los Listeners del LoadBalancer
- Editamos los listeners del LoadBalancer:
  - Para el puerto **80**, configuramos una redirección de HTTP a HTTPS utilizando la regla 301.
  - Para el puerto **443**, configuramos el listener seleccionando el certificado que generamos previamente en ACM.

### 4. Resolver Conflictos de Redirección
- En algunos casos, puede haber un bucle de redirecciones. Esto ocurre si dentro de la instancia hay un servidor **nginx** configurado para redirigir a HTTPS.
- Si previamente se utilizó **Certbot** para generar certificados, es posible que existan configuraciones conflictivas en `/etc/nginx/conf.d`.
- Para resolverlo:
  - Edita el archivo de configuración de nginx y elimina cualquier configuración relacionada con el puerto **443** y las redirecciones.
  - Asegúrate de que nginx solo maneje tráfico HTTP y permita que el LoadBalancer gestione las redirecciones a HTTPS.

### 5. Verificar la Configuración
- Una vez realizados los pasos anteriores, verifica que el dominio funcione correctamente:
  - Accede al dominio utilizando HTTP y confirma que redirige automáticamente a HTTPS.
  - Asegúrate de que no haya errores de certificado ni bucles de redirección.

### 6. Configuración Adicional (Opcional)
- **Habilitar HTTP/2**: Si el LoadBalancer lo permite, habilita HTTP/2 para mejorar el rendimiento.
- **Configurar Políticas de Seguridad**: Asegúrate de que el LoadBalancer utilice políticas de seguridad TLS actualizadas (por ejemplo, TLS 1.2 o superior).
- **Monitoreo**: Configura alarmas en **CloudWatch** para monitorear el estado del LoadBalancer y el tráfico.

## Conclusión
Siguiendo estos pasos, puedes configurar correctamente un dominio en un LoadBalancer administrado por Elastic Beanstalk, asegurando una conexión segura y sin conflictos. Recuerda revisar periódicamente las configuraciones para mantenerlas actualizadas y seguras.
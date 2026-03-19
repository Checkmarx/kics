# Regla KICS: IBM COS Bucket Encryption (CMK/BYOK/KYOK) Manual

## Descripción General

Esta regla unificada (INFO) verifica si los buckets de **IBM Cloud Object Storage (COS)** están configurados para utilizar claves de cifrado gestionadas por el cliente, en lugar de las claves estándar gestionadas por el proveedor.

En la arquitectura de IBM Cloud, el uso del argumento `key_protect` en el recurso de Terraform es el habilitador técnico para implementar tres niveles avanzados de seguridad:

1.  **CMK (Customer Managed Key):** Utiliza claves raíz almacenadas en el servicio **Key Protect**.
2.  **BYOK (Bring Your Own Key):** Permite al cliente importar su propio material de clave generado externamente.
3.  **KYOK (Keep Your Own Key):** Ofrece el nivel más alto de aislamiento mediante el uso de **Hyper Protect Crypto Services (HPCS)** con un HSM dedicado con certificación FIPS 140-2 Nivel 4.

Si este argumento se omite, el bucket utiliza el cifrado en reposo por defecto de IBM (AES-256), donde IBM controla la rotación y el ciclo de vida de la clave. Esta regla sirve para que el auditor verifique si la sensibilidad de los datos almacenados exige un control soberano de las llaves.

## Lógica de la Regla

1.  Identifica todos los recursos de tipo `ibm_cos_bucket`.
2.  Verifica si el atributo `key_protect` está presente en la definición del bucket.
3.  Genera una alerta informativa si el atributo no existe, indicando que se está utilizando la configuración de cifrado por defecto.

## Casos de Fallo Detectados

A continuación se describe el escenario que esta política detectará.

---

### Caso 1: Cifrado Gestionado por el Proveedor (Default)

* **Descripción:** El bucket de COS ha sido configurado sin especificar una clave de seguridad del cliente. IBM Cloud cifra los datos, pero el cliente no posee el control total sobre la clave raíz.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "ibm_cos_bucket" "public_data" {
      bucket_name          = "my-bucket-standard"
      resource_instance_id = ibm_resource_instance.cos_instance.id
      storage_class        = "smart"
      region_location      = "us-south"
      
      # Falta el atributo 'key_protect'
    }
    ```
* **Ubicación de la Alerta:** Bloque del recurso `ibm_cos_bucket`.

## Recurso Involucrado

* `ibm_cos_bucket`

## Solución

Para habilitar CMK, BYOK o KYOK, debes proporcionar el CRN (Cloud Resource Name) de tu clave raíz de Key Protect o Hyper Protect en el atributo `key_protect`.

```terraform
resource "ibm_cos_bucket" "secure_storage" {
  bucket_name          = "vault-bucket-secure"
  resource_instance_id = ibm_resource_instance.cos_instance.id
  storage_class        = "smart"
  region_location      = "us-south"
  
  # Habilitar Cifrado Gestionado por el Cliente
  key_protect          = "crn:v1:bluemix:public:kms:us-south:a/aaaa:bbbb:key:cccc"
}
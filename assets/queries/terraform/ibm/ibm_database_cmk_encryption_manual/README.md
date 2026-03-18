# Regla KICS: IBM Cloud Database Without CMK (Manual)

## Descripción General

Esta regla informativa (INFO) audita los recursos `ibm_database` en Terraform para identificar instancias de la familia **IBM Cloud Databases (ICD)** que no utilizan claves de cifrado gestionadas por el cliente.

Este recurso se utiliza para aprovisionar una amplia variedad de servicios de datos gestionados, incluyendo PostgreSQL, Redis, Elasticsearch, MongoDB, etcd, entre otros. Por defecto, todas estas bases de datos cifran el almacenamiento en reposo utilizando claves gestionadas automáticamente por IBM Cloud. 

Sin embargo, para cumplir con marcos regulatorios estrictos o políticas internas de seguridad avanzadas (**CMK**, **BYOK** o **KYOK**), es imperativo que el cliente proporcione y gestione la clave raíz. Esto se logra asignando el CRN (Cloud Resource Name) de una clave proveniente de **Key Protect** o **Hyper Protect Crypto Services (HPCS)** en el argumento `key_protect_key`.

## Lógica de la Regla

La política realiza las siguientes acciones:
1.  Identifica todos los recursos de tipo `ibm_database` en el código de Terraform.
2.  Verifica si el atributo `key_protect_key` ha sido definido.
3.  Si el atributo falta, genera una alerta informativa indicando que la instancia depende del cifrado por defecto del proveedor.

## Casos de Fallo Detectados

A continuación se describe el escenario que esta política detectará.

---

### Caso 1: Cifrado por Defecto (Provider-Managed)

* **Descripción:** La base de datos ICD ha sido configurada sin asignar una clave de seguridad propia. Aunque los datos están cifrados, el cliente no tiene control sobre el ciclo de vida de la clave de cifrado de volumen.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "ibm_database" "postgres_default" {
      name     = "my-db-standard"
      service  = "databases-for-postgresql"
      plan     = "standard"
      location = "us-south"
      
      # Falta el atributo 'key_protect_key'
    }
    ```
* **Ubicación de la Alerta:** Bloque del recurso `ibm_database`.

## Recurso Involucrado

* `ibm_database`

## Solución

Para habilitar el cifrado gestionado por el cliente, asigna el CRN de una clave raíz válida de tu Vault (Key Protect o HPCS) al argumento `key_protect_key`.

```terraform
resource "ibm_database" "secure_db" {
  name              = "my-secure-postgres"
  service           = "databases-for-postgresql"
  plan              = "standard"
  location          = "us-south"
  
  # Habilitar CMK/BYOK/KYOK
  key_protect_key   = "crn:v1:bluemix:public:kms:us-south:a/aaaa:bbbb:key:cccc"
}
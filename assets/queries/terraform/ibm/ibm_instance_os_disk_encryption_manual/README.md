# Regla KICS: IBM Instance OS Disk Encryption (Manual)

## Descripción General

Esta regla informativa (INFO) audita las instancias de servidor virtual (**VSI**) de la infraestructura VPC (`ibm_is_instance`) para verificar que el cifrado del disco de arranque esté bajo el control del cliente.

Por defecto, IBM Cloud cifra el volumen de arranque (boot volume) de cada instancia utilizando claves gestionadas por el proveedor. Sin embargo, para cumplir con estándares de seguridad avanzados como **FIPS 140-2**, o normativas financieras y gubernamentales, se requiere el uso de **Customer Managed Keys (CMK)** o **Keep Your Own Key (KYOK)**. 

Al proporcionar el CRN de una clave de **Key Protect** o **Hyper Protect Crypto Services** en la configuración de la instancia, el cliente obtiene la capacidad de revocar el acceso a los datos del sistema operativo de forma instantánea.

## Lógica de la Regla

La política evalúa el recurso `ibm_is_instance` bajo dos escenarios:
1.  **Ausencia de Configuración de Volumen:** Si el bloque `boot_volume` no está presente, la instancia se crea con parámetros por defecto (cifrado gestionado por IBM).
2.  **Ausencia de Clave de Cifrado:** Si el bloque `boot_volume` existe pero el parámetro `encryption` no está definido, se considera que el volumen no está utilizando claves gestionadas por el cliente.

## Casos de Fallo Detectados

A continuación se describen los escenarios que esta política detectará.

---

### Caso 1: Cifrado por Defecto (Bloque Ausente)
* **Descripción:** No se define configuración de disco de arranque, delegando el cifrado a IBM Cloud.
* **Ubicación de la Alerta:** Bloque del recurso `ibm_is_instance`.

### Caso 2: Cifrado por Defecto (Atributo Ausente)
* **Descripción:** Se configura el volumen de arranque pero se omite la clave de cifrado.
* **Ubicación de la Alerta:** Atributo `boot_volume`.

## Recurso Involucrado

* `ibm_is_instance`

## Solución

Defina el bloque `boot_volume` e incluya el CRN de su clave raíz de Key Protect en el argumento `encryption`.

```terraform
resource "ibm_is_instance" "secure_vsi" {
  name    = "secure-production-server"
  image   = "r006-723f851b-4043-42e5-9467-33a39e802375"
  profile = "bx2-2x8"

  boot_volume {
    name       = "os-disk-secure"
    encryption = "crn:v1:bluemix:public:kms:us-south:a/aaaa:bbbb:key:cccc"
  }
  
  # ... otros parámetros de red y vpc ...
}
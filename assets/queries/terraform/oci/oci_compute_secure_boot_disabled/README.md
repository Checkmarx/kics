# Regla KICS: Secure Boot Habilitado en Instancias de Cómputo de OCI

## Descripción General

Esta regla de KICS para Terraform asegura que todas las instancias de cómputo de OCI (`oci_core_instance`) que lo soporten tengan la funcionalidad de "Arranque Seguro" (Secure Boot) habilitada.

Secure Boot es un estándar de seguridad desarrollado por la industria para asegurar que un dispositivo arranque utilizando únicamente software de confianza del fabricante del equipo original (OEM).  Cuando el PC arranca, el firmware comprueba la firma de cada pieza de software de arranque, incluido el sistema operativo. Si las firmas son válidas, el PC arranca y el firmware cede el control al sistema operativo. Habilitarlo protege contra malware a nivel de arranque como los rootkits.

## Lógica de la Regla

La política verifica la presencia y configuración del atributo `is_secure_boot_enabled` dentro del bloque `shape_config`.

## Casos de Fallo Detectados

A continuación se describen los tres escenarios que esta política detectará.

---
### Caso 1: Bloque `shape_config` Ausente

* **Descripción:** El recurso `oci_core_instance` no define el bloque `shape_config`. Por defecto, esto implica que Secure Boot está deshabilitado.
* **Ejemplo:**
    ```terraform
    resource "oci_core_instance" "test" {
      # Falta el bloque shape_config
    }
    ```
* **Ubicación de la Alerta:** Bloque del recurso `oci_core_instance`.

---
### Caso 2: Atributo Ausente en `shape_config`

* **Descripción:** El bloque `shape_config` existe, pero no contiene el atributo `is_secure_boot_enabled`. El valor por defecto es `false`.
* **Ejemplo:**
    ```terraform
    resource "oci_core_instance" "test" {
      shape_config {
        # Falta is_secure_boot_enabled
        ocpus = 1
      }
    }
    ```
* **Ubicación de la Alerta:** Bloque `shape_config`.

---
### Caso 3: Atributo Configurado como `false`

* **Descripción:** El atributo `is_secure_boot_enabled` está presente pero explícitamente configurado como `false`.
* **Ejemplo:**
    ```terraform
    resource "oci_core_instance" "test" {
      shape_config {
        is_secure_boot_enabled = false # <-- ¡PROBLEMA!
      }
    }
    ```
* **Ubicación de la Alerta:** Línea del atributo `is_secure_boot_enabled`.

## Recurso Involucrado

* `oci_core_instance`

## Solución

Para solucionar los problemas detectados, asegúrate de que cada recurso `oci_core_instance` incluya un bloque `shape_config` con el atributo `is_secure_boot_enabled` configurado en `true`.

```terraform
resource "oci_core_instance" "test_instance_correct" {
  # ... otros atributos ...
  
  shape_config {
    is_secure_boot_enabled = true
  }
}
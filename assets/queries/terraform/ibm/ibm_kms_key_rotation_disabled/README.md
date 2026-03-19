# Regla KICS: Rotación Automática de Claves en IBM Key Protect

## Descripción General

Esta regla de KICS para Terraform asegura que todas las claves gestionadas por el cliente (`ibm_kms_key`) en **IBM Key Protect** tengan una política de rotación automática habilitada y configurada correctamente.

La rotación periódica de claves criptográficas es una práctica de seguridad fundamental que responde al principio de **Criptografía Ágil**. El objetivo principal es limitar el "radio de explosión" (blast radius): al rotar la clave periódicamente, se reduce drásticamente la cantidad de datos que podrían ser descifrados en el hipotético caso de que el material de una clave específica se viera comprometido. Además, forzar rotaciones regulares garantiza que los procesos operativos sean capaces de manejar el ciclo de vida de las claves sin depender de una única clave estática de duración indefinida.

## Lógica de la Regla

La política audita el recurso `ibm_kms_key` cubriendo tres escenarios de riesgo:
1.  **Ausencia de Bloque:** Detecta si no se ha definido el bloque `rotation_policy`.
2.  **Atributo Faltante:** Detecta si el bloque existe pero omite el intervalo de tiempo.
3.  **Valor Inválido/Cero:** Detecta si el intervalo se ha configurado en `0`, lo cual desactiva funcionalmente la rotación.

## Casos de Fallo Detectados

A continuación se describen los tres escenarios que esta política detectará.

---

### Caso 1: Bloque `rotation_policy` Ausente
* **Descripción:** El recurso de clave existe pero no contiene ninguna instrucción de rotación automática.
* **Ejemplo de Código Terraform:**
    ```terraform
    resource "ibm_kms_key" "key_static" {
      instance_id  = "instance-id"
      key_name     = "static-key"
      standard_key = false
    }
    ```
* **Ubicación de la Alerta:** Bloque del recurso `ibm_kms_key`.

---

### Caso 2: Atributo `rotation_interval_month` Ausente
* **Descripción:** Se define la política pero no se especifica cada cuántos meses debe ocurrir la rotación.
* **Ubicación de la Alerta:** Bloque `rotation_policy`.

---

### Caso 3: Intervalo de Rotación en Cero
* **Descripción:** El intervalo está configurado en `0`, lo que inhabilita la automatización del ciclo de vida.
* **Ubicación de la Alerta:** Atributo `rotation_interval_month`.

## Recurso Involucrado

* `ibm_kms_key`

## Solución

Defina un bloque `rotation_policy` con un intervalo válido de entre 1 y 12 meses.

```terraform
resource "ibm_kms_key" "key_compliant" {
  instance_id  = ibm_resource_instance.kms_instance.guid
  key_name     = "secure-rotating-key"
  standard_key = false

  rotation_policy {
    rotation_interval_month = 6 # Rota cada semestre
  }
}
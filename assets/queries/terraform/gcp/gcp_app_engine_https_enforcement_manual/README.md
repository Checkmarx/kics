# Regla KICS: App Engine HTTPS Enforcement (Manual)

## Descripción General

Esta regla de auditoría verifica que las aplicaciones desplegadas en **Google App Engine** (Standard Environment) fuercen el uso exclusivo de conexiones cifradas mediante **HTTPS**.

Servir contenido a través de HTTP sin cifrar expone los datos confidenciales de los usuarios y las credenciales de sesión a intercepciones. Para mitigar este riesgo, App Engine permite configurar una redirección automática de HTTP a HTTPS. 

Dado que App Engine suele utilizar un archivo de configuración externo (`app.yaml`) para definir el comportamiento de red, esta regla actúa como un control de gobierno que alerta si la política no está explícitamente definida en la infraestructura como código (Terraform) o si requiere una inspección manual de los artefactos de despliegue.

## Lógica de la Regla

La política evalúa el recurso `google_app_engine_standard_app_version` bajo dos escenarios:
1.  **Configuración en Terraform:** Si el bloque `handlers` está presente, se asegura de que el atributo `security_level` esté configurado como `SECURE_ALWAYS`. Cualquier otro valor (como `SECURE_OPTIONAL`) disparará una alerta.
2.  **Configuración Externa:** Si no se definen `handlers` en Terraform, la regla genera una alerta informativa (**INFO**) indicando que el cumplimiento depende de la configuración dentro del archivo `app.yaml` de la aplicación.

## Casos de Fallo Detectados

A continuación se describen los escenarios que esta política detectará.

---

### Caso 1: Nivel de Seguridad Inadecuado en Terraform
* **Descripción:** Los manejadores de URL permiten tráfico HTTP o no fuerzan la redirección segura.
* **Ubicación de la Alerta:** Atributo `handlers` dentro del recurso App Engine.

### Caso 2: Verificación Manual de Archivos de Configuración
* **Descripción:** Terraform no gestiona la lógica de rutas. Se requiere validar el código fuente.
* **Acción Requerida:** Confirmar que en `app.yaml` todos los handlers críticos contengan:
    ```yaml
    secure: always
    ```
* **Ubicación de la Alerta:** Nivel de recurso `google_app_engine_standard_app_version`.

## Recurso Involucrado

* `google_app_engine_standard_app_version`

## Solución

Para forzar HTTPS desde Terraform, configure el `security_level` en cada handler:

```terraform
resource "google_app_engine_standard_app_version" "secure_app" {
  service    = "api-service"
  version_id = "v2"
  runtime    = "nodejs18"

  handlers {
    url_regex = "/.*"
    script {
      script_path = "auto"
    }
    # Solución técnica
    security_level = "SECURE_ALWAYS" 
  }
}
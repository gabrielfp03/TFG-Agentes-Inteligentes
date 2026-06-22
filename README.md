# Paquita · Agente autónomo de IA para la gestión inteligente de negocios

Agente autónomo basado en un modelo de lenguaje de gran escala (LLM), construido
íntegramente con tecnologías de código abierto (**Langflow** + **Docker**), capaz de
automatizar la **gestión de clientes (CRM)** y la **estrategia de redes sociales**
de una pyme.

El caso de estudio es una joyería ficticia ("Pendientes Paquita"), pero el sistema
está diseñado para ser **replicable en cualquier sector**: basta con reescribir el
*System Prompt* y poblar las bases de datos. Este repositorio acompaña al Trabajo de
Fin de Grado del Doble Grado en Ingeniería Informática y ADE.

---

## Funcionalidades

**Módulo CRM**
- Lectura de correo (Gmail/IMAP) y generación autónoma de **borradores** de respuesta.
- Gestión de clientes e inventario sobre bases de datos locales (SQLite).
- Agendado de citas en Google Calendar con resolución de conflictos de horario.
- Creación automática de tareas internas en Google Tasks, clasificadas por prioridad.
- Rutinas de fidelización (cumpleaños, clientes recurrentes).

**Módulo de Redes Sociales**
- Difusión de ofertas y novedades por **Telegram**.
- Operativa bidireccional en **Mastodon**: publicar, leer menciones, programar y *social listening*.
- Clasificación de menciones (agradecimiento / duda / queja) mediante *Zero-Shot Classification*.
- Generación de informes analíticos mensuales con propuestas estratégicas.

---

## Arquitectura

```
Usuario ──▶ Langflow (Docker) ──▶ Agente Tool Calling ──▶ Gemini (LLM)
                                          │
                                          ├─ Componentes Python (herramientas)
                                          │     ├─ SQLite (clientes, inventario)
                                          │     ├─ Gmail (IMAP), Google Calendar/Tasks
                                          │     │     └─ vía pasarela Google Apps Script
                                          │     ├─ Telegram (API de bots)
                                          │     └─ Mastodon (API REST)
                                          └─ System Prompt externo (prompt_paquita.md)
```

---

## Estructura del repositorio

```
.
├── README.md
├── .env.example              # plantilla de credenciales
├── docker/
│   ├── Dockerfile            # imagen de Langflow + dependencias
│   └── docker-compose.yml    # Langflow + PostgreSQL
├── flow/
│   └── Pendientes_Paquitas.json   # flujo del agente (importar en Langflow)
├── prompt/
│   └── prompt_paquita.md     # System Prompt (personalidad y lógica)
├── bd/
│   ├── crm_pyme.db           # base de datos de clientes (datos de demo)
│   └── inventario_pyme.db    # base de datos de inventario (datos de demo)
├── apps_script/
│   └── webhook.gs            # pasarela hacia Calendar, Tasks y Gmail
├── panel/                    # utilidades de arranque (Windows)
│   ├── Panel_De_Control.bat
│   ├── subida_prompt.bat
│   └── bd.bat
└── sprints/                  # actas del desarrollo (metodología ágil)            
```

---

## Requisitos previos

- [Docker](https://www.docker.com/) y Docker Compose.
- Una clave de API de **Google Gemini**.
- Cuenta de **Gmail** con una *contraseña de aplicación* (para IMAP).
- Un bot de **Telegram** (creado con [@BotFather](https://t.me/BotFather)) y un canal.
- Una cuenta de **Mastodon** con un token de acceso de aplicación.
- (Opcional) [ngrok](https://ngrok.com/) para exponer el servicio en desarrollo.

---

## Instalación y despliegue

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/gabrielfp03/TFG-Agentes-Inteligentes.git
   cd TFG-Paquita
   ```

2. **Configurar las credenciales**
   ```bash
   cp .env.example .env
   ```
   Edita `.env` y rellena tus tokens (Gemini, Gmail, Telegram, Mastodon y las URLs
   de los webhooks de Apps Script).

3. **Levantar Langflow con Docker**
   ```bash
   cd docker
   docker compose up -d
   ```
   Langflow quedará disponible en <http://localhost:7860>.

4. **Importar el agente**
   En la interfaz de Langflow, importa `flow/Pendientes_Paquitas.json`. Los
   componentes personalizados se reconstruyen automáticamente.

5. **Colocar los datos y el prompt**
   Asegúrate de que el contenedor tiene acceso (volúmenes) a `prompt/prompt_paquita.md`
   y a las bases de datos de `bd/`. Ajusta las rutas en `.env` si es necesario.

6. **Desplegar la pasarela de Google (Apps Script)**
   Crea un proyecto en [Google Apps Script](https://script.google.com), pega el código
   de `apps_script/webhook.gs`, despliégalo como *aplicación web* y copia las URLs
   `/exec` resultantes en tu `.env`.

7. **(Opcional, Windows) Arranque automatizado**
   Ejecuta `panel/Panel_De_Control.bat` para iniciar Docker, subir el prompt y
   sincronizar las bases de datos con un doble clic.

---

## Adaptar el sistema a otra pyme

Toda la lógica de negocio vive en dos sitios; no hace falta tocar el código:

1. **`prompt/prompt_paquita.md`** — reescribe identidad, catálogo, horarios, voz de
   marca y reglas de actuación.
2. **`bd/*.db`** — sustituye los datos de clientes e inventario por los del nuevo negocio.

---

## Tecnologías

Langflow · Docker · Python · SQLite · Google Gemini · Gmail (IMAP) ·
Google Calendar / Tasks (Apps Script) · Telegram Bot API · Mastodon API.

---

## Seguridad

- **Nunca** subas el fichero `.env` ni tokens reales al repositorio (ya están en `.gitignore`).
- Las credenciales de ejemplo de este repositorio son ficticias.
- Si clonas datos de clientes reales, ten en cuenta el RGPD: mantén las bases de datos
  en local y bajo control del negocio.

---

## Licencia

Proyecto académico (Trabajo de Fin de Grado). Uso educativo.

## Autor

Gabriel Filipov Petkov — Doble Grado en Ingeniería Informática y ADE.

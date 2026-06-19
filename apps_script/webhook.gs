/**
 * ============================================================
 *  Paquita · Pasarelas (API Gateway) en Google Apps Script
 * ------------------------------------------------------------
 *  El proyecto utiliza DOS aplicaciones web de Apps Script
 *  INDEPENDIENTES, cada una con su propio doPost() y su propia
 *  URL .../exec. Por tanto, cada bloque de este fichero debe
 *  pegarse en un PROYECTO DISTINTO de https://script.google.com
 *  (no pueden convivir dos doPost en el mismo proyecto).
 *
 *    · PROYECTO 1 — Google Tasks  -> .env: APPSCRIPT_WEBHOOK_TAREAS
 *    · PROYECTO 2 — Google Calendar -> .env: APPSCRIPT_WEBHOOK_CITAS
 *                                      (la misma URL sirve para cancelar)
 *
 *  Despliegue (en cada proyecto):
 *    Implementar > Nueva implementación > Aplicación web
 *      - Ejecutar como: Yo
 *      - Acceso: Cualquier usuario
 *    En el PROYECTO 1, añade además el servicio avanzado "Tasks API".
 * ============================================================
 */


/* ============================================================
 *  PROYECTO 1 — GOOGLE TASKS (gestión de tareas multilista)
 *  Payload esperado: { "titulo": ..., "lista": ..., "notas": ... }
 *  Requiere el servicio avanzado "Tasks API" habilitado.
 * ============================================================ */
function doPost(e) {
  try {
    var params = JSON.parse(e.postData.contents);
    var titulo = params.titulo;
    var notas = params.notas || "";
    var nombreLista = params.lista || "General"; // Nombre de la lista que enviará el agente

    // 1. Obtener todas las listas de tareas actuales
    var taskLists = Tasks.Tasklists.list().items;
    var listaId = null;

    // 2. Buscar si ya existe una lista con ese nombre
    if (taskLists) {
      for (var i = 0; i < taskLists.length; i++) {
        if (taskLists[i].title.toUpperCase() === nombreLista.toUpperCase()) {
          listaId = taskLists[i].id;
          break;
        }
      }
    }

    // 3. Si no existe, crear la nueva lista
    if (!listaId) {
      var nuevaLista = Tasks.Tasklists.insert({title: nombreLista});
      listaId = nuevaLista.id;
    }

    // 4. Insertar la tarea en la lista encontrada o creada
    var task = {
      title: titulo,
      notes: notas
    };
    var result = Tasks.Tasks.insert(task, listaId);

    return ContentService.createTextOutput("ÉXITO: Tarea en lista '" + nombreLista + "' (ID: " + result.id + ")");

  } catch (error) {
    return ContentService.createTextOutput("ERROR en Apps Script: " + error.toString());
  }
}


/* ============================================================
 *  PROYECTO 2 — GOOGLE CALENDAR (agendar / cancelar citas)
 *  Payload esperado:
 *    { "secreto": "...", "accion": "agendar"|"cancelar",
 *      "cliente": ..., "servicio": ..., "fecha_hora": "YYYY-MM-DDTHH:MM:SS" }
 *
 *  NOTA DE SEGURIDAD: sustituye "TU_SECRETO" por una clave propia y
 *  envía ese mismo valor desde el componente de Langflow. No publiques
 *  el secreto real en el repositorio.
 *
 *  >>> Pega esta función como doPost() en su PROPIO proyecto. <<<
 * ============================================================ */
function doPost_Calendario(e) {
  try {
    var params = JSON.parse(e.postData.contents);

    // Filtro de seguridad
    if (params.secreto !== "TU_SECRETO") {
      return ContentService.createTextOutput("Error: No autorizado");
    }

    var calendar = CalendarApp.getDefaultCalendar();
    var fechaInicio = new Date(params.fecha_hora);
    // Las citas duran 1 hora
    var fechaFin = new Date(fechaInicio.getTime() + (60 * 60 * 1000));

    // --- ACCIÓN 1: AGENDAR CITA ---
    if (params.accion === "agendar") {
      // 1. Comprobar si hay conflictos (eventos que se solapan en esa hora)
      var eventosExistentes = calendar.getEvents(fechaInicio, fechaFin);
      if (eventosExistentes.length > 0) {
        return ContentService.createTextOutput("ERROR_OCUPADO: Ya existe una cita reservada en ese horario. Dile al cliente que está ocupado y sugiere al cliente que tenemos disponibilidad una hora más tarde o una hora antes.");
      }

      // 2. Si está libre, la creamos
      var titulo = "Cita: " + params.cliente + " - " + params.servicio;
      calendar.createEvent(titulo, fechaInicio, fechaFin);
      return ContentService.createTextOutput("ÉXITO: Cita agendada correctamente en el calendario.");
    }

    // --- ACCIÓN 2: CANCELAR CITA ---
    else if (params.accion === "cancelar") {
      var eventos = calendar.getEvents(fechaInicio, fechaFin);
      var cancelados = 0;

      for (var i = 0; i < eventos.length; i++) {
        // Buscamos si el evento contiene el nombre del cliente para no borrar el de otra persona por error
        if (eventos[i].getTitle().toLowerCase().indexOf(params.cliente.toLowerCase()) !== -1) {
          eventos[i].deleteEvent();
          cancelados++;
        }
      }

      if (cancelados > 0) {
        return ContentService.createTextOutput("ÉXITO: Cita cancelada y borrada del calendario.");
      } else {
        return ContentService.createTextOutput("ERROR_NO_ENCONTRADA: No se encontró ninguna cita a nombre de " + params.cliente + " en esa fecha y hora.");
      }
    }

    else {
      return ContentService.createTextOutput("Error: Acción no reconocida.");
    }

  } catch (error) {
    return ContentService.createTextOutput("Error interno: " + error.toString());
  }
}

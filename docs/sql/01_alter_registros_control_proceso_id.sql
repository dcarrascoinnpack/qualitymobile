-- =============================================================
-- Quality Control Faret — agregar proceso_id a registros_control
-- =============================================================
-- Contexto: registros_control hoy NO tiene columna proceso_id
-- (verificado contra el modelo real del backend). Flutter ya
-- selecciona "Proceso" (cat_procesos) en FaretHomePage y lo envía
-- en el payload de POST /api/registros-control como "procesoId".
-- El backend (apiqualitycontrolfaret) ya fue actualizado en código
-- para leer/escribir esta columna — falta aplicar el cambio en la
-- base de datos real.
--
-- IMPORTANTE: este script NO fue ejecutado por el asistente.
-- Revísalo y ejecútalo tú mismo en el MySQL de producción
-- (192.168.1.70 / qualitycontrolfaret) cuando estés listo.
-- =============================================================

-- 1) Agregar la columna (nullable: las filas históricas quedarán en NULL)
ALTER TABLE registros_control
ADD COLUMN proceso_id INT NULL AFTER area_id;

-- 2) Foreign key hacia el catálogo de procesos
ALTER TABLE registros_control
ADD CONSTRAINT fk_registros_control_proceso
FOREIGN KEY (proceso_id) REFERENCES cat_procesos(id);

-- 3) Verificación rápida post-cambio
DESCRIBE registros_control;
SELECT COUNT(*) AS total_registros, SUM(proceso_id IS NULL) AS sin_proceso FROM registros_control;

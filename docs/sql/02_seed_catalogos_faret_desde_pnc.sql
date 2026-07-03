-- =============================================================
-- Quality Control Faret — seed de catálogos maestros
-- Generado automáticamente a partir de docs/REG-SGI-PNC 2026 - Gestion de Calidad.xlsx
-- (hoja "BASE DE DATOS", 247 filas históricas de PNC)
-- =============================================================
-- IMPORTANTE: este script NO fue ejecutado. Revísalo fila por fila
-- antes de correrlo. Las secciones "REQUIERE REVISION" están
-- comentadas a propósito: no se pudo normalizar con certeza.
-- =============================================================

START TRANSACTION;

-- ── ÁREAS ─────────────────────────────────────────────────────
INSERT INTO cat_areas (codigo, nombre) SELECT 'ADQUISICIONES', 'ADQUISICIONES' WHERE NOT EXISTS (SELECT 1 FROM cat_areas WHERE nombre = 'ADQUISICIONES');
INSERT INTO cat_areas (codigo, nombre) SELECT 'CALIDAD', 'CALIDAD' WHERE NOT EXISTS (SELECT 1 FROM cat_areas WHERE nombre = 'CALIDAD');
INSERT INTO cat_areas (codigo, nombre) SELECT 'CARGA_DE_ARCHIVO', 'CARGA DE ARCHIVO' WHERE NOT EXISTS (SELECT 1 FROM cat_areas WHERE nombre = 'CARGA DE ARCHIVO');
INSERT INTO cat_areas (codigo, nombre) SELECT 'COMERCIAL', 'COMERCIAL' WHERE NOT EXISTS (SELECT 1 FROM cat_areas WHERE nombre = 'COMERCIAL');
INSERT INTO cat_areas (codigo, nombre) SELECT 'COTIZACION', 'COTIZACION' WHERE NOT EXISTS (SELECT 1 FROM cat_areas WHERE nombre = 'COTIZACION');
INSERT INTO cat_areas (codigo, nombre) SELECT 'DESARROLLO', 'DESARROLLO' WHERE NOT EXISTS (SELECT 1 FROM cat_areas WHERE nombre = 'DESARROLLO');
INSERT INTO cat_areas (codigo, nombre) SELECT 'DIMENSIONADO', 'DIMENSIONADO' WHERE NOT EXISTS (SELECT 1 FROM cat_areas WHERE nombre = 'DIMENSIONADO');
INSERT INTO cat_areas (codigo, nombre) SELECT 'EDICI_N', 'EDICIÓN' WHERE NOT EXISTS (SELECT 1 FROM cat_areas WHERE nombre = 'EDICIÓN');
INSERT INTO cat_areas (codigo, nombre) SELECT 'EMPLACADO', 'EMPLACADO' WHERE NOT EXISTS (SELECT 1 FROM cat_areas WHERE nombre = 'EMPLACADO');
INSERT INTO cat_areas (codigo, nombre) SELECT 'FOLIA', 'FOLIA' WHERE NOT EXISTS (SELECT 1 FROM cat_areas WHERE nombre = 'FOLIA');
INSERT INTO cat_areas (codigo, nombre) SELECT 'LOGISTICA', 'LOGISTICA' WHERE NOT EXISTS (SELECT 1 FROM cat_areas WHERE nombre = 'LOGISTICA');
INSERT INTO cat_areas (codigo, nombre) SELECT 'PEGADO_FARMA', 'PEGADO FARMA' WHERE NOT EXISTS (SELECT 1 FROM cat_areas WHERE nombre = 'PEGADO FARMA');
INSERT INTO cat_areas (codigo, nombre) SELECT 'PEGADO_INDUSTRIAL', 'PEGADO INDUSTRIAL' WHERE NOT EXISTS (SELECT 1 FROM cat_areas WHERE nombre = 'PEGADO INDUSTRIAL');
INSERT INTO cat_areas (codigo, nombre) SELECT 'PRE_PRENSA', 'PRE-PRENSA' WHERE NOT EXISTS (SELECT 1 FROM cat_areas WHERE nombre = 'PRE-PRENSA');
INSERT INTO cat_areas (codigo, nombre) SELECT 'PRENSA', 'PRENSA' WHERE NOT EXISTS (SELECT 1 FROM cat_areas WHERE nombre = 'PRENSA');
INSERT INTO cat_areas (codigo, nombre) SELECT 'PRENSA_TROQUEL', 'PRENSA / TROQUEL' WHERE NOT EXISTS (SELECT 1 FROM cat_areas WHERE nombre = 'PRENSA / TROQUEL');
INSERT INTO cat_areas (codigo, nombre) SELECT 'PRENSA_EMPLACADO', 'PRENSA EMPLACADO' WHERE NOT EXISTS (SELECT 1 FROM cat_areas WHERE nombre = 'PRENSA EMPLACADO');
INSERT INTO cat_areas (codigo, nombre) SELECT 'SGI', 'SGI' WHERE NOT EXISTS (SELECT 1 FROM cat_areas WHERE nombre = 'SGI');
INSERT INTO cat_areas (codigo, nombre) SELECT 'TALLER_EXTERNO', 'TALLER EXTERNO' WHERE NOT EXISTS (SELECT 1 FROM cat_areas WHERE nombre = 'TALLER EXTERNO');
INSERT INTO cat_areas (codigo, nombre) SELECT 'TERMOFORMADO', 'TERMOFORMADO' WHERE NOT EXISTS (SELECT 1 FROM cat_areas WHERE nombre = 'TERMOFORMADO');
INSERT INTO cat_areas (codigo, nombre) SELECT 'TERMOLAMINADO', 'TERMOLAMINADO' WHERE NOT EXISTS (SELECT 1 FROM cat_areas WHERE nombre = 'TERMOLAMINADO');
INSERT INTO cat_areas (codigo, nombre) SELECT 'TROQUEL', 'TROQUEL' WHERE NOT EXISTS (SELECT 1 FROM cat_areas WHERE nombre = 'TROQUEL');

-- ── MÁQUINAS ──────────────────────────────────────────────────
INSERT INTO cat_maquinas (area_id, nombre) SELECT a.id, '104-1' FROM cat_areas a WHERE a.nombre = 'TROQUEL' AND NOT EXISTS (SELECT 1 FROM cat_maquinas m WHERE m.nombre = '104-1' AND m.area_id = a.id);
INSERT INTO cat_maquinas (area_id, nombre) SELECT a.id, '104-2' FROM cat_areas a WHERE a.nombre = 'TROQUEL' AND NOT EXISTS (SELECT 1 FROM cat_maquinas m WHERE m.nombre = '104-2' AND m.area_id = a.id);
INSERT INTO cat_maquinas (area_id, nombre) SELECT a.id, '106-1' FROM cat_areas a WHERE a.nombre = 'TROQUEL' AND NOT EXISTS (SELECT 1 FROM cat_maquinas m WHERE m.nombre = '106-1' AND m.area_id = a.id);
INSERT INTO cat_maquinas (area_id, nombre) SELECT a.id, 'ALPINA' FROM cat_areas a WHERE a.nombre = 'FOLIA' AND NOT EXISTS (SELECT 1 FROM cat_maquinas m WHERE m.nombre = 'ALPINA' AND m.area_id = a.id);
INSERT INTO cat_maquinas (area_id, nombre) SELECT a.id, 'ALPINA 110' FROM cat_areas a WHERE a.nombre = 'PEGADO INDUSTRIAL' AND NOT EXISTS (SELECT 1 FROM cat_maquinas m WHERE m.nombre = 'ALPINA 110' AND m.area_id = a.id);
INSERT INTO cat_maquinas (area_id, nombre) SELECT a.id, 'AQUA 120' FROM cat_areas a WHERE a.nombre = 'TERMOLAMINADO' AND NOT EXISTS (SELECT 1 FROM cat_maquinas m WHERE m.nombre = 'AQUA 120' AND m.area_id = a.id);
INSERT INTO cat_maquinas (area_id, nombre) SELECT a.id, 'AQUA 120 WEN CHYAN' FROM cat_areas a WHERE a.nombre = 'TERMOLAMINADO' AND NOT EXISTS (SELECT 1 FROM cat_maquinas m WHERE m.nombre = 'AQUA 120 WEN CHYAN' AND m.area_id = a.id);
INSERT INTO cat_maquinas (area_id, nombre) SELECT a.id, 'AQUA WEN CHYUAN' FROM cat_areas a WHERE a.nombre = 'TERMOLAMINADO' AND NOT EXISTS (SELECT 1 FROM cat_maquinas m WHERE m.nombre = 'AQUA WEN CHYUAN' AND m.area_id = a.id);
INSERT INTO cat_maquinas (area_id, nombre) SELECT a.id, 'BOBST 106-2' FROM cat_areas a WHERE a.nombre = 'TROQUEL' AND NOT EXISTS (SELECT 1 FROM cat_maquinas m WHERE m.nombre = 'BOBST 106-2' AND m.area_id = a.id);
INSERT INTO cat_maquinas (area_id, nombre) SELECT a.id, 'CD 102' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_maquinas m WHERE m.nombre = 'CD 102' AND m.area_id = a.id);
INSERT INTO cat_maquinas (area_id, nombre) SELECT a.id, 'DIANA' FROM cat_areas a WHERE a.nombre = 'PEGADO INDUSTRIAL' AND NOT EXISTS (SELECT 1 FROM cat_maquinas m WHERE m.nombre = 'DIANA' AND m.area_id = a.id);
INSERT INTO cat_maquinas (area_id, nombre) SELECT a.id, 'DIANA 3' FROM cat_areas a WHERE a.nombre = 'PEGADO INDUSTRIAL' AND NOT EXISTS (SELECT 1 FROM cat_maquinas m WHERE m.nombre = 'DIANA 3' AND m.area_id = a.id);
INSERT INTO cat_maquinas (area_id, nombre) SELECT a.id, 'DIANA 5' FROM cat_areas a WHERE a.nombre = 'PEGADO INDUSTRIAL' AND NOT EXISTS (SELECT 1 FROM cat_maquinas m WHERE m.nombre = 'DIANA 5' AND m.area_id = a.id);
INSERT INTO cat_maquinas (area_id, nombre) SELECT a.id, 'DIANA 7' FROM cat_areas a WHERE a.nombre = 'PEGADO INDUSTRIAL' AND NOT EXISTS (SELECT 1 FROM cat_maquinas m WHERE m.nombre = 'DIANA 7' AND m.area_id = a.id);
INSERT INTO cat_maquinas (area_id, nombre) SELECT a.id, 'DIANA EXPERFOLD' FROM cat_areas a WHERE a.nombre = 'PEGADO INDUSTRIAL' AND NOT EXISTS (SELECT 1 FROM cat_maquinas m WHERE m.nombre = 'DIANA EXPERFOLD' AND m.area_id = a.id);
-- REQUIERE REVISION: máquina "DIANA PRO 2" aparece en varias áreas: PEGADO FARMA, CALIDAD
-- INSERT INTO cat_maquinas (area_id, nombre) SELECT a.id, 'DIANA PRO 2' FROM cat_areas a WHERE a.nombre = 'PEGADO FARMA' AND NOT EXISTS (SELECT 1 FROM cat_maquinas m WHERE m.nombre = 'DIANA PRO 2' AND m.area_id = a.id);
INSERT INTO cat_maquinas (area_id, nombre) SELECT a.id, 'DIANA V' FROM cat_areas a WHERE a.nombre = 'PEGADO INDUSTRIAL' AND NOT EXISTS (SELECT 1 FROM cat_maquinas m WHERE m.nombre = 'DIANA V' AND m.area_id = a.id);
-- REQUIERE REVISION: máquina "DISCOVER CILINDRICA (SFM)" nombre ambiguo/compuesto, revisar manualmente
-- INSERT INTO cat_maquinas (area_id, nombre) SELECT a.id, 'DISCOVER CILINDRICA (SFM)' FROM cat_areas a WHERE a.nombre = 'TERMOFORMADO' AND NOT EXISTS (SELECT 1 FROM cat_maquinas m WHERE m.nombre = 'DISCOVER CILINDRICA (SFM)' AND m.area_id = a.id);
-- REQUIERE REVISION: máquina "EXPERFOLD" aparece en varias áreas: PEGADO INDUSTRIAL, PEGADO FARMA
-- INSERT INTO cat_maquinas (area_id, nombre) SELECT a.id, 'EXPERFOLD' FROM cat_areas a WHERE a.nombre = 'PEGADO INDUSTRIAL' AND NOT EXISTS (SELECT 1 FROM cat_maquinas m WHERE m.nombre = 'EXPERFOLD' AND m.area_id = a.id);
INSERT INTO cat_maquinas (area_id, nombre) SELECT a.id, 'EXPERTFOLD' FROM cat_areas a WHERE a.nombre = 'PEGADO INDUSTRIAL' AND NOT EXISTS (SELECT 1 FROM cat_maquinas m WHERE m.nombre = 'EXPERTFOLD' AND m.area_id = a.id);
-- REQUIERE REVISION: máquina "IBERICA KBA 144-1 (DA)" nombre ambiguo/compuesto, revisar manualmente
-- INSERT INTO cat_maquinas (area_id, nombre) SELECT a.id, 'IBERICA KBA 144-1 (DA)' FROM cat_areas a WHERE a.nombre = 'TROQUEL' AND NOT EXISTS (SELECT 1 FROM cat_maquinas m WHERE m.nombre = 'IBERICA KBA 144-1 (DA)' AND m.area_id = a.id);
INSERT INTO cat_maquinas (area_id, nombre) SELECT a.id, 'KBA 1' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_maquinas m WHERE m.nombre = 'KBA 1' AND m.area_id = a.id);
INSERT INTO cat_maquinas (area_id, nombre) SELECT a.id, 'KBA 145/164' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_maquinas m WHERE m.nombre = 'KBA 145/164' AND m.area_id = a.id);
-- REQUIERE REVISION: máquina "KBA 145/164 AGNATI 145 (DA)" nombre ambiguo/compuesto, revisar manualmente
-- INSERT INTO cat_maquinas (area_id, nombre) SELECT a.id, 'KBA 145/164 AGNATI 145 (DA)' FROM cat_areas a WHERE a.nombre = 'PRENSA EMPLACADO' AND NOT EXISTS (SELECT 1 FROM cat_maquinas m WHERE m.nombre = 'KBA 145/164 AGNATI 145 (DA)' AND m.area_id = a.id);
-- REQUIERE REVISION: máquina "KBA 145/164 KBA 2 STOCK 145-1 (SFM)" nombre ambiguo/compuesto, revisar manualmente
-- INSERT INTO cat_maquinas (area_id, nombre) SELECT a.id, 'KBA 145/164 KBA 2 STOCK 145-1 (SFM)' FROM cat_areas a WHERE a.nombre = 'PRENSA EMPLACADO' AND NOT EXISTS (SELECT 1 FROM cat_maquinas m WHERE m.nombre = 'KBA 145/164 KBA 2 STOCK 145-1 (SFM)' AND m.area_id = a.id);
-- REQUIERE REVISION: máquina "KBA 145/164 STOCK 142 (DA)" nombre ambiguo/compuesto, revisar manualmente
-- INSERT INTO cat_maquinas (area_id, nombre) SELECT a.id, 'KBA 145/164 STOCK 142 (DA)' FROM cat_areas a WHERE a.nombre = 'PRENSA EMPLACADO' AND NOT EXISTS (SELECT 1 FROM cat_maquinas m WHERE m.nombre = 'KBA 145/164 STOCK 142 (DA)' AND m.area_id = a.id);
-- REQUIERE REVISION: máquina "KBA 145/164 STOCK 145-1 (SFM)" nombre ambiguo/compuesto, revisar manualmente
-- INSERT INTO cat_maquinas (area_id, nombre) SELECT a.id, 'KBA 145/164 STOCK 145-1 (SFM)' FROM cat_areas a WHERE a.nombre = 'PRENSA EMPLACADO' AND NOT EXISTS (SELECT 1 FROM cat_maquinas m WHERE m.nombre = 'KBA 145/164 STOCK 145-1 (SFM)' AND m.area_id = a.id);
INSERT INTO cat_maquinas (area_id, nombre) SELECT a.id, 'KBA 2' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_maquinas m WHERE m.nombre = 'KBA 2' AND m.area_id = a.id);
-- REQUIERE REVISION: máquina "KBA 2 STOCK 145-2 (SFM)" nombre ambiguo/compuesto, revisar manualmente
-- INSERT INTO cat_maquinas (area_id, nombre) SELECT a.id, 'KBA 2 STOCK 145-2 (SFM)' FROM cat_areas a WHERE a.nombre = 'PRENSA EMPLACADO' AND NOT EXISTS (SELECT 1 FROM cat_maquinas m WHERE m.nombre = 'KBA 2 STOCK 145-2 (SFM)' AND m.area_id = a.id);
INSERT INTO cat_maquinas (area_id, nombre) SELECT a.id, 'PEGADO INDUSTRIAL' FROM cat_areas a WHERE a.nombre = 'PEGADO INDUSTRIAL' AND NOT EXISTS (SELECT 1 FROM cat_maquinas m WHERE m.nombre = 'PEGADO INDUSTRIAL' AND m.area_id = a.id);
INSERT INTO cat_maquinas (area_id, nombre) SELECT a.id, 'PRENSA' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_maquinas m WHERE m.nombre = 'PRENSA' AND m.area_id = a.id);
-- REQUIERE REVISION: máquina "PRO 2" aparece en varias áreas: TROQUEL, PEGADO FARMA
-- INSERT INTO cat_maquinas (area_id, nombre) SELECT a.id, 'PRO 2' FROM cat_areas a WHERE a.nombre = 'TROQUEL' AND NOT EXISTS (SELECT 1 FROM cat_maquinas m WHERE m.nombre = 'PRO 2' AND m.area_id = a.id);
INSERT INTO cat_maquinas (area_id, nombre) SELECT a.id, 'SM 74' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_maquinas m WHERE m.nombre = 'SM 74' AND m.area_id = a.id);
INSERT INTO cat_maquinas (area_id, nombre) SELECT a.id, 'SM 74-ZL' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_maquinas m WHERE m.nombre = 'SM 74-ZL' AND m.area_id = a.id);
-- REQUIERE REVISION: máquina "STOCK MANUAL 125 (SFM)" nombre ambiguo/compuesto, revisar manualmente
-- INSERT INTO cat_maquinas (area_id, nombre) SELECT a.id, 'STOCK MANUAL 125 (SFM)' FROM cat_areas a WHERE a.nombre = 'EMPLACADO' AND NOT EXISTS (SELECT 1 FROM cat_maquinas m WHERE m.nombre = 'STOCK MANUAL 125 (SFM)' AND m.area_id = a.id);
INSERT INTO cat_maquinas (area_id, nombre) SELECT a.id, 'TALLER RIOS' FROM cat_areas a WHERE a.nombre = 'TALLER EXTERNO' AND NOT EXISTS (SELECT 1 FROM cat_maquinas m WHERE m.nombre = 'TALLER RIOS' AND m.area_id = a.id);
INSERT INTO cat_maquinas (area_id, nombre) SELECT a.id, 'TERMOFORMADORA' FROM cat_areas a WHERE a.nombre = 'TERMOFORMADO' AND NOT EXISTS (SELECT 1 FROM cat_maquinas m WHERE m.nombre = 'TERMOFORMADORA' AND m.area_id = a.id);
INSERT INTO cat_maquinas (area_id, nombre) SELECT a.id, 'TROQUEL' FROM cat_areas a WHERE a.nombre = 'TROQUEL' AND NOT EXISTS (SELECT 1 FROM cat_maquinas m WHERE m.nombre = 'TROQUEL' AND m.area_id = a.id);
INSERT INTO cat_maquinas (area_id, nombre) SELECT a.id, 'WEN CHYUAN' FROM cat_areas a WHERE a.nombre = 'TERMOLAMINADO' AND NOT EXISTS (SELECT 1 FROM cat_maquinas m WHERE m.nombre = 'WEN CHYUAN' AND m.area_id = a.id);
INSERT INTO cat_maquinas (area_id, nombre) SELECT a.id, 'XL-2' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_maquinas m WHERE m.nombre = 'XL-2' AND m.area_id = a.id);
-- REQUIERE REVISION: máquina "XL-3" aparece en varias áreas: PRENSA, TROQUEL, PEGADO FARMA
-- INSERT INTO cat_maquinas (area_id, nombre) SELECT a.id, 'XL-3' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_maquinas m WHERE m.nombre = 'XL-3' AND m.area_id = a.id);

-- ── OPERADORES ────────────────────────────────────────────────
-- OJO: hay variantes de un mismo operador escritas distinto (ej. "A. CRUZ" vs "AXEL CRUZ")
-- que NO se unificaron automáticamente por riesgo de mezclar personas distintas.
-- Revisa la lista completa antes de aprobar.
-- REQUIERE REVISION: operador "A. CRUZ" aparece en varias áreas: PRENSA EMPLACADO, PRENSA
-- INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'A. CRUZ' FROM cat_areas a WHERE a.nombre = 'PRENSA EMPLACADO' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'A. CRUZ' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'A. FLORES' FROM cat_areas a WHERE a.nombre = 'SGI' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'A. FLORES' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'A. GAYTAN' FROM cat_areas a WHERE a.nombre = 'PRENSA EMPLACADO' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'A. GAYTAN' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'A. YAÑEZ' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'A. YAÑEZ' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'ALBERTO TREMONT' FROM cat_areas a WHERE a.nombre = 'PEGADO INDUSTRIAL' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'ALBERTO TREMONT' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'ALEJANDRO YAÑEZ' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'ALEJANDRO YAÑEZ' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'ASDRUBAL MARCANO' FROM cat_areas a WHERE a.nombre = 'CALIDAD' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'ASDRUBAL MARCANO' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'AXEL CRUZ' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'AXEL CRUZ' AND o.area_id = a.id);
-- REQUIERE REVISION: operador "AXEL CRUZ DEDIER LEIVA" el nombre parece tener 2+ personas concatenadas (revisar celda original del Excel)
-- INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'AXEL CRUZ DEDIER LEIVA' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'AXEL CRUZ DEDIER LEIVA' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'C. AVELLO' FROM cat_areas a WHERE a.nombre = 'TROQUEL' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'C. AVELLO' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'C. CARIQUEO' FROM cat_areas a WHERE a.nombre = 'PEGADO INDUSTRIAL' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'C. CARIQUEO' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'C. SEGOVIA' FROM cat_areas a WHERE a.nombre = 'TROQUEL' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'C. SEGOVIA' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'C. SEPÚLVEDA' FROM cat_areas a WHERE a.nombre = 'TERMOFORMADO' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'C. SEPÚLVEDA' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'CARLOS RIVERA' FROM cat_areas a WHERE a.nombre = 'TROQUEL' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'CARLOS RIVERA' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'CLAUDIO CARIQUEO' FROM cat_areas a WHERE a.nombre = 'PEGADO INDUSTRIAL' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'CLAUDIO CARIQUEO' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'D. LEIVA' FROM cat_areas a WHERE a.nombre = 'PRENSA EMPLACADO' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'D. LEIVA' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'D. RAMIREZ' FROM cat_areas a WHERE a.nombre = 'TROQUEL' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'D. RAMIREZ' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'D. TAMAYO' FROM cat_areas a WHERE a.nombre = 'COMERCIAL' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'D. TAMAYO' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'DEDIER LEIVA' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'DEDIER LEIVA' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'DESARROLLO' FROM cat_areas a WHERE a.nombre = 'DESARROLLO' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'DESARROLLO' AND o.area_id = a.id);
-- REQUIERE REVISION: operador "DIANA TAMAYO" aparece en varias áreas: PRENSA, COMERCIAL
-- INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'DIANA TAMAYO' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'DIANA TAMAYO' AND o.area_id = a.id);
-- REQUIERE REVISION: operador "E. RAMÍREZ A. CRUZ" el nombre parece tener 2+ personas concatenadas (revisar celda original del Excel)
-- INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'E. RAMÍREZ A. CRUZ' FROM cat_areas a WHERE a.nombre = 'PRENSA EMPLACADO' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'E. RAMÍREZ A. CRUZ' AND o.area_id = a.id);
-- REQUIERE REVISION: operador "E. RAMÍREZ E. NOGUERA" el nombre parece tener 2+ personas concatenadas (revisar celda original del Excel)
-- INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'E. RAMÍREZ E. NOGUERA' FROM cat_areas a WHERE a.nombre = 'PRENSA EMPLACADO' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'E. RAMÍREZ E. NOGUERA' AND o.area_id = a.id);
-- REQUIERE REVISION: operador "E. RAMÍREZ O. CAMPOS" el nombre parece tener 2+ personas concatenadas (revisar celda original del Excel)
-- INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'E. RAMÍREZ O. CAMPOS' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'E. RAMÍREZ O. CAMPOS' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'E. RAMÍREZ TALLER' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'E. RAMÍREZ TALLER' AND o.area_id = a.id);
-- REQUIERE REVISION: operador "E. RAMÍREZ Y. MENDEZ" el nombre parece tener 2+ personas concatenadas (revisar celda original del Excel)
-- INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'E. RAMÍREZ Y. MENDEZ' FROM cat_areas a WHERE a.nombre = 'PRENSA EMPLACADO' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'E. RAMÍREZ Y. MENDEZ' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'F. CAREAGA' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'F. CAREAGA' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'F. CARIAGA' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'F. CARIAGA' AND o.area_id = a.id);
-- REQUIERE REVISION: operador "F. NORAMBUENA" aparece en varias áreas: PEGADO INDUSTRIAL, PEGADO FARMA
-- INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'F. NORAMBUENA' FROM cat_areas a WHERE a.nombre = 'PEGADO INDUSTRIAL' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'F. NORAMBUENA' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'FRANCISCO NORAMBUENA' FROM cat_areas a WHERE a.nombre = 'PEGADO INDUSTRIAL' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'FRANCISCO NORAMBUENA' AND o.area_id = a.id);
-- REQUIERE REVISION: operador "FRANCISCO NORAMBUENA ALEJANDRO SILVA" el nombre parece tener 2+ personas concatenadas (revisar celda original del Excel)
-- INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'FRANCISCO NORAMBUENA ALEJANDRO SILVA' FROM cat_areas a WHERE a.nombre = 'PEGADO INDUSTRIAL' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'FRANCISCO NORAMBUENA ALEJANDRO SILVA' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'FREDDY CARIAGA' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'FREDDY CARIAGA' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'G. MORENO' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'G. MORENO' AND o.area_id = a.id);
-- REQUIERE REVISION: operador "G. MORENO J. PAILLAMAN" el nombre parece tener 2+ personas concatenadas (revisar celda original del Excel)
-- INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'G. MORENO J. PAILLAMAN' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'G. MORENO J. PAILLAMAN' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'HERNAN VARGAS' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'HERNAN VARGAS' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'I. COLINA' FROM cat_areas a WHERE a.nombre = 'PRENSA EMPLACADO' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'I. COLINA' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'J. MUÑOZ' FROM cat_areas a WHERE a.nombre = 'TERMOFORMADO' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'J. MUÑOZ' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'J. PAILLAMAN' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'J. PAILLAMAN' AND o.area_id = a.id);
-- REQUIERE REVISION: operador "J. ROA" aparece en varias áreas: DESARROLLO, CARGA DE ARCHIVO
-- INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'J. ROA' FROM cat_areas a WHERE a.nombre = 'DESARROLLO' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'J. ROA' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'J. SEDÁN' FROM cat_areas a WHERE a.nombre = 'COTIZACION' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'J. SEDÁN' AND o.area_id = a.id);
-- REQUIERE REVISION: operador "JUAN PAILLAMAN" aparece en varias áreas: PRENSA, TROQUEL, PEGADO FARMA
-- INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'JUAN PAILLAMAN' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'JUAN PAILLAMAN' AND o.area_id = a.id);
-- REQUIERE REVISION: operador "JUAN PAILLAMAN ROLANDO PEÑA" el nombre parece tener 2+ personas concatenadas (revisar celda original del Excel)
-- INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'JUAN PAILLAMAN ROLANDO PEÑA' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'JUAN PAILLAMAN ROLANDO PEÑA' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'K. MOSQUERA' FROM cat_areas a WHERE a.nombre = 'TROQUEL' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'K. MOSQUERA' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'K. YUSTIZ' FROM cat_areas a WHERE a.nombre = 'PEGADO INDUSTRIAL' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'K. YUSTIZ' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'KEIBER ANTIYUE' FROM cat_areas a WHERE a.nombre = 'PEGADO INDUSTRIAL' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'KEIBER ANTIYUE' AND o.area_id = a.id);
-- REQUIERE REVISION: operador "L. ADASME" aparece en varias áreas: EMPLACADO, PRENSA EMPLACADO
-- INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'L. ADASME' FROM cat_areas a WHERE a.nombre = 'EMPLACADO' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'L. ADASME' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'L. ARAVENA' FROM cat_areas a WHERE a.nombre = 'TROQUEL' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'L. ARAVENA' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'L. COLOMBO' FROM cat_areas a WHERE a.nombre = 'PEGADO INDUSTRIAL' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'L. COLOMBO' AND o.area_id = a.id);
-- REQUIERE REVISION: operador "L. COLOMBO M. MORALES" el nombre parece tener 2+ personas concatenadas (revisar celda original del Excel)
-- INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'L. COLOMBO M. MORALES' FROM cat_areas a WHERE a.nombre = 'PEGADO INDUSTRIAL' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'L. COLOMBO M. MORALES' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'L. DEL VERA' FROM cat_areas a WHERE a.nombre = 'PEGADO FARMA' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'L. DEL VERA' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'L. HERNANDEZ' FROM cat_areas a WHERE a.nombre = 'PRENSA EMPLACADO' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'L. HERNANDEZ' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'L. VERA' FROM cat_areas a WHERE a.nombre = 'PEGADO FARMA' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'L. VERA' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'LUIS MONTOYA' FROM cat_areas a WHERE a.nombre = 'TROQUEL' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'LUIS MONTOYA' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'LUIS ROJAS' FROM cat_areas a WHERE a.nombre = 'LOGISTICA' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'LUIS ROJAS' AND o.area_id = a.id);
-- REQUIERE REVISION: operador "LUIS VERA" aparece en varias áreas: TROQUEL, PEGADO FARMA
-- INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'LUIS VERA' FROM cat_areas a WHERE a.nombre = 'TROQUEL' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'LUIS VERA' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'M. MORALES' FROM cat_areas a WHERE a.nombre = 'PEGADO INDUSTRIAL' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'M. MORALES' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'M. PADILLA' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'M. PADILLA' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'M. SEPÚLVEDA' FROM cat_areas a WHERE a.nombre = 'EDICIÓN' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'M. SEPÚLVEDA' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'MARCOS MORALES' FROM cat_areas a WHERE a.nombre = 'PEGADO INDUSTRIAL' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'MARCOS MORALES' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'MARÍA SEPULVEDA' FROM cat_areas a WHERE a.nombre = 'DESARROLLO' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'MARÍA SEPULVEDA' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'MIGUEL CASTRO' FROM cat_areas a WHERE a.nombre = 'TROQUEL' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'MIGUEL CASTRO' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'MONICA VALDIVIA' FROM cat_areas a WHERE a.nombre = 'SGI' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'MONICA VALDIVIA' AND o.area_id = a.id);
-- REQUIERE REVISION: operador "O. CAMPOS" aparece en varias áreas: PRENSA, PRENSA EMPLACADO
-- INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'O. CAMPOS' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'O. CAMPOS' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'OSVALDO CAMPOS' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'OSVALDO CAMPOS' AND o.area_id = a.id);
-- REQUIERE REVISION: operador "OSVALDO CAMPOS EMERSON RAMIREZ" el nombre parece tener 2+ personas concatenadas (revisar celda original del Excel)
-- INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'OSVALDO CAMPOS EMERSON RAMIREZ' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'OSVALDO CAMPOS EMERSON RAMIREZ' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'P. CASTILLO' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'P. CASTILLO' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'P. ESTROZ' FROM cat_areas a WHERE a.nombre = 'COMERCIAL' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'P. ESTROZ' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'PEDRO CASTILLO' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'PEDRO CASTILLO' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'R. BRUCE' FROM cat_areas a WHERE a.nombre = 'PRENSA EMPLACADO' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'R. BRUCE' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'R. CONCHA' FROM cat_areas a WHERE a.nombre = 'TALLER EXTERNO' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'R. CONCHA' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'R. PEÑA' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'R. PEÑA' AND o.area_id = a.id);
-- REQUIERE REVISION: operador "R. PEÑA A. MENDEZ" el nombre parece tener 2+ personas concatenadas (revisar celda original del Excel)
-- INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'R. PEÑA A. MENDEZ' FROM cat_areas a WHERE a.nombre = 'PRENSA EMPLACADO' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'R. PEÑA A. MENDEZ' AND o.area_id = a.id);
-- REQUIERE REVISION: operador "R. PEÑA C. ROCO" el nombre parece tener 2+ personas concatenadas (revisar celda original del Excel)
-- INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'R. PEÑA C. ROCO' FROM cat_areas a WHERE a.nombre = 'PRENSA EMPLACADO' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'R. PEÑA C. ROCO' AND o.area_id = a.id);
-- REQUIERE REVISION: operador "R. PEÑA D. GOMEZ" el nombre parece tener 2+ personas concatenadas (revisar celda original del Excel)
-- INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'R. PEÑA D. GOMEZ' FROM cat_areas a WHERE a.nombre = 'PRENSA EMPLACADO' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'R. PEÑA D. GOMEZ' AND o.area_id = a.id);
-- REQUIERE REVISION: operador "R. PEÑA Y. MENDEZ" el nombre parece tener 2+ personas concatenadas (revisar celda original del Excel)
-- INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'R. PEÑA Y. MENDEZ' FROM cat_areas a WHERE a.nombre = 'PRENSA EMPLACADO' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'R. PEÑA Y. MENDEZ' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'RODRIGO ALVAREZ' FROM cat_areas a WHERE a.nombre = 'TROQUEL' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'RODRIGO ALVAREZ' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'RODRIGO AMAYA' FROM cat_areas a WHERE a.nombre = 'FOLIA' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'RODRIGO AMAYA' AND o.area_id = a.id);
-- REQUIERE REVISION: operador "ROLANDO PEÑA" aparece en varias áreas: PRENSA, PEGADO FARMA
-- INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'ROLANDO PEÑA' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'ROLANDO PEÑA' AND o.area_id = a.id);
-- REQUIERE REVISION: operador "ROLANDO PEÑA HERNÁN VARGAS" el nombre parece tener 2+ personas concatenadas (revisar celda original del Excel)
-- INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'ROLANDO PEÑA HERNÁN VARGAS' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'ROLANDO PEÑA HERNÁN VARGAS' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'S. PARADA' FROM cat_areas a WHERE a.nombre = 'CARGA DE ARCHIVO' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'S. PARADA' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'SEBASTIAN VALENZUELA' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'SEBASTIAN VALENZUELA' AND o.area_id = a.id);
-- REQUIERE REVISION: operador "SERGIO TORO" aparece en varias áreas: TROQUEL, TERMOLAMINADO
-- INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'SERGIO TORO' FROM cat_areas a WHERE a.nombre = 'TROQUEL' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'SERGIO TORO' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'T. CONCHA' FROM cat_areas a WHERE a.nombre = 'TALLER EXTERNO' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'T. CONCHA' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'T. RIOS' FROM cat_areas a WHERE a.nombre = 'TALLER EXTERNO' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'T. RIOS' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'TALLER' FROM cat_areas a WHERE a.nombre = 'TALLER EXTERNO' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'TALLER' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'V. RIOS' FROM cat_areas a WHERE a.nombre = 'TALLER EXTERNO' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'V. RIOS' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'VICTOR RIOS' FROM cat_areas a WHERE a.nombre = 'TALLER EXTERNO' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'VICTOR RIOS' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'VINICIO GONZALEZ' FROM cat_areas a WHERE a.nombre = 'TERMOLAMINADO' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'VINICIO GONZALEZ' AND o.area_id = a.id);
INSERT INTO cat_operadores (area_id, nombre) SELECT a.id, 'Y. ROJAS' FROM cat_areas a WHERE a.nombre = 'PRENSA EMPLACADO' AND NOT EXISTS (SELECT 1 FROM cat_operadores o WHERE o.nombre = 'Y. ROJAS' AND o.area_id = a.id);

-- ── DEFECTOS (desde "Categoría Defecto") ────────────────────────
-- REQUIERE REVISION: defecto "Armado y cierre" aparece en varias áreas: TROQUEL, PEGADO INDUSTRIAL
-- INSERT INTO cat_defectos (area_id, nombre) SELECT a.id, 'Armado y cierre' FROM cat_areas a WHERE a.nombre = 'TROQUEL' AND NOT EXISTS (SELECT 1 FROM cat_defectos d WHERE d.nombre = 'Armado y cierre' AND d.area_id = a.id);
-- REQUIERE REVISION: defecto "Arrugas y/o Roturas leves" aparece en varias áreas: TROQUEL, ADQUISICIONES, DIMENSIONADO, PEGADO INDUSTRIAL
-- INSERT INTO cat_defectos (area_id, nombre) SELECT a.id, 'Arrugas y/o Roturas leves' FROM cat_areas a WHERE a.nombre = 'TROQUEL' AND NOT EXISTS (SELECT 1 FROM cat_defectos d WHERE d.nombre = 'Arrugas y/o Roturas leves' AND d.area_id = a.id);
INSERT INTO cat_defectos (area_id, nombre) SELECT a.id, 'Asímetría del formado' FROM cat_areas a WHERE a.nombre = 'DESARROLLO' AND NOT EXISTS (SELECT 1 FROM cat_defectos d WHERE d.nombre = 'Asímetría del formado' AND d.area_id = a.id);
-- REQUIERE REVISION: defecto "Calidad de Impresión(manchas, piojos, velos ,repintes, otros)" aparece en varias áreas: PRENSA, PRE-PRENSA
-- INSERT INTO cat_defectos (area_id, nombre) SELECT a.id, 'Calidad de Impresión(manchas, piojos, velos ,repintes, otros)' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_defectos d WHERE d.nombre = 'Calidad de Impresión(manchas, piojos, velos ,repintes, otros)' AND d.area_id = a.id);
INSERT INTO cat_defectos (area_id, nombre) SELECT a.id, 'Calidad del relieve/cuño' FROM cat_areas a WHERE a.nombre = 'TROQUEL' AND NOT EXISTS (SELECT 1 FROM cat_defectos d WHERE d.nombre = 'Calidad del relieve/cuño' AND d.area_id = a.id);
-- REQUIERE REVISION: defecto "Calidad del sustrato (falla estuco, lisura, desprendimiento)" aparece en varias áreas: PRENSA, ADQUISICIONES
-- INSERT INTO cat_defectos (area_id, nombre) SELECT a.id, 'Calidad del sustrato (falla estuco, lisura, desprendimiento)' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_defectos d WHERE d.nombre = 'Calidad del sustrato (falla estuco, lisura, desprendimiento)' AND d.area_id = a.id);
-- REQUIERE REVISION: defecto "Calidad del Troquelado/corte (reventón, calce, corte, medio corte, plisado)" aparece en varias áreas: TROQUEL, CARGA DE ARCHIVO
-- INSERT INTO cat_defectos (area_id, nombre) SELECT a.id, 'Calidad del Troquelado/corte (reventón, calce, corte, medio corte, plisado)' FROM cat_areas a WHERE a.nombre = 'TROQUEL' AND NOT EXISTS (SELECT 1 FROM cat_defectos d WHERE d.nombre = 'Calidad del Troquelado/corte (reventón, calce, corte, medio corte, plisado)' AND d.area_id = a.id);
INSERT INTO cat_defectos (area_id, nombre) SELECT a.id, 'Calidad Folia' FROM cat_areas a WHERE a.nombre = 'FOLIA' AND NOT EXISTS (SELECT 1 FROM cat_defectos d WHERE d.nombre = 'Calidad Folia' AND d.area_id = a.id);
-- REQUIERE REVISION: defecto "Cantidad requerida por embalaje (caja, paquete, pallet)" aparece en varias áreas: PRE-PRENSA, TALLER EXTERNO, PEGADO INDUSTRIAL
-- INSERT INTO cat_defectos (area_id, nombre) SELECT a.id, 'Cantidad requerida por embalaje (caja, paquete, pallet)' FROM cat_areas a WHERE a.nombre = 'PRE-PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_defectos d WHERE d.nombre = 'Cantidad requerida por embalaje (caja, paquete, pallet)' AND d.area_id = a.id);
-- REQUIERE REVISION: defecto "Color según estándar del cliente" aparece en varias áreas: PRENSA, COMERCIAL
-- INSERT INTO cat_defectos (area_id, nombre) SELECT a.id, 'Color según estándar del cliente' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_defectos d WHERE d.nombre = 'Color según estándar del cliente' AND d.area_id = a.id);
INSERT INTO cat_defectos (area_id, nombre) SELECT a.id, 'Condición y estado del pallet' FROM cat_areas a WHERE a.nombre = 'TALLER EXTERNO' AND NOT EXISTS (SELECT 1 FROM cat_defectos d WHERE d.nombre = 'Condición y estado del pallet' AND d.area_id = a.id);
INSERT INTO cat_defectos (area_id, nombre) SELECT a.id, 'Curvatura leve' FROM cat_areas a WHERE a.nombre = 'COTIZACION' AND NOT EXISTS (SELECT 1 FROM cat_defectos d WHERE d.nombre = 'Curvatura leve' AND d.area_id = a.id);
-- REQUIERE REVISION: defecto "Descalces" aparece en varias áreas: TROQUEL, FOLIA, PRENSA, TERMOLAMINADO
-- INSERT INTO cat_defectos (area_id, nombre) SELECT a.id, 'Descalces' FROM cat_areas a WHERE a.nombre = 'TROQUEL' AND NOT EXISTS (SELECT 1 FROM cat_defectos d WHERE d.nombre = 'Descalces' AND d.area_id = a.id);
-- REQUIERE REVISION: defecto "Deslaminado" aparece en varias áreas: PRENSA EMPLACADO, TERMOLAMINADO
-- INSERT INTO cat_defectos (area_id, nombre) SELECT a.id, 'Deslaminado' FROM cat_areas a WHERE a.nombre = 'PRENSA EMPLACADO' AND NOT EXISTS (SELECT 1 FROM cat_defectos d WHERE d.nombre = 'Deslaminado' AND d.area_id = a.id);
INSERT INTO cat_defectos (area_id, nombre) SELECT a.id, 'Despegue parcial' FROM cat_areas a WHERE a.nombre = 'TERMOFORMADO' AND NOT EXISTS (SELECT 1 FROM cat_defectos d WHERE d.nombre = 'Despegue parcial' AND d.area_id = a.id);
-- REQUIERE REVISION: defecto "Desprendimientos (Cartulina,papel, Pet, Tintas, Barniz, Folia)" aparece en varias áreas: TERMOFORMADO, EMPLACADO, PRENSA, TERMOLAMINADO
-- INSERT INTO cat_defectos (area_id, nombre) SELECT a.id, 'Desprendimientos (Cartulina,papel, Pet, Tintas, Barniz, Folia)' FROM cat_areas a WHERE a.nombre = 'TERMOFORMADO' AND NOT EXISTS (SELECT 1 FROM cat_defectos d WHERE d.nombre = 'Desprendimientos (Cartulina,papel, Pet, Tintas, Barniz, Folia)' AND d.area_id = a.id);
-- REQUIERE REVISION: defecto "Diferencia de color/Tono" aparece en varias áreas: PRENSA, PRENSA / TROQUEL
-- INSERT INTO cat_defectos (area_id, nombre) SELECT a.id, 'Diferencia de color/Tono' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_defectos d WHERE d.nombre = 'Diferencia de color/Tono' AND d.area_id = a.id);
-- REQUIERE REVISION: defecto "Error de Impresión" aparece en varias áreas: COMERCIAL, PRENSA
-- INSERT INTO cat_defectos (area_id, nombre) SELECT a.id, 'Error de Impresión' FROM cat_areas a WHERE a.nombre = 'COMERCIAL' AND NOT EXISTS (SELECT 1 FROM cat_defectos d WHERE d.nombre = 'Error de Impresión' AND d.area_id = a.id);
-- REQUIERE REVISION: defecto "Error en documentación de liberación" aparece en varias áreas: SGI, COMERCIAL
-- INSERT INTO cat_defectos (area_id, nombre) SELECT a.id, 'Error en documentación de liberación' FROM cat_areas a WHERE a.nombre = 'SGI' AND NOT EXISTS (SELECT 1 FROM cat_defectos d WHERE d.nombre = 'Error en documentación de liberación' AND d.area_id = a.id);
INSERT INTO cat_defectos (area_id, nombre) SELECT a.id, 'Homogeneidad en aplicación de Barniz y Serigrafía' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_defectos d WHERE d.nombre = 'Homogeneidad en aplicación de Barniz y Serigrafía' AND d.area_id = a.id);
INSERT INTO cat_defectos (area_id, nombre) SELECT a.id, 'Inocuidad del Producto (contaminado, cuerpo extraño)' FROM cat_areas a WHERE a.nombre = 'TERMOLAMINADO' AND NOT EXISTS (SELECT 1 FROM cat_defectos d WHERE d.nombre = 'Inocuidad del Producto (contaminado, cuerpo extraño)' AND d.area_id = a.id);
INSERT INTO cat_defectos (area_id, nombre) SELECT a.id, 'Lectura código de barra EAN 13' FROM cat_areas a WHERE a.nombre = 'EDICIÓN' AND NOT EXISTS (SELECT 1 FROM cat_defectos d WHERE d.nombre = 'Lectura código de barra EAN 13' AND d.area_id = a.id);
-- REQUIERE REVISION: defecto "Marcas/ Manchas de proceso" aparece en varias áreas: PEGADO FARMA, PEGADO INDUSTRIAL, PRENSA, TROQUEL
-- INSERT INTO cat_defectos (area_id, nombre) SELECT a.id, 'Marcas/ Manchas de proceso' FROM cat_areas a WHERE a.nombre = 'PEGADO FARMA' AND NOT EXISTS (SELECT 1 FROM cat_defectos d WHERE d.nombre = 'Marcas/ Manchas de proceso' AND d.area_id = a.id);
-- REQUIERE REVISION: defecto "Mezcla de Productos" aparece en varias áreas: DESARROLLO, TALLER EXTERNO, PEGADO FARMA
-- INSERT INTO cat_defectos (area_id, nombre) SELECT a.id, 'Mezcla de Productos' FROM cat_areas a WHERE a.nombre = 'DESARROLLO' AND NOT EXISTS (SELECT 1 FROM cat_defectos d WHERE d.nombre = 'Mezcla de Productos' AND d.area_id = a.id);
-- REQUIERE REVISION: defecto "Pegado Deficiente (adhesivo visible, débil, interior, despegados)" aparece en varias áreas: PEGADO FARMA, PEGADO INDUSTRIAL, TALLER EXTERNO
-- INSERT INTO cat_defectos (area_id, nombre) SELECT a.id, 'Pegado Deficiente (adhesivo visible, débil, interior, despegados)' FROM cat_areas a WHERE a.nombre = 'PEGADO FARMA' AND NOT EXISTS (SELECT 1 FROM cat_defectos d WHERE d.nombre = 'Pegado Deficiente (adhesivo visible, débil, interior, despegados)' AND d.area_id = a.id);
-- REQUIERE REVISION: defecto "Plisados reventados (hendidos rajados)" aparece en varias áreas: TROQUEL, PEGADO INDUSTRIAL
-- INSERT INTO cat_defectos (area_id, nombre) SELECT a.id, 'Plisados reventados (hendidos rajados)' FROM cat_areas a WHERE a.nombre = 'TROQUEL' AND NOT EXISTS (SELECT 1 FROM cat_defectos d WHERE d.nombre = 'Plisados reventados (hendidos rajados)' AND d.area_id = a.id);
-- REQUIERE REVISION: defecto "Rotulación y logo de embalaje" aparece en varias áreas: LOGISTICA, CALIDAD, COTIZACION
-- INSERT INTO cat_defectos (area_id, nombre) SELECT a.id, 'Rotulación y logo de embalaje' FROM cat_areas a WHERE a.nombre = 'LOGISTICA' AND NOT EXISTS (SELECT 1 FROM cat_defectos d WHERE d.nombre = 'Rotulación y logo de embalaje' AND d.area_id = a.id);
-- REQUIERE REVISION: defecto "Texto íntegro y legible" aparece en varias áreas: PRENSA, DESARROLLO
-- INSERT INTO cat_defectos (area_id, nombre) SELECT a.id, 'Texto íntegro y legible' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_defectos d WHERE d.nombre = 'Texto íntegro y legible' AND d.area_id = a.id);
INSERT INTO cat_defectos (area_id, nombre) SELECT a.id, 'Uniformidad de color/Impresión' FROM cat_areas a WHERE a.nombre = 'PRENSA' AND NOT EXISTS (SELECT 1 FROM cat_defectos d WHERE d.nombre = 'Uniformidad de color/Impresión' AND d.area_id = a.id);

-- ── INSPECTORES ───────────────────────────────────────────────
-- ASUNCION: se usó la columna "REVISADO POR" del Excel como candidatos a Inspector
-- (cat_inspectores no tiene area_id, igual que esta columna es transversal).
-- También existe una columna "SUPERVISOR" con otro conjunto de nombres — revisa cuál
-- corresponde realmente al rol de Inspector en tu operación antes de aprobar.
INSERT INTO cat_inspectores (nombre) SELECT 'C. MEDINA' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'C. MEDINA');
-- REQUIERE REVISION: "CONCHA" es un apellido suelto, podría ser la misma persona que otra entrada de la lista (ej. variantes con inicial)
-- INSERT INTO cat_inspectores (nombre) SELECT 'CONCHA' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'CONCHA');
INSERT INTO cat_inspectores (nombre) SELECT 'D. ARCOS' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'D. ARCOS');
INSERT INTO cat_inspectores (nombre) SELECT 'G. ROMERO' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'G. ROMERO');
INSERT INTO cat_inspectores (nombre) SELECT 'K. MERA' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'K. MERA');
INSERT INTO cat_inspectores (nombre) SELECT 'R. BASTIAS' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'R. BASTIAS');
INSERT INTO cat_inspectores (nombre) SELECT 'R. CONCHA' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'R. CONCHA');
-- REQUIERE REVISION: "R.CONCHA" es un apellido suelto, podría ser la misma persona que otra entrada de la lista (ej. variantes con inicial)
-- INSERT INTO cat_inspectores (nombre) SELECT 'R.CONCHA' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'R.CONCHA');
INSERT INTO cat_inspectores (nombre) SELECT 'RICARDO CONCHA' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'RICARDO CONCHA');
INSERT INTO cat_inspectores (nombre) SELECT 'S. BUCAREI' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'S. BUCAREI');
INSERT INTO cat_inspectores (nombre) SELECT 'T. CONCHA' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'T. CONCHA');
INSERT INTO cat_inspectores (nombre) SELECT 'V. RIOS' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'V. RIOS');
INSERT INTO cat_inspectores (nombre) SELECT 'V. RIOS E. SEIJAS' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'V. RIOS E. SEIJAS');

-- Candidatos alternativos detectados en la columna "SUPERVISOR" (comentados):
-- INSERT INTO cat_inspectores (nombre) SELECT 'A. CABEZAS' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'A. CABEZAS');
-- INSERT INTO cat_inspectores (nombre) SELECT 'A. GUERRERO' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'A. GUERRERO');
-- INSERT INTO cat_inspectores (nombre) SELECT 'A. TREMONT' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'A. TREMONT');
-- INSERT INTO cat_inspectores (nombre) SELECT 'BELINDA QUINATNILLA' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'BELINDA QUINATNILLA');
-- INSERT INTO cat_inspectores (nombre) SELECT 'BOBST 106-1' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'BOBST 106-1');
-- INSERT INTO cat_inspectores (nombre) SELECT 'C. MEDINA' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'C. MEDINA');
-- INSERT INTO cat_inspectores (nombre) SELECT 'CRISTIAN MEDINA' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'CRISTIAN MEDINA');
-- INSERT INTO cat_inspectores (nombre) SELECT 'D. AHUMADA' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'D. AHUMADA');
-- INSERT INTO cat_inspectores (nombre) SELECT 'D. SEDAN' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'D. SEDAN');
-- INSERT INTO cat_inspectores (nombre) SELECT 'D. SEDÁN' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'D. SEDÁN');
-- INSERT INTO cat_inspectores (nombre) SELECT 'DIANA 8' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'DIANA 8');
-- INSERT INTO cat_inspectores (nombre) SELECT 'EMILIO MONTES' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'EMILIO MONTES');
-- INSERT INTO cat_inspectores (nombre) SELECT 'F MUÑOZ' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'F MUÑOZ');
-- INSERT INTO cat_inspectores (nombre) SELECT 'F. HUMENYI' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'F. HUMENYI');
-- INSERT INTO cat_inspectores (nombre) SELECT 'F. MUÑOZ' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'F. MUÑOZ');
-- INSERT INTO cat_inspectores (nombre) SELECT 'F. QUEZADA' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'F. QUEZADA');
-- INSERT INTO cat_inspectores (nombre) SELECT 'FRANCISCO HUMENYI' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'FRANCISCO HUMENYI');
-- INSERT INTO cat_inspectores (nombre) SELECT 'FRANCISCO MUÑOZ' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'FRANCISCO MUÑOZ');
-- INSERT INTO cat_inspectores (nombre) SELECT 'M. BRAVO' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'M. BRAVO');
-- INSERT INTO cat_inspectores (nombre) SELECT 'M. CASTRO' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'M. CASTRO');
-- INSERT INTO cat_inspectores (nombre) SELECT 'M. LEDEZMA' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'M. LEDEZMA');
-- INSERT INTO cat_inspectores (nombre) SELECT 'MARCO BRAVO' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'MARCO BRAVO');
-- INSERT INTO cat_inspectores (nombre) SELECT 'MIGUEL CASTRO' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'MIGUEL CASTRO');
-- INSERT INTO cat_inspectores (nombre) SELECT 'R. PEÑA' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'R. PEÑA');
-- INSERT INTO cat_inspectores (nombre) SELECT 'S. VALENZUELA' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'S. VALENZUELA');
-- INSERT INTO cat_inspectores (nombre) SELECT 'S. VALENZUELA A. TREMONT' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'S. VALENZUELA A. TREMONT');
-- INSERT INTO cat_inspectores (nombre) SELECT 'S. VALENZUELA D. AHUMADA' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'S. VALENZUELA D. AHUMADA');
-- INSERT INTO cat_inspectores (nombre) SELECT 'SEBASTIAN VALENZUELA' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'SEBASTIAN VALENZUELA');
-- INSERT INTO cat_inspectores (nombre) SELECT 'SELIM SEDAN' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'SELIM SEDAN');
-- INSERT INTO cat_inspectores (nombre) SELECT 'VICTOR RIOS' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'VICTOR RIOS');
-- INSERT INTO cat_inspectores (nombre) SELECT 'XL-2' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'XL-2');
-- INSERT INTO cat_inspectores (nombre) SELECT 'XL-3' WHERE NOT EXISTS (SELECT 1 FROM cat_inspectores WHERE nombre = 'XL-3');

-- ── PROCESOS ──────────────────────────────────────────────────
-- NO se generó seed automático: el Excel histórico no tiene una columna que
-- represente claramente el concepto de "proceso" usado por cat_procesos.
-- Define manualmente los procesos a cargar, por ejemplo:
-- INSERT INTO cat_procesos (nombre, descripcion) SELECT 'Nombre proceso', 'Descripcion' WHERE NOT EXISTS (SELECT 1 FROM cat_procesos WHERE nombre = 'Nombre proceso');

-- ── CONTEOS FINALES (ejecutar antes de decidir el COMMIT) ──────
SELECT (SELECT COUNT(*) FROM cat_areas) AS total_areas,
       (SELECT COUNT(*) FROM cat_maquinas) AS total_maquinas,
       (SELECT COUNT(*) FROM cat_operadores) AS total_operadores,
       (SELECT COUNT(*) FROM cat_defectos) AS total_defectos,
       (SELECT COUNT(*) FROM cat_inspectores) AS total_inspectores,
       (SELECT COUNT(*) FROM cat_procesos) AS total_procesos;

-- Revisa los conteos y las filas "REQUIERE REVISION" antes de continuar.
-- COMMIT;
COMMIT; -- cambia a COMMIT manualmente cuando hayas validado todo
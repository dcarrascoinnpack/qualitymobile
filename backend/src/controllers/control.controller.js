const pool = require('../config/database');

const getContextoPorQr = async (req, res) => {
    try {
        const { codigoQr } = req.params;

        const [rows] = await pool.query(
            `
      SELECT
        m.id AS machineId,
        m.nombre AS machineName,
        m.codigo_qr AS codigoQr,
        p.id AS processId,
        p.nombre AS processName,
        f.id AS formId,
        f.nombre AS formName
      FROM maquinas m
      INNER JOIN procesos p ON p.id = m.proceso_id
      LEFT JOIN formularios_control f
        ON f.proceso_id = p.id
        AND f.activo = 1
        AND f.maquina_id IS NULL
      WHERE m.codigo_qr = ?
        AND m.activo = 1
      LIMIT 1
      `,
            [codigoQr]
        );

        if (rows.length === 0) {
            return res.status(404).json({
                ok: false,
                message: 'QR no encontrado o máquina inactiva',
            });
        }

        const contexto = rows[0];

        const [parametrosVisuales] = await pool.query(
            `
      SELECT
        id,
        proceso_id,
        nombre,
        criticidad
      FROM parametros_control_visual
      WHERE activo = 1
        AND proceso_id = ?
      ORDER BY
        FIELD(criticidad, 'critico', 'mayor', 'menor'),
        nombre ASC
      `,
            [contexto.processId]
        );
        const [tiposOnda] = await pool.query(
            `
            SELECT
              id,
              nombre
            FROM tipos_onda
            WHERE activo = 1
            ORDER BY nombre ASC
            `
        );
        const [materiales] = await pool.query(
            `
            SELECT
              id,
              nombre
            FROM materiales
            WHERE activo = 1
            ORDER BY nombre ASC
            `
        );

        const [ensayosLaboratorio] = await pool.query(
            `
            SELECT
              id,
              proceso_id,
              nombre,
              unidad_medida
            FROM ensayos_laboratorio
            WHERE activo = 1
            ORDER BY nombre ASC
            `
        );

        res.json({
            ok: true,
            data: {
                ...contexto,
                parametrosVisuales,
                tiposOnda: contexto.processId === 1 ? tiposOnda : [],
                materiales,
                ensayosLaboratorio,
            },
        });
    } catch (error) {
        console.error('Error contexto QR:', error.message);

        res.status(500).json({
            ok: false,
            message: 'Error al obtener contexto por QR',
            error: error.message,
        });
    }
};
const crearRegistroControl = async (req, res) => {
    const connection = await pool.getConnection();

    try {
        const {
            usuarioId,
            procesoId,
            maquinaId,
            formularioId,
            area,
            np,
            codigoProducto,
            descripcionProducto,
            tipoOndaId,
            mermaInsumosDesponcheBobinas,
            mermaProcesoMonotapas,
            tipoMerma,
            cantidadMerma,
            turno,
            resultadoVisual,
            observacion,
            fallasVisuales,
            ensayosLaboratorio,
        } = req.body;

        if (!usuarioId || !procesoId || !maquinaId || !turno || !resultadoVisual) {
            return res.status(400).json({
                ok: false,
                message: 'Faltan datos obligatorios del control',
            });
        }

        const estadoIdPorResultado = {
            'Cumple': 1,
            'No Cumple': 3,
            'No Aplica': 2,
        };

        const estadoId = estadoIdPorResultado[resultadoVisual];

        if (!estadoId) {
            return res.status(400).json({
                ok: false,
                message: 'Resultado visual inválido',
            });
        }
        const esCorrugado = Number(procesoId) === 1;

        const tipoOndaIdFinal = esCorrugado ? tipoOndaId || null : null;
        const mermaInsumosFinal = esCorrugado ? mermaInsumosDesponcheBobinas || null : null;
        const mermaProcesoFinal = esCorrugado ? mermaProcesoMonotapas || null : null;
        const tipoMermaFinal = tipoMerma || null;
        const cantidadMermaFinal = cantidadMerma || null;

        await connection.beginTransaction();

        const registroControlParams = [
            usuarioId,
            procesoId,
            maquinaId,
            formularioId || null,
            area || null,
            np || null,
            codigoProducto || null,
            descripcionProducto || null,
            tipoOndaIdFinal,
            mermaInsumosFinal,
            mermaProcesoFinal,
            tipoMermaFinal,
            cantidadMermaFinal,
            turno,
            estadoId,
            observacion || null,
        ];

        console.log('BODY RECIBIDO (parseado):', {
            usuarioId,
            procesoId,
            maquinaId,
            tipoOndaId,
            mermaInsumosDesponcheBobinas,
            mermaProcesoMonotapas,
            tipoMerma,
            cantidadMerma,
            turno,
            resultadoVisual,
        });
        console.log('PARAMS INSERT registros_control:', registroControlParams);

        const [registroResult] = await connection.query(
            `
            INSERT INTO registros_control
            (
              usuario_id,
              proceso_id,
              maquina_id,
              formulario_id,
              area,
              np,
              codigo_producto,
              descripcion_producto,
              tipo_onda_id,
              merma_insumos_desponche_bobinas,
              merma_proceso_monotapas,
              tipo_merma,
              cantidad_merma,
              turno,
              estado_id,
              observacion,
              fecha_registro,
              hora_registro
            )
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, CURDATE(), CURTIME())
        `,
            registroControlParams
        );

        const registroId = registroResult.insertId;

        if (Array.isArray(fallasVisuales) && fallasVisuales.length > 0) {
            for (const falla of fallasVisuales) {
                await connection.query(
                    `
            INSERT INTO registro_fallas_visuales
            (
              registro_id,
              parametro_id,
              accion_id,
              observacion
            )
            VALUES (?, ?, ?, ?)
            `,
                    [
                        registroId,
                        falla.parametroId,
                        falla.accionId || null,
                        falla.observacion || null,
                    ]
                );
            }
        }

        if (Array.isArray(ensayosLaboratorio) && ensayosLaboratorio.length > 0) {
            for (const ensayo of ensayosLaboratorio) {
                await connection.query(
                    `
                    INSERT INTO registro_ensayos
                    (
                      registro_id,
                      ensayo_id,
                      material_id,
                      valor,
                      observacion
                    )
                    VALUES (?, ?, ?, ?, ?)
                    `,
                    [
                        registroId,
                        ensayo.ensayoId,
                        ensayo.materialId || null,
                        null,
                        ensayo.observacion || null,
                    ]
                );
            }
        }

        await connection.commit();

        const responseBody = {
            ok: true,
            message: 'Control registrado correctamente',
            data: {
                registroId,
                estadoId,
            },
        };

        console.log('RESPUESTA POST /control/registros:', responseBody);

        res.status(201).json(responseBody);
    } catch (error) {
        await connection.rollback();

        console.error('Error crear registro control:', error.message);

        res.status(500).json({
            ok: false,
            message: 'Error al guardar control',
            error: error.message,
        });
    } finally {
        connection.release();
    }
};

module.exports = {
    getContextoPorQr,
    crearRegistroControl,
};

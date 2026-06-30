from reportlab.lib.units import mm
from reportlab.pdfgen import canvas
import qrcode
import os

# =========================
# CONTROLES CALIDAD
# =========================

controles = [

    {
        'codigo_qr': 'MAQ-PAL-CONTROL',
        'nombre_maquina': 'CONTROL PALETIZADO',
        'proceso': 'PALETIZADO',
        'archivo': 'qr_control_paletizado',
    },

    {
        'codigo_qr': 'MAQ-PT-CONTROL',
        'nombre_maquina': 'CONTROL PRODUCTO TERMINADO',
        'proceso': 'PRODUCTO TERMINADO',
        'archivo': 'qr_control_producto_terminado',
    },
]

# =========================
# MEDIDAS ETIQUETA
# =========================

label_width = 145 * mm
label_height = 168 * mm

output_dir = 'tools/qr_controles'
os.makedirs(output_dir, exist_ok=True)


def generar_etiqueta(control):
    codigo_qr = control['codigo_qr']
    nombre_maquina = control['nombre_maquina']
    proceso = control['proceso']
    archivo = control['archivo']

    qr_path = f'{output_dir}/{archivo}.png'
    pdf_path = f'{output_dir}/{archivo}.pdf'

    qr = qrcode.QRCode(
        error_correction=qrcode.constants.ERROR_CORRECT_H,
        box_size=14,
        border=3,
    )

    qr.add_data(codigo_qr)
    qr.make(fit=True)

    qr.make_image(
        fill_color='black',
        back_color='white',
    ).save(qr_path)

    c = canvas.Canvas(
        pdf_path,
        pagesize=(label_width, label_height),
    )

    # Fondo
    c.setFillColorRGB(1, 1, 1)
    c.rect(
        0,
        0,
        label_width,
        label_height,
        fill=1,
        stroke=0,
    )

    margin = 7 * mm

    # Encabezado
    header_h = 30 * mm

    c.setFillColorRGB(0.05, 0.07, 0.09)

    c.roundRect(
        margin,
        label_height - margin - header_h,
        label_width - 2 * margin,
        header_h,
        4 * mm,
        fill=1,
        stroke=0,
    )

    c.setFillColorRGB(1, 1, 1)

    c.setFont('Helvetica-Bold', 20)

    c.drawCentredString(
        label_width / 2,
        label_height - 19 * mm,
        'CONTROL DE CALIDAD',
    )

    c.setFont('Helvetica-Bold', 15)

    c.drawCentredString(
        label_width / 2,
        label_height - 28 * mm,
        proceso,
    )

    # QR
    qr_size = 88 * mm

    qr_x = (label_width - qr_size) / 2
    qr_y = 50 * mm

    c.drawImage(
        qr_path,
        qr_x,
        qr_y,
        width=qr_size,
        height=qr_size,
        preserveAspectRatio=True,
        mask='auto',
    )

    # Separador
    c.setStrokeColorRGB(0.15, 0.15, 0.15)

    c.setLineWidth(1)

    c.line(
        margin + 6 * mm,
        42 * mm,
        label_width - margin - 6 * mm,
        42 * mm,
    )

    # Nombre
    c.setFillColorRGB(0, 0, 0)

    c.setFont('Helvetica-Bold', 20)

    c.drawCentredString(
        label_width / 2,
        32 * mm,
        nombre_maquina,
    )

    # Código visible
    c.setFont('Helvetica-Bold', 12)

    c.drawCentredString(
        label_width / 2,
        22 * mm,
        codigo_qr,
    )

    # Footer
    footer_h = 10 * mm

    c.setFillColorRGB(0.05, 0.07, 0.09)

    c.roundRect(
        margin,
        margin,
        label_width - 2 * margin,
        footer_h,
        3 * mm,
        fill=1,
        stroke=0,
    )

    c.setFillColorRGB(1, 1, 1)

    c.setFont('Helvetica-Bold', 10)

    c.drawCentredString(
        label_width / 2,
        margin + 3.5 * mm,
        'ESCANEAR PARA INICIAR CONTROL',
    )

    c.save()

    print(f'Generado: {pdf_path}')


for control in controles:
    generar_etiqueta(control)

print('QR de controles generados correctamente.')

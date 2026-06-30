const express = require('express');

const router = express.Router();

const {
    getContextoPorQr,
    crearRegistroControl,
} = require('../controllers/control.controller');

router.get('/contexto/:codigoQr', getContextoPorQr);
router.post('/registros', crearRegistroControl);

module.exports = router;
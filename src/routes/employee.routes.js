const { Router } = require('express');
const { getAllEmployees, getEmployee, createEmployee, updateEmployee, deleteEmployee, index } = require('../controllers/employee.controller');
const router = Router();

router.get('/', index)

router.get('/employees', getAllEmployees)

router.get('/employee/:id', getEmployee)

router.post('/employee', createEmployee)

router.put('/employee/:id', updateEmployee)

router.delete('/employee/:id', deleteEmployee)


module.exports = router;
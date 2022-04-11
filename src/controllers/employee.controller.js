const pool = require('../db')

const index = async (req, res) => {
  res.json({
      API: "Empleados"
  });
};

const getAllEmployees = async (req, res, next) => {
    try {
        const employees = await pool.query('SELECT * FROM Employee');
        res.json(employees.rows);
    } catch (error) {
        next(error);
    }
}

const getEmployee = async (req, res, next) => {
    try {
        const { id } = req.params;
        const result = await pool.query("SELECT * FROM employee WHERE employeeid = $1", [id]);
    
        if (result.rows.length === 0)
          return res.status(404).json({ message: "Empleado no encontrado" });
    
        res.json(result.rows[0]);
      } catch (error) {
        next(error);
      }
}

const createEmployee = async (req, res, next) => {
    const { firstname,
        lastname,
        gender,
        email,
        phonenumber,
        address,
        birthdate,
        documenttype,
        documentnumber } = req.body;

    try {
        const result = await pool.query('INSERT INTO Employee (firstname, lastname, gender, email, phonenumber, address, birthdate, documenttype, documentnumber, created) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, now()) RETURNING *', [
            firstname, 
            lastname, 
            gender, 
            email, 
            phonenumber, 
            address,
            birthdate, 
            documenttype, 
            documentnumber
        ]);
        res.json(result.rows[0]);
    } catch (error) {
      console.log(error);
        next(error);  
    }   
}

const updateEmployee = async (req, res, next) => {
    try {
        const { id } = req.params;
        const { firstname,
            lastname,
            gender,
            email,
            phonenumber,
            address,
            birthdate } = req.body;
    
        const result = await pool.query(
          "UPDATE employee SET firstname = $1, lastname = $2, gender = $3, email = $4, phonenumber = $5, address = $6, birthdate = $7, updated = now() WHERE employeeid = $8 RETURNING *",
          [firstname, lastname, gender, email, phonenumber, address, birthdate, id]
        );
    
        if (result.rows.length === 0)
          return res.status(404).json({ message: "Empleado no encontrado" });
    
        return res.json(result.rows[0]);
      } catch (error) {
        next(error);
      }
}

const deleteEmployee = async (req, res, next) => {
    try {
        const { id } = req.params;
        const result = await pool.query("DELETE FROM employee WHERE employeeid = $1", [id]);
    
        if (result.rowCount === 0)
          return res.status(404).json({ message: "Empleado no encontrado" });
        return res.json({ message: "Empleado eliminado"});
      } catch (error) {
        next(error);
      }
}

module.exports = {
    index,
    getAllEmployees,
    getEmployee,
    createEmployee,
    updateEmployee,
    deleteEmployee
}
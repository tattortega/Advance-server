--Crear una base de datos
CREATE DATABASE advance;

--Crear cada una de las tablas del diagrama
CREATE TYPE document AS ENUM ('Cedula','Cedula de extranjeria','Otro');
CREATE TYPE gender AS ENUM ('Hombre','Mujer','Otro');

CREATE TABLE employee(
    employeeid SERIAL PRIMARY KEY,
    firstname text not null,
    lastname text not null,
    gender gender not null,
    email text not null,
    phonenumber bigint not null,
    address text,
    documenttype document not null,
    documentnumber bigint not null,
    created timestamp,
    updated timestamp
);

ALTER TABLE employee ADD UNIQUE (documenttype, documentnumber);


CREATE TABLE employeeAccounts (
    employeeaccountid SERIAL PRIMARY KEY,
    employeeid int references employee(employeeid) on update cascade on delete cascade,
    bankname text not null,
    documenttype text not null,
    documentnumber bigint not null,
    status boolean
);

CREATE TABLE companyemployee (
    companyemployeeid SERIAL PRIMARY KEY,
    employeeid int references employee(employeeid) on update cascade on delete cascade,
    company text not null,
    companyemail text not null,
    salary bigint not null,
    workstartdate date not null,
    workenddate date
);

--Insertar datos en cada una de las tablas
INSERT INTO employee (firstname, lastname, gender, email, phonenumber, address, documenttype, documentnumber, created) VALUES
    ('Daniel', 'Jimenez', 'M', 'dj@gmail.com', 31284851, 'calle 15 #5-6', 'CC', 1245232, now()),
    ('Luis', 'Ortega', 'M', 'lo@gmail.com', 31054661, 'calle 0 #52-8', 'CC', 8546231, now()),
    ('Ramiro', 'Rincon', 'M', 'rr@gmail.com', 32571532, 'av 0 #852-87', 'CC', 742152, now()),
    ('Juana', 'Nieto', 'F', 'jn@gmail.com', 31796820, 'carrera 10 #7-89', 'CE', 1002401, now()),
    ('Laura', 'Correa', 'F', 'lc@gmail.com', 31223870, 'calle 42 #7-85', 'PP', 23004251, now()),
    ('Marta', 'Moreno', 'F', 'mm@gmail.com', 31489325, 'av 14 #82-63', 'CC', 8965245, now()),
    ('Hernando','Suarez','M', 'hs@gmail.com', 30127463, 'av 5 # 47-8', 'CE', 78542352, now()),
    ('Bruno', 'Fernandez', 'M', 'bf@gmail.com', 32053618, 'carrera 20 #4-20', 'PP', 42012035, now());

INSERT INTO employeeaccounts (employeeid, bankname, documenttype, documentnumber) VALUES
    (1, 'Banco de Occidente', 'CC', 1245232),
    (2, 'Bancolombia', 'CC', 8546231),
    (3, 'Banco de Bogota', 'CC', 745252),
    (4, 'Bancolombia', 'CE', 100501),
    (5, 'Davivienda', 'PP', 2305251),
    (6, 'Bancolombia', 'CC', 8965245),
    (7, 'Davivienda', 'CE', 7854352),
    (8, 'Banco Popular', 'PP', 4200035);

INSERT INTO companyemployee (employeeid, company, companyemail, salary, workstartdate) VALUES
    (1, 'Seguros Bolivar', 'dj@sg.com', 2500000, '2018-01-01'),
    (2, 'Argos', 'lo@arg.com', 3650000, '2022-02-01'),
    (3, 'Nutresa', 'rr@nt.com', 1750000, '2019-05-01'),
    (4, 'EPM', 'jn@epm.com', 12200000, '2022-03-01'),
    (5, 'EPM', 'lc@epm.com', 9500000, '2021-06-01'),
    (6, 'Argos', 'mm@arg.com', 6420000, '2020-04-01'),
    (7,'EPM', 'hs@epm.com', 10240000, '2018-11-01'),
    (8,'Seguros Bolivar', 'bf@sg.com', 2850000, '2017-03-01');


--Eliminar un registro especifico de la tabla employee
DELETE * FROM employee WHERE employee.employeeid=5;

--Una consulta que asocie las tres tablas
SELECT employee.email, employeeaccounts.bankname, companyemployee.company
FROM ((employee
INNER JOIN employeeaccounts ON employee.employeeid=employeeaccounts.employeeid)
INNER JOIN companyemployee ON employee.employeeid=companyemployee.employeeid);

--Una consulta que filtre los registros de la tabla employee por una parte del firstname
SELECT * FROM employee WHERE firstname ~* 'l';

--Una consulta que me ordene los registros por lastname de forma alfabética ascendente.
SELECT * FROM employee ORDER BY employee.lastname ASC;

--Una consulta que me agrupe y me diga cuantos empleados son de la misma compañía,
SELECT companyemployee.company, COUNT(employee.employeeid) AS employees
FROM (employee
INNER JOIN companyemployee ON employee.employeeid=companyemployee.employeeid)
GROUP BY companyemployee.company;

--Modificar la tabla employee para agregar una columna de tipo timestamp, la cual tendrá por nombre birthdate.
ALTER TABLE employee ADD birthdate timestamp;
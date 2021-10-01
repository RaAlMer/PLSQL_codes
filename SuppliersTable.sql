-- Table to try some procedures and functions
CREATE TABLE tbproveedores
(
    n_idproveedor   NUMBER(3),
    v_desproveedor  VARCHAR2(50 CHAR),
    d_fechaalta     DATE
);

INSERT INTO tbproveedores
    VALUES (1, 'Martillos La Forja', TO_DATE('19/04/2021', 'DD/MM/YYYY'));
INSERT INTO tbproveedores 
    VALUES (2, 'Materiales El Bueno', TO_DATE('01/05/2021', 'DD/MM/YYYY'));
INSERT INTO tbproveedores 
    VALUES (3, 'Almacenes Los Mejores', TO_DATE('07/05/2021', 'DD/MM/YYYY'));

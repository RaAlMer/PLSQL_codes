--Supplier's table
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

CREATE TABLE tb_logproveedores
(
    n_idproveedorold  NUMBER(3),
    n_idproveedornew  NUMBER(3),
    v_desproveedorold VARCHAR2(50 CHAR),
    v_desproveedornew VARCHAR2(50 CHAR),
    d_fechaaltaold    DATE,
    d_fechaaltanew    DATE,
    d_fecharegistro   DATE,
    v_accion          VARCHAR2(10 CHAR)
);

CREATE OR REPLACE TRIGGER tr_log_proveedores
AFTER INSERT OR UPDATE OR DELETE ON tbproveedores
FOR EACH ROW
DECLARE
    vv_accion VARCHAR2(10 CHAR);
BEGIN
    CASE
        WHEN INSERTING THEN vv_accion := 'INSERT';
        WHEN UPDATING THEN vv_accion := 'UPDATE';
        WHEN DELETING THEN vv_accion := 'DELETE';
    END CASE;
    
    INSERT INTO tb_logproveedores (n_idproveedorold, n_idproveedornew,
                                   v_desproveedorold, v_desproveedornew,
                                   d_fechaaltaold, d_fechaaltanew,
                                   d_fecharegistro, v_accion)
        VALUES (:OLD.n_idproveedor, :NEW.n_idproveedor,
                :OLD.v_desproveedor, :NEW.v_desproveedor,
                :OLD.d_fechaalta, :NEW.d_fechaalta,
                SYSDATE, vv_accion);
 
END tr_log_proveedores;

INSERT INTO tbproveedores (n_idproveedor, v_desproveedor, d_fechaalta)
VALUES (4, 'Ferreteria Los Franceses', SYSDATE);

UPDATE tbproveedores
SET d_fechaalta = SYSDATE
WHERE n_idproveedor = 2;

DELETE FROM tbproveedores
WHERE n_idproveedor = 4;

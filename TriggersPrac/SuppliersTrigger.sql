-- Log table to track any changes in suppliers table
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

-- Trigger that gets any change in suppliers' table to the log table
CREATE OR REPLACE TRIGGER tr_log_proveedores
AFTER INSERT OR UPDATE OR DELETE ON tbproveedores
FOR EACH ROW
DECLARE
    vv_accion VARCHAR2(10 CHAR); --Variable to save the action taken in the suppliers' table
BEGIN
    CASE
        WHEN INSERTING THEN vv_accion := 'INSERT'; --Action: insert
        WHEN UPDATING THEN vv_accion := 'UPDATE';  --Action: update
        WHEN DELETING THEN vv_accion := 'DELETE';  --Action: delete
    END CASE;
    
    INSERT INTO tb_logproveedores (n_idproveedorold, n_idproveedornew, -- Insert the old and new records after a change is made in the suppliers' table
                                   v_desproveedorold, v_desproveedornew,
                                   d_fechaaltaold, d_fechaaltanew,
                                   d_fecharegistro, v_accion)
        VALUES (:OLD.n_idproveedor, :NEW.n_idproveedor,
                :OLD.v_desproveedor, :NEW.v_desproveedor,
                :OLD.d_fechaalta, :NEW.d_fechaalta,
                SYSDATE, vv_accion);
 
END tr_log_proveedores;

INSERT INTO tbproveedores (n_idproveedor, v_desproveedor, d_fechaalta) --Insert test
VALUES (4, 'Ferreteria Los Franceses', SYSDATE);

UPDATE tbproveedores --Update test
SET d_fechaalta = SYSDATE
WHERE n_idproveedor = 2;

DELETE FROM tbproveedores --Delete test
WHERE n_idproveedor = 4;

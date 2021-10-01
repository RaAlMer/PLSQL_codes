-- Log table to track any changes in suppliers table
CREATE TABLE tb_logproductos
(
    n_idproductoold   NUMBER(3),
    n_idproductonew   NUMBER(3),
    v_desproductoold  VARCHAR2(20 CHAR),
    v_desproductonew  VARCHAR2(20 CHAR),
    n_unidadesold     NUMBER(3),
    n_unidadesnew     NUMBER(3),
    n_precioudold     NUMBER(6,2),
    n_precioudnew     NUMBER(6,2),
    d_fechaaltaold    DATE,
    d_fechaaltanew    DATE,
    d_fechavencold    DATE,
    d_fechavencnew    DATE,
    v_localidadold    VARCHAR2(20 CHAR),
    v_localidadnew    VARCHAR2(20 CHAR),
    b_activoold       VARCHAR2(20 CHAR),
    b_activonew       VARCHAR2(20 CHAR),
    n_porcentajeold   NUMBER(10,2),
    n_porcentajenew   NUMBER(10,2),
    d_fecharegistro   DATE,
    v_accion          VARCHAR2(10 CHAR)
);

-- Trigger that gets any change in porducts' table to the log table
CREATE OR REPLACE TRIGGER tr_log_productos
AFTER INSERT OR UPDATE OR DELETE ON tb_productos
FOR EACH ROW
DECLARE
    vv_accion VARCHAR2(10 CHAR); --Variable to save the action taken in the suppliers' table
BEGIN
    CASE
        WHEN INSERTING THEN vv_accion := 'INSERT'; --Action: insert
        WHEN UPDATING THEN vv_accion := 'UPDATE';  --Action: update
        WHEN DELETING THEN vv_accion := 'DELETE';  --Action: delete
    END CASE;
    
    INSERT INTO tb_logproductos (n_idproductoold, n_idproductonew, -- Insert the old and new records after a change is made in the suppliers' table
                                   v_desproductoold, v_desproductonew,
                                   n_unidadesold, n_unidadesnew,
                                   n_precioudold, n_precioudnew,
                                   d_fechaaltaold, d_fechaaltanew,
                                   d_fechavencold, d_fechavencnew,
                                   v_localidadold, v_localidadnew,
                                   b_activoold, b_activonew,
                                   n_porcentajeold, n_porcentajenew,
                                   d_fecharegistro, v_accion)
        VALUES (:OLD.n_idproducto, :NEW.n_idproducto,
                :OLD.v_desproducto, :NEW.v_desproducto,
                :OLD.n_unidades, :NEW.n_unidades,
                :OLD.n_precioud, :NEW.n_precioud,
                :OLD.d_fechaalta, :NEW.d_fechaalta,
                :OLD.d_fechavenc, :NEW.d_fechavenc,
                :OLD.v_localidad, :NEW.v_localidad,
                :OLD.b_activo, :NEW.b_activo,
                :OLD.n_porcentaje, :NEW.n_porcentaje,
                SYSDATE, vv_accion);
 
END tr_log_productos;

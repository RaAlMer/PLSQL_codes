-- Suppliers' table
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

--Function to insert a new supplier in our table
CREATE OR REPLACE FUNCTION fn_alta_proveedor (po_n_idproveedor  OUT     TBPROVEEDORES.N_IDPROVEEDOR%TYPE, --Out parameter - Supplier's ID
                                              pi_v_desproveedor IN      TBPROVEEDORES.V_DESPROVEEDOR%TYPE,  --In parameter - Supplier's name
                                              pio_d_fechaalta   IN OUT  TBPROVEEDORES.D_FECHAALTA%TYPE, -- In/out parameter - Supplier's adding date
                                              po_v_error        OUT     VARCHAR2) --Out parameter - Error's message
RETURN BOOLEAN IS
    vv_desproveedor     TBPROVEEDORES.V_DESPROVEEDOR%TYPE; --Supplier's name
    vn_nomprovexiste    NUMBER(1); --Variable to check if the supplier's ID is already in use
    ex_nomprovexiste    EXCEPTION; --Exception called when supplier already exists
    
BEGIN
    BEGIN
        SELECT MAX(n_idproveedor) + 1 --New supplier's ID
            INTO po_n_idproveedor     --Maximum ID + 1
            FROM tbproveedores;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            po_n_idproveedor := 1;
    END;
    
    vv_desproveedor := NVL(pi_v_desproveedor, 'No definido'); --It's needed to create a variable as it's an IN parameter
    pio_d_fechaalta := NVL(pio_d_fechaalta, SYSDATE); --It's not needed to create a variable as it's an IN/OUT parameter so it can get a value
    
    BEGIN
        SELECT 1
            INTO vn_nomprovexiste --Checks if the supplier's name already exists
            FROM tbproveedores
            WHERE v_desproveedor = vv_desproveedor;
            
            RAISE ex_nomprovexiste; --If it exists, it raises an error
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN --If it does not exist, it continue with the code
            NULL;
    END;
    
    INSERT INTO tbproveedores (n_idproveedor, v_desproveedor, d_fechaalta) --Inserts our variables into the table
    VALUES (po_n_idproveedor, vv_desproveedor, pio_d_fechaalta);
    
    RETURN TRUE;
    
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        po_v_error := 'Ya existe un proveedor con el ID que intenta registrar.'; --Error when the ID already exists
        RETURN FALSE;
        
    WHEN ex_nomprovexiste THEN
        po_v_error := 'Ya existe un proveedor con el nombre que intenta registrar.'; --Error when the name already exists
        RETURN FALSE;
        
END fn_alta_proveedor;

--Calling our function to insert a new supplier
DECLARE
    vn_idproveedor  NUMBER;
    vd_fecha        DATE;
    vb_altaok       BOOLEAN;
    vv_erroralta    VARCHAR2(2000 CHAR); --Error message from the function
BEGIN
    vb_altaok := fn_alta_proveedor(vn_idproveedor, 'Martillos La Forja', vd_fecha, vv_erroralta);
    IF vb_altaok THEN
        DBMS_OUTPUT.PUT_LINE('Se ha dado de alta un proveedor con ID ' || vn_idproveedor --If there's no supplier with that name (TRUE)
                            || ' a fecha de ' || TO_CHAR(vd_fecha, 'DD/MM/YYYY'));
    ELSE
        DBMS_OUTPUT.PUT_LINE('Error al dar de alta el proveedor. Error: ' || vv_erroralta); --If there's already one supplier with that name (FALSE)
    END IF;
END;

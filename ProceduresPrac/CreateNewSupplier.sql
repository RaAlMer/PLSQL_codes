-- Tabla proveedores
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
    
-- Bloque para introducir un nuevo proveedor a la tabla    
DECLARE
    vn_idproveedor      TBPROVEEDORES.N_IDPROVEEDOR%TYPE;
    vv_desproveedor     TBPROVEEDORES.V_DESPROVEEDOR%TYPE := 'Martillos La Forja'; -- Se le da un valor inicial para meter al proveedor
    vd_fechaalta        TBPROVEEDORES.D_FECHAALTA%TYPE := SYSDATE;
    vn_nomprovexiste    NUMBER(1);
    ex_nomprovexiste    EXCEPTION;
    
BEGIN
    BEGIN
        SELECT MAX(n_idproveedor) + 1 -- Es el ID del nuevo proveedor que vamos a insertar
            INTO vn_idproveedor       -- Buscamos el máximo ID y le añadimos 1
            FROM tbproveedores;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN -- Si no hay registros en la tabla, le introduce el primer valor
            vn_idproveedor := 1;
    END;
    
    vv_desproveedor := NVL(vv_desproveedor, 'No definido'); -- Si no se introduce nombre de proveedor se pondrá uno sin definir
    
    BEGIN
        SELECT 1
            INTO vn_nomprovexiste -- Comprueba si el nombre del proveedor existe y si es así lanza el error
            FROM tbproveedores
            WHERE v_desproveedor = vv_desproveedor;
            
            RAISE ex_nomprovexiste; -- Si se lanza este error significa que ya hay proveedor con ese nombre
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN --Si no encuentra el dato en la selección, significa que no hay proveedor con ese nombre
            NULL;
    END;
    
    INSERT INTO tbproveedores (n_idproveedor, v_desproveedor, d_fechaalta)
    VALUES (vn_idproveedor, vv_desproveedor, vd_fechaalta);
    
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Ya existe un proveedor con el ID que intenta registrar.');
        
    WHEN ex_nomprovexiste THEN
        DBMS_OUTPUT.PUT_LINE('Ya existe un proveedor con el nombre que intenta registrar.');
        
END;

-- El anterior bloque se puede hacer mejor creando un procedimiento y llamandolo cuando sea necesario
CREATE OR REPLACE PROCEDURE pr_alta_proveedor (po_n_idproveedor      OUT        TBPROVEEDORES.N_IDPROVEEDOR%TYPE,
                                               pi_v_desproveedor     IN         TBPROVEEDORES.V_DESPROVEEDOR%TYPE,
                                               pio_d_fechaalta       IN OUT     TBPROVEEDORES.D_FECHAALTA%TYPE)
IS  
    vv_desproveedor     TBPROVEEDORES.V_DESPROVEEDOR%TYPE;
    vn_nomprovexiste    NUMBER(1);
    ex_nomprovexiste    EXCEPTION;
    
BEGIN
    BEGIN
        SELECT MAX(n_idproveedor) + 1 -- Es el ID del nuevo proveedor que vamos a insertar
            INTO po_n_idproveedor       -- Buscamos el máximo ID y le añadimos 1
            FROM tbproveedores;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            po_n_idproveedor := 1;
    END;
    
    vv_desproveedor := NVL(pi_v_desproveedor, 'No definido'); -- Se necesita crear variable ya que es un parámetro de entrada
    pio_d_fechaalta := NVL(pio_d_fechaalta, SYSDATE); -- No se necesita crear variable ya que es un parámetro de entrada y salida, y se le puede asignar un valor
    
    BEGIN
        SELECT 1
            INTO vn_nomprovexiste -- Comprueba si el nombre del proveedor existe y si es así lanza el error
            FROM tbproveedores
            WHERE v_desproveedor = vv_desproveedor;
            
            RAISE ex_nomprovexiste; -- Si se lanza este error se saltará las dos líneas de más abajo
                                    -- de INSERT INTO y VALUES, e irá a la excepción del bloque padre
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
    END;
    
    INSERT INTO tbproveedores (n_idproveedor, v_desproveedor, d_fechaalta)
    VALUES (po_n_idproveedor, vv_desproveedor, pio_d_fechaalta);
    
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Ya existe un proveedor con el ID que intenta registrar.');
        
    WHEN ex_nomprovexiste THEN
        DBMS_OUTPUT.PUT_LINE('Ya existe un proveedor con el nombre que intenta registrar.');
        
END pr_alta_proveedor;

-- Llamamos al procedimiento
DECLARE
    vn_idproveedor  NUMBER; -- El id del proveedor nos lo dará el procedimiento automaticamente
    vd_fecha        DATE := SYSDATE; -- Le damos la fecha del sistema
BEGIN
    pr_alta_proveedor(vn_idproveedor, 'Martillos La Forja', vd_fecha); -- Si aquí el nombre del proveedor ya existía en la table, entonces nos lanzará nuestro error
    DBMS_OUTPUT.PUT_LINE(vn_idproveedor); -- Mostramos en pantalla el id del proveedor que nos da el procedimiento ya que no lo conocemos
END;

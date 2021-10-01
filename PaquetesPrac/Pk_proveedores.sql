-- Paquete con una función y un procedimiento (que llama a esta función) para que nos de el nombre de un proveedor según su número de identificación (id)
CREATE OR REPLACE PACKAGE pk_proveedores IS
    FUNCTION fn_nombre_proveedor (pi_n_idproveedor TBPROVEEDORES.N_IDPROVEEDOR%TYPE)
    RETURN TBPROVEEDORES.V_DESPROVEEDOR%TYPE;
    PROCEDURE pr_invoca_alta_p (pi_n_idproveedor TBPROVEEDORES.N_IDPROVEEDOR%TYPE);
END pk_proveedores;

-- Hay que declarar las funciones y procedimientos que se usen en el paquete en el bloque superior
CREATE OR REPLACE PACKAGE BODY pk_proveedores IS

    FUNCTION fn_nombre_proveedor (pi_n_idproveedor TBPROVEEDORES.N_IDPROVEEDOR%TYPE)
    RETURN TBPROVEEDORES.V_DESPROVEEDOR%TYPE IS
        vv_desproveedor TBPROVEEDORES.V_DESPROVEEDOR%TYPE;
    BEGIN
        SELECT v_desproveedor
            INTO vv_desproveedor
            FROM tbproveedores
         WHERE n_idproveedor = pi_n_idproveedor;
         
         RETURN vv_desproveedor;
    
    END fn_nombre_proveedor;
    
    PROCEDURE pr_invoca_alta_p (pi_n_idproveedor TBPROVEEDORES.N_IDPROVEEDOR%TYPE) IS
        vv_desproveedor TBPROVEEDORES.V_DESPROVEEDOR%TYPE;
    BEGIN
        vv_desproveedor := fn_nombre_proveedor(pi_n_idproveedor => pi_n_idproveedor);
        DBMS_OUTPUT.PUT_LINE('El nombre del proveedor es ' || vv_desproveedor);
    END pr_invoca_alta_p;
    
END pk_proveedores;

-- Probamos a llamar al paquete con el id = 1
BEGIN
    pk_proveedores.pr_invoca_alta_p(1);
END;

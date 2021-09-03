--Function to check if a product exists
CREATE OR REPLACE FUNCTION fn_existe_producto (po_v_existprod    OUT     VARCHAR2, --Out parameter - Does the product exist?
                                               pi_v_desproducto  IN      TB_PRODUCTOS.V_DESPRODUCTO%TYPE, --In parameter - Product's name
                                               po_v_errornoprod  OUT     VARCHAR2) --Out parameter - Error if no product's name was inserted
RETURN VARCHAR2 IS
    vv_desproducto      TB_PRODUCTOS.V_DESPRODUCTO%TYPE; --Product's name
    vv_existprod        VARCHAR2(30 CHAR); --Variable to store message if product exist
    vn_nomprodexist     NUMBER(1); --Variable to check if the product exists
    ex_existprod        EXCEPTION; --Exception called when the product exists!
    ex_noprod           EXCEPTION; --Exception called when there's no product's name
    
BEGIN
    vv_desproducto  := NVL(pi_v_desproducto, 'No definido'); --It's needed to create a variable as it's an IN parameter
    
    IF vv_desproducto = 'No definido' THEN --If there's no product's name checked, it raises this error
        RAISE ex_noprod;
    END IF;
    
    BEGIN
        SELECT 1
            INTO vn_nomprodexist --Checks if the product's name already exists
            FROM tb_productos
            WHERE v_desproducto = vv_desproducto;
            
            RAISE ex_existprod; --If it exists, it raises an error with a message telling it exists
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN --If it does not exist, it raises this error telling it does not exist
            po_v_existprod := 'El producto ' || vv_desproducto || ' no existe.';
    END;
    
    RETURN po_v_existprod; --Returns the message telling if it exists
    
EXCEPTION
    WHEN ex_noprod THEN
        po_v_errornoprod := 'No se introdujo ningún producto para comprobar.'; --Error when there's no product's name inserted
        RETURN po_v_errornoprod; --Returns the message telling there's no product's name to check
        
    WHEN ex_existprod THEN
        po_v_existprod := 'Ya existe un producto con el nombre que intenta registrar.'; --Error when the product already exists
        RETURN po_v_existprod; --Returns the message telling if it exists
        
END fn_existe_producto;

--Calling our function to check if a product already exists
DECLARE
    vv_desprod      TB_PRODUCTOS.V_DESPRODUCTO%TYPE := 'Clavo'; --Product's name
    vv_textfunc     VARCHAR2(100 CHAR); --Answer given by the function
    vv_existprod    VARCHAR2(100 CHAR); --Message checking if it exists or not
    vv_erroralta    VARCHAR2(2000 CHAR); --Error message if there's no product checked
BEGIN
    vv_textfunc := fn_existe_producto(vv_existprod, vv_desprod, vv_erroralta);
    DBMS_OUTPUT.PUT_LINE(vv_textfunc); --Print the answer of the function to the console
    
END;

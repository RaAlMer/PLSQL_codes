--Function to check if a product is active
CREATE OR REPLACE FUNCTION fn_es_producto_activo (po_v_bactivo      OUT     VARCHAR2, --Out parameter - Is the product active?
                                                  pi_v_desproducto  IN      TB_PRODUCTOS.V_DESPRODUCTO%TYPE, --In parameter - Product's name
                                                  po_v_errornoprod  OUT     VARCHAR2) --Out parameter - Error if no product's name was inserted
RETURN VARCHAR2 IS
    vv_desproducto      TB_PRODUCTOS.V_DESPRODUCTO%TYPE; --Product's name
    vv_prodactiv        VARCHAR(5 CHAR); --Variable to check if the product is active
    ex_noprod           EXCEPTION; --Error when no product's name is checked
    
BEGIN
    vv_desproducto  := NVL(pi_v_desproducto, 'No definido'); --It's needed to create a variable as it's an IN parameter
    
    IF vv_desproducto = 'No definido' THEN --If there's no product's name checked, it raises this error
        RAISE ex_noprod;
    END IF;
    
    BEGIN
        SELECT b_activo
            INTO vv_prodactiv   --Checks if the product is active (TRUE) or not (FALSE)
            FROM tb_productos
            WHERE v_desproducto = vv_desproducto;
            
            IF vv_prodactiv = 'TRUE' THEN
                po_v_bactivo := 'El producto está activo.'; --If it is active, it raises an error with a message telling it is ACTIVE
            ELSIF vv_prodactiv = 'FALSE' THEN
                po_v_bactivo := 'El producto ha caducado, no está activo.'; --If it is not active, it raises an error with a message telling it is NOT ACTIVE
            END IF;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN --The product checked does not exist
            po_v_bactivo := 'El producto ' || vv_desproducto || ' no existe.';
    END;
    
    RETURN po_v_bactivo; --Returns the message telling if it is active

EXCEPTION
    WHEN ex_noprod THEN
        po_v_errornoprod := 'No se introdujo ningún producto para comprobar.'; --Error when there's no product's name inserted
        RETURN po_v_errornoprod; --Returns the message telling there's no product's name to check
        
END fn_es_producto_activo;

--Calling our function to check if a product is active (b_activo = TRUE) or not (b_activo = FALSE)
DECLARE
    vv_desprod      TB_PRODUCTOS.V_DESPRODUCTO%TYPE := 'Clavo'; --Product's name
    vv_textfunc     VARCHAR2(100 CHAR); --Answer given by the function
    vv_bactivo      VARCHAR2(100 CHAR); --Message checking if it is active or not
    vv_erroralta    VARCHAR2(100 CHAR); --Error message if there's no product checked
BEGIN
    vv_textfunc := fn_es_producto_activo(vv_bactivo, vv_desprod, vv_erroralta);
    DBMS_OUTPUT.PUT_LINE(vv_textfunc); --Print the answer of the function to the console
    
END;

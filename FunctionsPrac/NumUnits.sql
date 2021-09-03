--Function to check the number of units from a product
CREATE OR REPLACE FUNCTION fn_num_unidades_producto (po_v_unidades     OUT     VARCHAR2, --Out parameter - Unit's number from a product
                                                     pi_v_desproducto  IN      TB_PRODUCTOS.V_DESPRODUCTO%TYPE, --In parameter - Product's name
                                                     po_v_errornoprod  OUT     VARCHAR2) --Out parameter - Error if no product's name was inserted
RETURN VARCHAR2 IS
    vv_desproducto      TB_PRODUCTOS.V_DESPRODUCTO%TYPE; --Product's name
    vn_uds              NUMBER(3); --Number of units from the product
    ex_noprod           EXCEPTION; --Error when no product's name is checked
    
BEGIN
    vv_desproducto  := NVL(pi_v_desproducto, 'No definido'); --It's needed to create a variable as it's an IN parameter
    
    IF vv_desproducto = 'No definido' THEN --If there's no product's name checked, it raises this error
        RAISE ex_noprod;
    END IF;
    
    BEGIN
        SELECT n_unidades
            INTO vn_uds   --Checks the number of units from a product
            FROM tb_productos
            WHERE v_desproducto = vv_desproducto;
            
            po_v_unidades := 'Hay ' || vn_uds || ' unidades del producto ' || vv_desproducto || '.'; --Message with the number of units
    EXCEPTION
        WHEN NO_DATA_FOUND THEN --The product checked does not exist
            po_v_unidades := 'El producto ' || vv_desproducto || ' no existe.';
    END;
    
    RETURN po_v_unidades; --Returns the number of units

EXCEPTION
    WHEN ex_noprod THEN
        po_v_errornoprod := 'No se introdujo ningún producto para comprobar.'; --Error when there's no product's name inserted
        RETURN po_v_errornoprod; --Returns the message telling there's no product's name to check
        
END fn_num_unidades_producto;

--Calling our function to check the number of units
DECLARE
    vv_desprod         TB_PRODUCTOS.V_DESPRODUCTO%TYPE := 'Clavo'; --Product's name
    vv_textfunc        VARCHAR2(100 CHAR); --Answer given by the function
    vv_unidades        VARCHAR2(100 CHAR); --Message telling the number of units
    vv_errornoprod     VARCHAR2(100 CHAR); --Error message if there's no product checked
BEGIN
    vv_textfunc := fn_num_unidades_producto(vv_unidades, vv_desprod, vv_errornoprod);
    DBMS_OUTPUT.PUT_LINE(vv_textfunc); --Print the answer of the function to the console
    
END;

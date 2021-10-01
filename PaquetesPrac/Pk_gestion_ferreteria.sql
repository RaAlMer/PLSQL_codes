-- Package to generate a product from a file, update the price of the product that was inserted before the new one, delete expired products and list the rest of them
CREATE OR REPLACE PACKAGE pk_gestion_ferreteria IS
    PROCEDURE pr_generar_fichero_productos (pi_v_cadena IN VARCHAR2, po_v_error OUT VARCHAR2);
    PROCEDURE pr_actualizar_precios_proveedor;
    PROCEDURE pr_borrar_productos_vencidos;
    PROCEDURE pr_list_products;
END pk_gestion_ferreteria;

-- Functions and procedures must be declared before in the package's above block
CREATE OR REPLACE PACKAGE BODY pk_gestion_ferreteria IS

    -- Procedure to generate the products registered in an array
    PROCEDURE pr_generar_fichero_productos (pi_v_cadena   IN  VARCHAR2,
                                            po_v_error    OUT VARCHAR2)
    IS  
        vn_idproducto       NUMBER(3);
        vv_texto            VARCHAR2(100 CHAR);
        vv_producto         VARCHAR2(20 CHAR); 
        vn_unidades         NUMBER(3); 
        vn_precio           NUMBER(6,2); 
        vd_fecha_venc       DATE; 
        vv_localildad       VARCHAR2(20 CHAR);
        vn_nomprodexiste    NUMBER(1); --Variable to check if the product's ID is already in use
        ex_nomprodexiste    EXCEPTION; --Exception called when supplier already exists
        
    BEGIN
        
        BEGIN
            SELECT MAX(n_idproducto) + 1 
                INTO vn_idproducto    
                FROM tb_productos;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                vn_idproducto := 1;
        END;
        
        vv_texto            := pi_v_cadena;
        vv_producto         := TRIM(' ' FROM SUBSTR(vv_texto, 1, INSTR(vv_texto, '|') -1)); 
        vn_unidades         := TO_NUMBER(SUBSTR(vv_texto, INSTR(vv_texto, '|', 1, 1) + 1, (INSTR(vv_texto, '|', 1, 2) - (INSTR(vv_texto, '|', 1, 1) +1)))); 
        vn_precio           := SUBSTR(vv_texto, INSTR(vv_texto, '|', 1, 2) + 1, (INSTR(vv_texto, '|', 1, 3) - (INSTR(vv_texto, '|', 1, 2) +1))); 
        vd_fecha_venc       := TO_DATE(SUBSTR(vv_texto, INSTR(vv_texto, '|', 1, 3) + 1, (INSTR(vv_texto, '|', 1, 4) - (INSTR(vv_texto, '|', 1, 3) +1))), 'DD/MM/YYYY'); 
        vv_localildad       := NVL(TRIM(' ' FROM SUBSTR(vv_texto, INSTR(vv_texto, '|', 1, 4) + 1, (INSTR(vv_texto, '|', 1, 5) - (INSTR(vv_texto, '|', 1, 4) +1)))), 'Sin localidad');
        
        BEGIN
            SELECT 1
                INTO vn_nomprodexiste --Checks if the product's name already exists
                FROM tb_productos
                WHERE v_desproducto = vv_producto;
                
                RAISE ex_nomprodexiste; --If it exists, it raises an error
        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN --If it does not exist, it continue with the code
                NULL;
        END;
        
        INSERT INTO tb_productos (n_idproducto, v_desproducto, n_unidades, n_precioud, d_fechaalta, d_fechavenc, v_localidad, b_activo) --Inserts our variables into the product's table
        VALUES (vn_idproducto, vv_producto, vn_unidades, vn_precio, SYSDATE, vd_fecha_venc, vv_localildad, 'TRUE');
            
    EXCEPTION
        WHEN ex_nomprodexiste THEN
        DBMS_OUTPUT.PUT_LINE('Ya existe un producto con ese nombre que intenta registrar.'); --Error when the name already exists
        
    END pr_generar_fichero_productos;
    
    -- Procedure to update prices
    PROCEDURE pr_actualizar_precios_proveedor
    IS  
        vn_idproducto   TB_PRODUCTOS.N_IDPRODUCTO%TYPE; --Variable to save the product's ID
        vn_precioud     TB_PRODUCTOS.N_PRECIOUD%TYPE;   --Variable to save the old price
        vn_nuevoprecio  TB_PRODUCTOS.N_PRECIOUD%TYPE;   --Variable to save the new price
        vn_porcentaje   TB_PRODUCTOS.N_PORCENTAJE%TYPE; --Variable to save the percentage of change in the product's price
        
    BEGIN
        SELECT MAX(n_idproducto) - 1 -- It will update the price of the product added before the new one
                INTO vn_idproducto    
                FROM tb_productos;
                
        BEGIN
            SELECT n_precioud -- Query to insert the old price into its variable (vn_precioud)
             INTO vn_precioud
             FROM tb_productos
             WHERE n_idproducto = vn_idproducto;
        END;
        BEGIN
            vn_nuevoprecio := 1.05 * vn_precioud; -- New product's price increased a 5%
            vn_porcentaje := (vn_nuevoprecio/vn_precioud) * 100; -- Percentage of change in prices
        END;
        
        BEGIN
            UPDATE tb_productos -- Query to update the new price
             SET n_precioud = vn_nuevoprecio
            WHERE n_idproducto = vn_idproducto;
        END;
        
        BEGIN
            UPDATE tb_productos -- Query to add the percentage into the table
             SET n_porcentaje = vn_porcentaje
            WHERE n_idproducto = vn_idproducto;
        END;
            
    END pr_actualizar_precios_proveedor;
    
    -- Procedure to delete the expired products
    PROCEDURE pr_borrar_productos_vencidos
    IS  
    BEGIN
        DELETE
         FROM tb_productos t
         WHERE t.n_idproducto IN (SELECT st.n_idproducto -- Selects the ID of the products to be deleted
                                 FROM tb_productos st
                                 WHERE st.b_activo = 'FALSE');
    
    END pr_borrar_productos_vencidos;
    
    -- Procedure to list the products of the product's table
    PROCEDURE pr_list_products IS 
        CURSOR c_products IS 
            SELECT n_idproducto, v_desproducto, n_unidades, n_precioud, d_fechaalta, d_fechavenc, v_localidad, b_activo
            FROM tb_productos; 

    BEGIN 
       FOR r_producto IN c_products LOOP 
       DBMS_OUTPUT.PUT_LINE('El ID del producto es ' || r_producto.N_IDPRODUCTO);
       DBMS_OUTPUT.PUT_LINE('El nommbre del producto es ' || r_producto.V_DESPRODUCTO); 
       DBMS_OUTPUT.PUT_LINE('El número de unidades del producto es ' || r_producto.N_UNIDADES); 
       DBMS_OUTPUT.PUT_LINE('El precio por unidad del producto es ' || r_producto.N_PRECIOUD); 
       DBMS_OUTPUT.PUT_LINE('La fecha de alta del producto es ' || TO_CHAR(r_producto.D_FECHAALTA, 'DD/MM/YYYY')); 
       DBMS_OUTPUT.PUT_LINE('La fecha de vencimiento del producto es ' || TO_CHAR(r_producto.D_FECHAVENC, 'DD/MM/YYYY'));
       DBMS_OUTPUT.PUT_LINE('La localidad del producto es ' || r_producto.V_LOCALIDAD); 
       DBMS_OUTPUT.PUT_LINE('El producto está activo'); 
       DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------'); 
       END LOOP; 
    
    END pr_list_products;
   
END pk_gestion_ferreteria;

-- Test of the package
DECLARE
    vv_cadena    VARCHAR2(100 CHAR) := '  Tuerca |100|0.01|23/11/2021| |      '; -- Array containing the new product
    vv_erroralta VARCHAR2(2000 CHAR); --Error message from the function
BEGIN
    pk_gestion_ferreteria.pr_generar_fichero_productos(vv_cadena, vv_erroralta);
    pk_gestion_ferreteria.pr_actualizar_precios_proveedor;
    pk_gestion_ferreteria.pr_borrar_productos_vencidos;
    pk_gestion_ferreteria.pr_list_products;
END;

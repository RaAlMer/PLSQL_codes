-- Tabla de productos de un proveedor
CREATE TABLE tb_productos
(
    n_idproducto    NUMBER(3),
    v_desproducto   VARCHAR2(20 CHAR),
    n_unidades      NUMBER(3),
    n_precioud      NUMBER(6,2),
    d_fechaalta     DATE,
    d_fechavenc     DATE,
    v_localidad     VARCHAR2(20 CHAR)
);

INSERT INTO tb_productos
    VALUES (1, 'Destornillador', 40, 3.25, SYSDATE, TO_DATE('25/10/2021', 'DD/MM/YYYY'), 'Burgos');
INSERT INTO tb_productos 
    VALUES (2, 'Martillo', 10, 34.75, SYSDATE, TO_DATE('15/09/2021', 'DD/MM/YYYY'), 'Madrid');
INSERT INTO tb_productos 
    VALUES (3, 'Clavo', 300, 0.45, SYSDATE, TO_DATE('29/08/2021', 'DD/MM/YYYY'), 'Las Palmas');

-- Añade el campo activo y porcentaje para conocer si el producto ha vencido o si ha aumentado el precio o disminuido
ALTER TABLE tb_productos
ADD (b_activo     VARCHAR2(20 CHAR),
     n_porcentaje NUMBER(10,2));
     
-- Package 
CREATE OR REPLACE PACKAGE pk_gestion_ferreteria IS
    PROCEDURE pr_generar_fichero_productos (pi_v_cadena IN VARCHAR2, po_v_error OUT VARCHAR2);
    PROCEDURE pr_actualizar_precios_proveedor;
    PROCEDURE pr_borrar_productos_vencidos;
    PROCEDURE pr_list_products;
END pk_gestion_ferreteria;

-- Hay que declarar las funciones y procedimientos que se usen en el paquete en el bloque superior
CREATE OR REPLACE PACKAGE BODY pk_gestion_ferreteria IS

    -- Procedimiento que genera los productos registrados en una cadena
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
    
    -- Procedimiento para actualizar los precios
    PROCEDURE pr_actualizar_precios_proveedor
    IS  
        vn_idproducto   TB_PRODUCTOS.N_IDPRODUCTO%TYPE; --Variable para guardar el ID del producto
        vn_precioud     TB_PRODUCTOS.N_PRECIOUD%TYPE;   --Variable para guardar el antiguo precio
        vn_nuevoprecio  TB_PRODUCTOS.N_PRECIOUD%TYPE;
        vn_porcentaje   TB_PRODUCTOS.N_PORCENTAJE%TYPE; --Variable para guardar el porcentaje
        
    BEGIN
        SELECT MAX(n_idproducto) - 1
                INTO vn_idproducto    
                FROM tb_productos;
                
        BEGIN
            SELECT n_precioud --Consulta para introducir el precio antiguo en su variable (vn_precioud)
             INTO vn_precioud
             FROM tb_productos
             WHERE n_idproducto = vn_idproducto;
        END;
        BEGIN
            vn_nuevoprecio := 1.05 * vn_precioud;
            vn_porcentaje := (vn_nuevoprecio/vn_precioud)*100; --Cálculo del porcentaje entre precios nuevo y antiguo
        END;
        
        BEGIN
            UPDATE tb_productos t --Consulta de actualización del precio nuevo donde estaba el antiguo
             SET t.n_precioud = vn_nuevoprecio
            WHERE t.n_idproducto = vn_idproducto;
        END;
        
        BEGIN
            UPDATE tb_productos --Consulta de actualización del porcentaje en su fila correspondiente
                SET n_porcentaje = vn_porcentaje
                WHERE n_idproducto = vn_idproducto;
        END;
            
    END pr_actualizar_precios_proveedor;
    
    PROCEDURE pr_borrar_productos_vencidos
    IS  
    BEGIN
        DELETE
         FROM tb_productos t
         WHERE t.n_idproducto = (SELECT st.n_idproducto --Selecciona el ID del producto a borrar
                                 FROM tb_productos st
                                 WHERE st.b_activo = 'FALSE');
    
    END pr_borrar_productos_vencidos;
    
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


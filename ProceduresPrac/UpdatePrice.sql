-- Procedimiento que actualiza si los productos están vencidos o no
CREATE OR REPLACE PROCEDURE pr_actualizar_estado

IS
    
BEGIN
    UPDATE tb_productos t
    SET t.b_activo = 
        (SELECT
            CASE WHEN SYSDATE > st.d_fechavenc THEN 'FALSE' ELSE 'TRUE' END -- Devuelve TRUE si el producto sigue activo y FALSE si está vencido
            FROM tb_productos st
            WHERE st.n_idproducto = t.n_idproducto);

END pr_actualizar_estado;
/

-- Llamamos al procedimiento
BEGIN
    pr_actualizar_estado;
END;
/

-- Procedimiento para actualizar los precios
CREATE OR REPLACE PROCEDURE pr_actualizar_precios_proveedor (pi_n_idproducto           IN         TB_PRODUCTOS.N_IDPRODUCTO%TYPE, --Se introduce el ID del producto
                                                             pio_n_precioud            IN OUT     TB_PRODUCTOS.N_PRECIOUD%TYPE,   --Se introduce el nuevo precio
                                                             po_n_porcentajecambio     OUT        TB_PRODUCTOS.N_PORCENTAJE%TYPE) --Sale el porcentaje 
                                                                                                                                  --(nuevo precio/antiguo precio)
IS  
    vn_idproducto   TB_PRODUCTOS.N_IDPRODUCTO%TYPE; --Variable para guardar el ID del producto
    vn_precioud     TB_PRODUCTOS.N_PRECIOUD%TYPE;   --Variable para guardar el antiguo precio
    vn_porcentaje   TB_PRODUCTOS.N_PORCENTAJE%TYPE; --Variable para guardar el porcentaje
    ex_sinid        EXCEPTION; --Excepción si no se introduce ID del producto
    ex_sinprecio    EXCEPTION; --Excepción si no se introduce el precio nuevo que actualiza el antiguo
    
BEGIN
    vn_idproducto  := NVL(pi_n_idproducto, -1); --Si no se introduce ID se pone -1
    pio_n_precioud := NVL(pio_n_precioud, -1); --Si no se introduce precio nuevo se pone -1
    
    IF pio_n_precioud = -1 THEN
        RAISE ex_sinprecio; --Se lanza el error si no hay ID (ID = -1)
    ELSIF vn_idproducto = -1 THEN
        RAISE ex_sinid; --Se lanza el error si no hay precio nuevo (precio = -1)
    END IF;
    
    BEGIN
        SELECT n_precioud --Consulta para introducir el precio antiguo en su variable (vn_precioud)
         INTO vn_precioud
         FROM tb_productos
         WHERE n_idproducto = vn_idproducto;
    END;
    BEGIN
        vn_porcentaje := (pio_n_precioud/vn_precioud)*100; --Cálculo del porcentaje entre precios nuevo y antiguo
    END;
    
    BEGIN
        UPDATE tb_productos t --Consulta de actualización del precio nuevo donde estaba el antiguo
         SET t.n_precioud = 
                        (SELECT
                        CASE
                            WHEN st.b_activo = 'FALSE' THEN st.n_precioud --Si el producto está vencido, no sustituye el precio nuevo
                            WHEN st.b_activo = 'TRUE'  THEN pio_n_precioud --Si el producto está activo, si sustituye el precio nuevo
                            END
                        FROM tb_productos st
                        WHERE st.n_idproducto = vn_idproducto)
        WHERE t.n_idproducto = vn_idproducto;
    END;
    
    BEGIN
        UPDATE tb_productos --Consulta de actualización del porcentaje en su fila correspondiente
            SET n_porcentaje = vn_porcentaje
            WHERE n_idproducto = vn_idproducto;
    END;
    
EXCEPTION
    WHEN ex_sinprecio THEN
        DBMS_OUTPUT.PUT_LINE('No se introdujo nuevo precio.'); --Error si no hay precio nuevo
    WHEN ex_sinid THEN
        DBMS_OUTPUT.PUT_LINE('No se introdujo ID.'); --Error si no se introdujo ID
        
END pr_actualizar_precios_proveedor;
/
-- Llamamos al procedimiento
DECLARE
    vn_id           NUMBER := 1; --Introducimos el ID del producto del que queremos sustituir el precio
    vn_porcentaje   NUMBER; --Variable de salida del porcentaje
    vn_precioud     NUMBER := 4.5; --Introducimos el nuevo precio
BEGIN
    pr_actualizar_precios_proveedor(vn_id, vn_precioud, vn_porcentaje);
END;

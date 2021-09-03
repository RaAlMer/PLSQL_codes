-- Procedimiento para disminuir unidades (por venta)
CREATE OR REPLACE PROCEDURE pr_vender_productos (pi_n_idproducto           IN         TB_PRODUCTOS.N_IDPRODUCTO%TYPE, --Parámetro de entrada - ID del producto
                                                 pio_n_unidades            IN OUT     TB_PRODUCTOS.N_PRECIOUD%TYPE) --Parámetro de entrada y salida - Unidades a restar al producto
IS  
    vn_idproducto   TB_PRODUCTOS.N_IDPRODUCTO%TYPE; --Variable para alamacenar el ID del producto
    vn_unidades     TB_PRODUCTOS.N_UNIDADES%TYPE; --Variable para almacenar el número de unidades antiguas
    ex_sinid        EXCEPTION; --Excepción si no se introduce ID del producto
    ex_sinud        EXCEPTION; --Excepción si no se introducen las unidades del producto
    ex_udneg        EXCEPTION; --Excepción si se venden más unidades de producto de las que hay en el almacén
    
BEGIN
    vn_idproducto  := NVL(pi_n_idproducto, -1); --Si no se introduce ID se pone -1
    pio_n_unidades := NVL(pio_n_unidades, -1); --Si no se introducen unidades se pone -1
    
    IF pio_n_unidades = -1 THEN
        RAISE ex_sinud; --Lanza el error si no hay unidades
    ELSIF vn_idproducto = -1 THEN
        RAISE ex_sinid; --Lanza el error si no hay ID
    END IF;
    
    BEGIN
        SELECT n_unidades --Consulta para introducir el número de unidades antiguo en su variable (vn_precioud)
         INTO vn_unidades
         FROM tb_productos
         WHERE n_idproducto = vn_idproducto;
    END;
    
    IF pio_n_unidades > vn_unidades THEN
        RAISE ex_udneg; --Lanza el error si se venden más unidades de las que hay
    END IF;
    
    BEGIN
        vn_unidades := vn_unidades - pio_n_unidades; --Actualizamos el valor de las unidades restando las introducidas como parámetro
    END;
    
    BEGIN --Bloque para actualizar el valor de las unidades del producto en la tabla
        UPDATE tb_productos t 
         SET t.n_unidades = vn_unidades
         WHERE t.n_idproducto = vn_idproducto;
    END;
    
EXCEPTION
    WHEN ex_sinud THEN
        DBMS_OUTPUT.PUT_LINE('No se introdujeron unidades.'); --Error si no hay unidades del producto
    WHEN ex_sinid THEN
        DBMS_OUTPUT.PUT_LINE('No se introdujo ID.'); --Error si no se introdujo ID
    WHEN ex_udneg THEN
        DBMS_OUTPUT.PUT_LINE('¡No hay tantas unidades para vender!'); --Error si se venden más unidades de las que hay disponibles
        
END pr_vender_productos;

-- Llamamos al procedimiento para disminuir el número de unidades de un producto (venta)
DECLARE
    vn_id           NUMBER := 1; --Introducimos el ID del producto del que queremos vender unidades
    vn_unidades     NUMBER := 250; --Introducimos el número de unidades a vender
BEGIN
    pr_vender_productos (vn_id, vn_unidades);
END;

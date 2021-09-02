-- Procedimiento para aumentar unidades (por compra)
CREATE OR REPLACE PROCEDURE pr_comprar_producto (pi_n_idproducto           IN         TB_PRODUCTOS.N_IDPRODUCTO%TYPE,
                                                 pio_n_unidades            IN OUT     TB_PRODUCTOS.N_PRECIOUD%TYPE) 
IS  
    vn_idproducto   TB_PRODUCTOS.N_IDPRODUCTO%TYPE; --Variable para guardar el ID del producto
    ex_sinid        EXCEPTION; --Excepción si no se introduce ID del producto
    ex_sinud        EXCEPTION; 
    
BEGIN
    vn_idproducto  := NVL(pi_n_idproducto, -1); --Si no se introduce ID se pone -1
    pio_n_unidades := NVL(pio_n_unidades, -1); --Si no se introduce precio nuevo se pone -1
    
    IF pio_n_unidades = -1 THEN
        RAISE ex_sinud;
    ELSIF vn_idproducto = -1 THEN
        RAISE ex_sinid;
    END IF;
    
    BEGIN
        UPDATE tb_productos t
         SET t.n_unidades = pio_n_unidades
         WHERE t.n_idproducto = vn_idproducto;
    END;
    
EXCEPTION
    WHEN ex_sinud THEN
        DBMS_OUTPUT.PUT_LINE('No se introdujeron unidades.'); --Error si no hay unidades del producto
    WHEN ex_sinid THEN
        DBMS_OUTPUT.PUT_LINE('No se introdujo ID.'); --Error si no se introdujo ID
        
END pr_comprar_producto;
/


DECLARE
    vn_id           NUMBER := 1; --Introducimos el ID del producto del que queremos sustituir el precio
    vn_unidades     NUMBER := 20; --Introducimos el nuevo precio
BEGIN
    pr_comprar_producto (vn_id, vn_unidades);
END;

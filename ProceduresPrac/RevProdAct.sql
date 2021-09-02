-- Procedimiento que actualiza si los productos están vencidos o no
CREATE OR REPLACE PROCEDURE pr_revisar_productos_activos
IS  
BEGIN
    UPDATE tb_productos t
    SET t.b_activo = 
        (SELECT
            CASE WHEN SYSDATE > st.d_fechavenc THEN 'FALSE' ELSE 'TRUE' END -- Devuelve TRUE si el producto sigue activo y FALSE si está vencido
            FROM tb_productos st
            WHERE st.n_idproducto = t.n_idproducto);

END pr_revisar_productos_activos;
/

-- Llamamos al procedimiento
BEGIN
    pr_revisar_productos_activos;
END;
/

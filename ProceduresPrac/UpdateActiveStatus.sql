-- Procedure to update the active status in the product's table to know if a product has expired
CREATE OR REPLACE PROCEDURE pr_actualizar_estado
IS
BEGIN
    UPDATE tb_productos t
    SET t.b_activo = 
        (SELECT
            CASE WHEN SYSDATE > st.d_fechavenc THEN 'FALSE' ELSE 'TRUE' END -- Returns TRUE if the product is active (not expired) and FALSE if it has expired
            FROM tb_productos st
            WHERE st.n_idproducto = t.n_idproducto);

END pr_actualizar_estado;
/

-- Calling the procedure
BEGIN
    pr_actualizar_estado;
END;
/

--Procedimiento para borrar productos que estén vencidos (FALSE) y sin unidades (0)
CREATE OR REPLACE PROCEDURE pr_borrar_productos_vencidos
IS  
BEGIN
    DELETE
     FROM tb_productos t
     WHERE t.n_idproducto = (SELECT st.n_idproducto --Selecciona el ID del producto a borrar
                             FROM tb_productos st
                             WHERE st.n_unidades = 0 --Filtra por la condición de que el producto no tenga unidades y esté vencido
                              AND st.b_activo = 'FALSE');

END pr_borrar_productos_vencidos;
/
--Llamamos al procedimiento
BEGIN
  pr_borrar_productos_vencidos;
END;
/

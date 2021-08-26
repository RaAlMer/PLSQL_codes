UPDATE tbproductos t
SET t.bactivo = 
    (SELECT
        CASE WHEN SYSDATE > st.dfechavenc THEN 'FALSE' ELSE 'TRUE' END
        FROM tbproductos st
        WHERE st.nidproducto = t.nidproducto);

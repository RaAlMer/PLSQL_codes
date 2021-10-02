ALTER TABLE tb_productos
ADD (v_desproveedor VARCHAR2(50 CHAR));

UPDATE tb_productos
SET v_desproveedor = 'Ferretería los Franceses'
WHERE n_idproducto = 1;
UPDATE tb_productos
SET v_desproveedor = 'Ferretería los Franceses'
WHERE n_idproducto = 2;
UPDATE tb_productos
SET v_desproveedor = 'Martillos los Juncos'
WHERE n_idproducto = 3;

INSERT INTO tb_productos
    VALUES (4, 'Destornillador', 40, 3.25, SYSDATE, TO_DATE('25/12/2021', 'DD/MM/YYYY'), 'Burgos', 'TRUE', NULL, 'Ferretería los Franceses');
INSERT INTO tb_productos 
    VALUES (5, 'Martillo', 10, 34.75, SYSDATE, TO_DATE('15/01/2022', 'DD/MM/YYYY'), 'Madrid', 'TRUE', NULL, 'Ferretería los Franceses');
INSERT INTO tb_productos 
    VALUES (6, 'Destornillador', 300, 0.45, SYSDATE, TO_DATE('29/12/2021', 'DD/MM/YYYY'), 'Vitoria', 'TRUE', NULL, 'Martillos los Juncos');
    
CREATE OR REPLACE PROCEDURE pr_lista_productos
IS

    TYPE ttab_ty_nombre IS TABLE OF TB_PRODUCTOS%ROWTYPE; -- Collection of records
	  vttab_ty_nombre ttab_ty_nombre;

BEGIN

    SELECT *
    BULK COLLECT INTO vttab_ty_nombre
    FROM tb_productos
    WHERE v_desproveedor IS NOT NULL
    ORDER BY v_desproveedor, v_desproducto;

    IF vttab_ty_nombre.COUNT > 0 THEN
        FOR i IN vttab_ty_nombre.FIRST .. vttab_ty_nombre.LAST LOOP
            DBMS_OUTPUT.PUT_LINE('El producto es: ' || vttab_ty_nombre(i).v_desproducto || ' que pertene a ' || vttab_ty_nombre(i).v_desproveedor);
	        DBMS_OUTPUT.PUT_LINE('--------------------------------------------');
	      END LOOP;
	  END IF;
END pr_lista_productos;
/

BEGIN
    pr_lista_productos;
END;
/

-- Adding a column to the products' table regarding to the suppliers' name
ALTER TABLE tb_productos
ADD (v_desproveedor VARCHAR2(50 CHAR));
-- Updating the old rows adding its supplier
UPDATE tb_productos
SET v_desproveedor = 'Ferretería los Franceses'
WHERE n_idproducto = 1;
UPDATE tb_productos
SET v_desproveedor = 'Ferretería los Franceses'
WHERE n_idproducto = 2;
UPDATE tb_productos
SET v_desproveedor = 'Martillos los Juncos'
WHERE n_idproducto = 3;
-- Inserting new rows into the products' table
INSERT INTO tb_productos
    VALUES (4, 'Destornillador', 40, 3.25, SYSDATE, TO_DATE('25/12/2021', 'DD/MM/YYYY'), 'Burgos', 'TRUE', NULL, 'Ferretería los Franceses');
INSERT INTO tb_productos 
    VALUES (5, 'Martillo', 10, 34.75, SYSDATE, TO_DATE('15/01/2022', 'DD/MM/YYYY'), 'Madrid', 'TRUE', NULL, 'Ferretería los Franceses');
INSERT INTO tb_productos 
    VALUES (6, 'Destornillador', 300, 0.45, SYSDATE, TO_DATE('29/12/2021', 'DD/MM/YYYY'), 'Vitoria', 'TRUE', NULL, 'Martillos los Juncos');
    
-- Option A, Procedure with a record and collection created using %ROWTYPE
CREATE OR REPLACE PROCEDURE pr_lista_productos --It lists the products that have a known supplier
IS

    TYPE ttab_ty_nombre IS TABLE OF TB_PRODUCTOS%ROWTYPE; -- Collection of records
    vttab_ty_nombre ttab_ty_nombre;

BEGIN

    SELECT * --Query to insert the rows from the products' table into the collection
    BULK COLLECT INTO vttab_ty_nombre
    FROM tb_productos
    WHERE v_desproveedor IS NOT NULL
    ORDER BY v_desproveedor, v_desproducto;

    IF vttab_ty_nombre.COUNT > 0 THEN
        FOR i IN vttab_ty_nombre.FIRST .. vttab_ty_nombre.LAST LOOP
            DBMS_OUTPUT.PUT_LINE('The product is: ' || vttab_ty_nombre(i).v_desproducto || ' which belongs to ' || vttab_ty_nombre(i).v_desproveedor);
	        DBMS_OUTPUT.PUT_LINE('--------------------------------------------');
	      END LOOP;
	  END IF;
END pr_lista_productos;
/

---------------------------------------------------------------------
-- Option B, Procedure with a record and collection created using RECORD
CREATE OR REPLACE PROCEDURE pr_lista_productos --It lists the products that have a known supplier
IS
    
    TYPE t_registro IS RECORD( --Record created to have the names of both the product and supplier
        v_desproducto  VARCHAR2(20 CHAR), -- Name of the product
        v_desproveedor VARCHAR2(50 CHAR)); -- Name of the supplier
    
    TYPE ttab_ty_nombre IS TABLE OF t_registro; -- Collection of records
	vttab_ty_nombre ttab_ty_nombre;

BEGIN

    SELECT v_desproducto, v_desproveedor --Query to insert the names of the product and supplier into the collection
    BULK COLLECT INTO vttab_ty_nombre
    FROM tb_productos
    WHERE v_desproveedor IS NOT NULL --Only if the supplier is known
    ORDER BY v_desproveedor, v_desproducto;

    IF vttab_ty_nombre.COUNT > 0 THEN --If the collection has at least one value
        FOR i IN vttab_ty_nombre.FIRST .. vttab_ty_nombre.LAST LOOP --Loop through the records inside the collection
            DBMS_OUTPUT.PUT_LINE('The product is: ' || vttab_ty_nombre(i).v_desproducto || ' which belongs to ' || vttab_ty_nombre(i).v_desproveedor);
	        DBMS_OUTPUT.PUT_LINE('--------------------------------------------');
	    END LOOP;
	END IF;
END pr_lista_productos;
/

--Calling the procedure
BEGIN
    pr_lista_productos;
END;
/

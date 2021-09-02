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
     n_porcentaje NUMBER(4,2));

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

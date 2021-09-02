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
     n_porcentaje NUMBER(10,2));

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
CREATE OR REPLACE PROCEDURE pr_actualizar_precios_proveedor (pi_n_idproducto           IN         TB_PRODUCTOS.N_IDPRODUCTO%TYPE,
                                                             pio_n_precioud            IN OUT     TB_PRODUCTOS.N_PRECIOUD%TYPE,
                                                             po_n_porcentajecambio     OUT        TB_PRODUCTOS.N_PORCENTAJE%TYPE)
IS  
    vn_idproducto   TB_PRODUCTOS.N_IDPRODUCTO%TYPE;
    vn_porcentaje   TB_PRODUCTOS.N_PORCENTAJE%TYPE;
    vn_precioud     TB_PRODUCTOS.N_PRECIOUD%TYPE;
    ex_sinid        EXCEPTION;
    ex_sinprecio    EXCEPTION;
    
BEGIN
    vn_idproducto  := NVL(pi_n_idproducto, -1);
    pio_n_precioud := NVL(pio_n_precioud, -1);
    
    IF pio_n_precioud = -1 THEN
        RAISE ex_sinprecio;
    ELSIF vn_idproducto = -1 THEN
        RAISE ex_sinid;
    END IF;
    
    BEGIN
        SELECT n_precioud
         INTO vn_precioud
         FROM tb_productos
         WHERE n_idproducto = vn_idproducto;
    END;
    BEGIN
        vn_porcentaje := (pio_n_precioud/vn_precioud)*100;
    END;
    
    BEGIN
        UPDATE tb_productos t
         SET t.n_precioud = 
                        (SELECT
                        CASE
                            WHEN st.b_activo = 'FALSE' THEN st.n_precioud
                            WHEN st.b_activo = 'TRUE'  THEN pio_n_precioud
                            END
                        FROM tb_productos st
                        WHERE st.n_idproducto = vn_idproducto);
    END;
    
    BEGIN
        UPDATE tb_productos
            SET n_porcentaje = vn_porcentaje
            WHERE n_idproducto = vn_idproducto;
    END;
    
EXCEPTION
    WHEN ex_sinprecio THEN
        DBMS_OUTPUT.PUT_LINE('No se introdujo nuevo precio.');
    WHEN ex_sinid THEN
        DBMS_OUTPUT.PUT_LINE('No se introdujo ID.');
        
END pr_actualizar_precios_proveedor;
/
-- Llamamos al procedimiento
DECLARE
    vn_id           NUMBER := 1;
    vn_porcentaje   NUMBER;
    vn_precioud     NUMBER := 4.5;
BEGIN
    pr_actualizar_precios_proveedor(vn_id, vn_precioud, vn_porcentaje);
END;

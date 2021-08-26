CREATE TABLE tbproductos (
                        nidproducto NUMBER(2) NOT NULL,
                        vdesproducto VARCHAR2(20 CHAR),
                        nunidades NUMBER(3),
                        npreciounitario NUMBER(6,2),
                        dfechaalta DATE,
                        dfechavenc DATE);

INSERT INTO tbproductos (nidproducto,vdesproducto,nunidades,npreciounitario,dfechaalta,dfechavenc) 
  VALUES (1,'Hammer',50,3.25,TO_DATE('13-MAY-2021','DD-MON-YYYY'),TO_DATE('20-AUG-2021','DD-MON-YYYY'));
INSERT INTO tbproductos (nidproducto,vdesproducto,nunidades,npreciounitario,dfechaalta,dfechavenc) 
  VALUES (2,'Nails',100,1.34,TO_DATE('08-JUN-2021','DD-MON-YYYY'),TO_DATE('10-OCT-2021','DD-MON-YYYY'));  
INSERT INTO tbproductos (nidproducto,vdesproducto,nunidades,npreciounitario,dfechaalta,dfechavenc) 
  VALUES (3,'Screws',250,0.16,TO_DATE('21-JUL-2021','DD-MON-YYYY'),TO_DATE('03-JUL-2021','DD-MON-YYYY'));  
  
ALTER TABLE tbproductos
    ADD bactivo VARCHAR2(20 CHAR)
    ;

--- Imprime en pantalla si está vencido el producto o no
DECLARE 
    
    bAlta VARCHAR2 (20 CHAR);
    
BEGIN
    
    SELECT(
            CASE WHEN SYSDATE > dfechavenc THEN 'FALSE' ELSE 'TRUE' END
            )
    INTO bAlta
    FROM tbproductos t
    WHERE t.nidproducto = 1
   ;
    
    DBMS_OUTPUT.PUT_LINE('El producto esta vencido: ' || bAlta);
    
END;
/

--- Actualiza el valor de la columna de si los productos están vencidos o no

UPDATE tbproductos t
SET t.bactivo = 
    (SELECT
        CASE WHEN SYSDATE > st.dfechavenc THEN 'FALSE' ELSE 'TRUE' END
        FROM tbproductos st
        WHERE st.nidproducto = t.nidproducto);

--- Actualiza el precio de los productos cuyo campo bactive sea TRUE
UPDATE tbproductos t
SET t.npreciounitario = 
                    (SELECT
                    CASE
                        WHEN st.bactivo = 'FALSE' THEN st.npreciounitario 
                        WHEN st.bactivo = 'TRUE'  THEN st.npreciounitario*1.1
                        END
                    FROM tbproductos st
                    WHERE st.nidproducto = t.nidproducto);

BEGIN
  CREATE TABLE tbproductos (
                          nidproducto NUMBER(2) NOT NULL,
                          vdesproducto VARCHAR2(20 CHAR),
                          nunidades NUMBER(3),
                          npreciounitario NUMBER(6,2),
                          dfechaalta DATE,
                          dfechavenc DATE);
END;
/

BEGIN
  INSERT INTO tbproductos (nidproducto,vdesproducto,nunidades,npreciounitario,dfechaalta,dfechavenc) 
    VALUES (1,'Hammer',50,3.25,TO_DATE('13-MAY-2021','DD-MON-YYYY'),TO_DATE('20-AUG-2021','DD-MON-YYYY'));
  INSERT INTO tbproductos (nidproducto,vdesproducto,nunidades,npreciounitario,dfechaalta,dfechavenc) 
    VALUES (2,'Nails',100,1.34,TO_DATE('08-JUN-2021','DD-MON-YYYY'),TO_DATE('10-OCT-2021','DD-MON-YYYY'));  
  INSERT INTO tbproductos (nidproducto,vdesproducto,nunidades,npreciounitario,dfechaalta,dfechavenc) 
    VALUES (3,'Screws',250,0.16,TO_DATE('21-JUL-2021','DD-MON-YYYY'),TO_DATE('03-JUL-2021','DD-MON-YYYY'));  
END
/

DECLARE

    CURSOR c_producto IS
        SELECT *
            FROM tbproductos;

BEGIN

  FOR r_producto IN c_producto LOOP
    IF SYSDATE > r_producto.dfechavenc THEN
        dbms_output.put_line('Producto '||r_producto.vdesproducto ||' con su estado: FALSE');
    ELSE
        dbms_output.put_line('Producto '||r_producto.vdesproducto ||' con su estado: TRUE');
    END IF;
    IF r_producto.dfechavenc < SYSDATE THEN
      dbms_output.put_line('Producto '||r_producto.vdesproducto ||' ha caducado !');
    END IF;
  END LOOP;

END;
/

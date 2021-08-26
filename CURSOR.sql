BEGIN
  CREATE TABLE tbproducts (
                          nidproduct NUMBER(2) NOT NULL,
                          vdescription VARCHAR2(20 CHAR),
                          nquantity NUMBER(3),
                          nprice NUMBER(6,2),
                          dlastdate DATE);
END;
/

BEGIN
  INSERT INTO tbproducts (nidproduct,vdescription,nquantity,nprice,dlastdate) VALUES (1,'Hammer', 50,3.25,TO_DATE('13-MAY-2021','DD-MON-YYYY'));
  INSERT INTO tbproducts (nidproduct,vdescription,nquantity,nprice,dlastdate) VALUES (2, 'Nails',100,0.75,TO_DATE('28-AUG-2021','DD-MON-YYYY'));
  INSERT INTO tbproducts (nidproduct,vdescription,nquantity,nprice,dlastdate) VALUES (3,'Screws',250,0.16,TO_DATE('21-JUL-2021','DD-MON-YYYY'));  
END
/

DECLARE

    CURSOR c_producto IS
        SELECT *
            FROM tbproductos;

BEGIN

  FOR r IN c_producto LOOP
    IF SYSDATE > r.dfechavenc THEN
        dbms_output.put_line('Producto '||r.vdesproducto ||' con su estado: FALSE');
    ELSE
        dbms_output.put_line('Producto '||r.vdesproducto ||' con su estado: TRUE');
    END IF;
    IF r.dfechavenc < SYSDATE THEN
      dbms_output.put_line('Producto '||r.vdesproducto ||' ha caducado !');
    END IF;
  END LOOP;

END;
/

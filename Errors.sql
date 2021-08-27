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
  
CREATE TABLE tbLog2(
                    n_ercode NUMBER(10),
                    v_erdesc VARCHAR2(1024 CHAR)
                    );

DECLARE 
     
    v_mi_variable   TBPRODUCTOS%ROWTYPE; 
    v_mi_idvar      TBPRODUCTOS.NIDPRODUCTO%TYPE; 
    ex_mi_error     EXCEPTION;
    v_code NUMBER;
    v_errm VARCHAR2(1024);
     
BEGIN 
 
    BEGIN 
        INSERT INTO tbproductos(nidproducto, vdesproducto, nunidades) 
            VALUES (1, 'Martillo de guerra', 20000) 
            ; 
    EXCEPTION 
        WHEN OTHERS THEN
            v_code := SQLCODE;
            v_errm := SUBSTR(SQLERRM, 1);
            INSERT INTO tbLog2(n_ercode, v_erdesc)
                VALUES(v_code, v_errm)
                ;
            DBMS_OUTPUT.PUT_LINE('Valor más grande del especificado para esa variable');
            
    END; 
     
    BEGIN 
        SELECT * 
            INTO v_mi_variable 
            FROM tbproductos 
            ; 
    EXCEPTION 
        WHEN TOO_MANY_ROWS THEN 
            DBMS_OUTPUT.PUT_LINE('El comando SELECT INTO devuelve demasiadas filas'); 
    END; 
     
END;

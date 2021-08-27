--- Tabla donde están los productos
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
  
--- Tabla donde guardar los errores
CREATE TABLE tbLog(
                    n_ercode NUMBER(10), --Código del error
                    v_erdesc VARCHAR2(1024 CHAR) --Descripción del error
                    );
                    
ALTER TABLE tbLog
  ADD(
      n_line NUMBER(4), --Línea donde ocurre el error
      v_unit VARCHAR2(1024 CHAR) --Bloque o unidad donde ocurre el error
      );

DECLARE 
     
    v_mi_variable   TBPRODUCTOS%ROWTYPE; 
    v_mi_idvar      TBPRODUCTOS.NIDPRODUCTO%TYPE; 
    ex_mi_error     EXCEPTION;
    v_code NUMBER; --Variable donde se guarda el código del error
    v_errm VARCHAR2(1024); --Variable donde se guarda el mensaje del error
     
BEGIN 
 
    BEGIN 
        INSERT INTO tbproductos(nidproducto, vdesproducto, nunidades) 
            VALUES (1, 'Martillo de guerra', 20000) 
            ; 
    EXCEPTION 
        WHEN OTHERS THEN
            v_code := SQLCODE;
            v_errm := SUBSTR(SQLERRM, 1);
            INSERT INTO tbLog(n_ercode, v_erdesc, n_line, v_unit)
                VALUES(v_code, v_errm, $$plsql_line, $$plsql_unit) --$$plsql_line devuelve la línea donde ocurre el error y $$plsql_unit el bloque o unidad
                ;
            DBMS_OUTPUT.PUT_LINE('Valor más grande del especificado para esa variable'); --Mensaje alternativo a mostrar cuando ocurre el error
            
    END; 
     
    BEGIN 
        SELECT * 
            INTO v_mi_variable 
            FROM tbproductos 
            ; 
    EXCEPTION 
        WHEN TOO_MANY_ROWS THEN 
            v_code := SQLCODE;
            v_errm := SUBSTR(SQLERRM, 1);
            INSERT INTO tbLog(n_ercode, v_erdesc, n_line, v_unit)
                VALUES(v_code, v_errm, $$plsql_line, $$plsql_unit)
                ;
            DBMS_OUTPUT.PUT_LINE('El comando SELECT INTO devuelve demasiadas filas'); 
    END; 
     
END;

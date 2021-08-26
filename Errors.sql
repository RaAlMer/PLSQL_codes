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

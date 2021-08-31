-- Tabla de errores
CREATE TABLE error_log
(
  id              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  title           VARCHAR2 (200 CHAR),
  info            CLOB,
  created_on      DATE DEFAULT SYSDATE,
  created_by      VARCHAR2 (100 CHAR),
  callstack       CLOB,
  errorstack      CLOB,
  errorbacktrace  CLOB
 )
 /
 
 -- Procedimiento para manejar el error
 CREATE OR REPLACE PROCEDURE pr_log_error (title_in    IN error_log.title%TYPE,
                                           info_in     IN error_log.info%TYPE)
  
  AUTHID DEFINER
IS
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  INSERT INTO error_log (title,
                         info,
                         created_by,
                         callstack,
                         errorstack,
                         errorbacktrace)
  VALUES (title_in,
          info_in,
          USER,
          DBMS_UTILITY.format_call_stack,
          DBMS_UTILITY.format_error_stack,
          DBMS_UTILITY.format_error_backtrace);
 COMMIT;
END;
/

-- Mi procedimiento para probar
CREATE OR REPLACE PROCEDURE pr_my_procedure (value_in IN INTEGER)
  AUTHID DEFINER
IS
  l_local_variable  DATE;
BEGIN
  l_local_variable :=
    CASE WHEN value_in > 100 THEN SYSDATE - 10 ELSE SYSDATE + 10 END;
    
    UPDATE employees
      SET salary = value_in;
      
    RAISE PROGRAM_ERROR;
EXCEPTION
  WHEN OTHERS
  THEN
    pr_log_error (
      'my_procedure failed',
        'value_in = '
       || value_in
       || 'l_local_variable = '
       || TO_CHAR (l_local_variable, 'DD/MM/YYYY HH24:MI:SS'));
       
    RAISE;
END;
/

-- Un bloque anónimo para disparar los errores
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
            pr_log_error (
                'Mi error', --Título del error
                'Información del error' --Información en la tabla del error
            );
    END; 
     
    BEGIN 
        SELECT * 
            INTO v_mi_variable 
            FROM tbproductos 
            ; 
    EXCEPTION 
        WHEN OTHERS THEN
            pr_log_error (
                'Mi error', --Título del error
                'Información del error' --Información en la tabla del error
            );
       
            RAISE;
    END; 
     
END;

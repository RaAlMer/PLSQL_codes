-- Tabla de errores
CREATE TABLE tb_error_log
(
  vn_id              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  vv_title           VARCHAR2 (200 CHAR),
  vc_info            CLOB,
  vd_created_on      DATE DEFAULT SYSDATE,
  vv_created_by      VARCHAR2 (100 CHAR),
  vc_callstack       CLOB,
  vc_errorstack      CLOB,
  vc_errorbacktrace  CLOB
 )
 /
 
 -- Procedimiento para manejar el error
 CREATE OR REPLACE PROCEDURE pr_log_error (pi_title    IN tb_error_log.title%TYPE,
                                           pi_info     IN tb_error_log.info%TYPE)
  
  AUTHID DEFINER
IS
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  INSERT INTO tb_error_log (vv_title,
                            vc_info,
                            vd_created_by,
                            vc_callstack,
                            vc_errorstack,
                            vc_errorbacktrace)
  VALUES (pi_title,
          pi_info,
          USER,
          DBMS_UTILITY.format_call_stack,
          DBMS_UTILITY.format_error_stack,
          DBMS_UTILITY.format_error_backtrace);
 COMMIT;
END;
/

-- Mi procedimiento para probar
CREATE OR REPLACE PROCEDURE pr_my_procedure (pi_value IN INTEGER)
  AUTHID DEFINER
IS
  d_local_variable  DATE;
BEGIN
  d_local_variable :=
    CASE WHEN pi_value > 100 THEN SYSDATE - 10 ELSE SYSDATE + 10 END;
    
    UPDATE employees
      SET salary = pi_value;
      
    RAISE PROGRAM_ERROR;
EXCEPTION
  WHEN OTHERS
  THEN
    pr_log_error (
      'my_procedure failed',
        'pi_value = '
       || pi_value
       || 'd_local_variable = '
       || TO_CHAR (d_local_variable, 'DD/MM/YYYY HH24:MI:SS'));
       
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

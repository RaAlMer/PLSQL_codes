-- Procedimiento que carga una cadena como si fuera un producto
CREATE OR REPLACE PROCEDURE pr_cargar_fichero (pi_v_cadena    IN OUT    VARCHAR2) 
IS  
    vv_cadena      VARCHAR2(100 CHAR);
    ex_nocadena    EXCEPTION;
    
BEGIN
    vv_cadena := NVL(TRIM(' ' FROM REPLACE(pi_v_cadena, '%', '|')), 'No hay cadena introducida'); -- Quita los espacios que hubiera al principio y final de palabra
                                                                                                  -- Y sustituye los caracteres especiales % por separadores |
    
    IF vv_cadena = 'No hay cadena introducida' THEN -- Si no se introdujo cadena, se lanza un error
        RAISE ex_nocadena;
    END IF;
    
    dbms_output.put_line('La cadena escrita correctamente es: ' || vv_cadena || '.'); -- Imprime la cadena ya reemplazada
    
EXCEPTION
    WHEN ex_nocadena THEN
        DBMS_OUTPUT.PUT_LINE('No se introdujo ninguna cadena en el procedimiento.');
        
END pr_cargar_fichero;

-- Prueba de llamada al procedimiento
DECLARE
    vv_cadena  VARCHAR2(100 CHAR) := '  Destornillador %40%3.25%25/04/2021% %      '; -- La cadena del producto
BEGIN
    pr_cargar_fichero(vv_cadena);
END;
/

-- Procedimiento que genera los productos registrados en una cadena
CREATE OR REPLACE PROCEDURE pr_generar_fichero_productos (pi_v_cadena   IN  VARCHAR2) 
IS  
    vv_texto            VARCHAR2(100 CHAR);
    vv_producto         VARCHAR2(20 CHAR); 
    vn_unidades         NUMBER(3); 
    vn_precio           NUMBER(6,2); 
    vd_fecha_entrega    DATE; 
    vv_localildad       VARCHAR2(20 CHAR);
    
BEGIN
    vv_texto            := pi_v_cadena;
    vv_producto         := TRIM(' ' FROM SUBSTR(vv_texto, 1, INSTR(vv_texto, '|') -1)); 
    vn_unidades         := TO_NUMBER(SUBSTR(vv_texto, INSTR(vv_texto, '|', 1, 1) + 1, (INSTR(vv_texto, '|', 1, 2) - (INSTR(vv_texto, '|', 1, 1) +1)))); 
    vn_precio           := SUBSTR(vv_texto, INSTR(vv_texto, '|', 1, 2) + 1, (INSTR(vv_texto, '|', 1, 3) - (INSTR(vv_texto, '|', 1, 2) +1))); 
    vd_fecha_entrega    := TO_DATE(SUBSTR(vv_texto, INSTR(vv_texto, '|', 1, 3) + 1, (INSTR(vv_texto, '|', 1, 4) - (INSTR(vv_texto, '|', 1, 3) +1))), 'DD/MM/YYYY'); 
    vv_localildad       := NVL(TRIM(' ' FROM SUBSTR(vv_texto, INSTR(vv_texto, '|', 1, 4) + 1, (INSTR(vv_texto, '|', 1, 5) - (INSTR(vv_texto, '|', 1, 4) +1)))), 'Sin localidad');
    
    DBMS_OUTPUT.PUT_LINE('El producto es: ' || vv_producto); 
    DBMS_OUTPUT.PUT_LINE('El número de unidades recibidas es: ' || vn_unidades); 
    DBMS_OUTPUT.PUT_LINE('El precio unitario es: ' || vn_precio); 
    DBMS_OUTPUT.PUT_LINE('La fecha de entrega es: ' || TO_CHAR(vd_fecha_entrega, 'DD/MM/YYYY')); 
    DBMS_OUTPUT.PUT_LINE('La localidad es: ' || vv_localildad);
        
END pr_generar_fichero_productos;
/

-- Prueba de llamada al procedimiento
DECLARE
    vv_cadena  VARCHAR2(100 CHAR) := '  Destornillador |40|3.25|25/04/2021| |      '; -- La cadena del producto
BEGIN
    pr_generar_fichero_productos(vv_cadena);
END;

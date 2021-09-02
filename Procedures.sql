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

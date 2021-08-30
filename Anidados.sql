--------------------------------------------------------------------------------
-- Uso de bloques anidados
--------------------------------------------------------------------------------

DECLARE
    -- Lectura del fichero
    
    -- Variable utilizada para simular la linea de un fichero recibido 
    vv_texto    VARCHAR2(100 CHAR)  := 'Destornillador |40|3.25|25/04/2021| |'; 
    
    -- Variables de los campos recibidos en la linea 
    vv_producto         VARCHAR2(14 CHAR); 
    vn_unidades         NUMBER(2); 
    vn_precio           NUMBER(3,2); 
    vd_fecha_entrega    DATE; 
    vv_localildad       VARCHAR2(20 CHAR); -- Recibimos un valor nulo
BEGIN
    DECLARE
        -- Las variables declaradas con el mismo nombre dentro del bloque hijo sustituyen a las del bloque padre si luego todas las sentencias están dentro del bloque hijo
        -- En este caso, están dentro del BEGIN-END del bloque hijo
        -- No obstante, si luego las sentencias se encuentran dentro del bloque padre, la variable con el mismo nombre no será sustituida por la del bloque hijo
    
    BEGIN 
        -- Carga del fichero del proveedor
        
        vv_producto         := TRIM(' ' FROM SUBSTR(vv_texto, 1, INSTR(vv_texto, '|') -1)); 
        vn_unidades         := TO_NUMBER(SUBSTR(vv_texto, INSTR(vv_texto, '|', 1, 1) + 1, (INSTR(vv_texto, '|', 1, 2) - (INSTR(vv_texto, '|', 1, 1) +1)))); 
        vn_precio           := SUBSTR(vv_texto, INSTR(vv_texto, '|', 1, 2) + 1, (INSTR(vv_texto, '|', 1, 3) - (INSTR(vv_texto, '|', 1, 2) +1))); 
        vd_fecha_entrega    := TO_DATE(SUBSTR(vv_texto, INSTR(vv_texto, '|', 1, 3) + 1, (INSTR(vv_texto, '|', 1, 4) - (INSTR(vv_texto, '|', 1, 3) +1))), 'DD/MM/YYYY'); 
        vv_localildad       := NVL(TRIM(' ' FROM SUBSTR(vv_texto, INSTR(vv_texto, '|', 1, 4) + 1, (INSTR(vv_texto, '|', 1, 5) - (INSTR(vv_texto, '|', 1, 4) +1)))), 'Sin localidad');
         
    END;
    
    BEGIN
        -- Generación del fichero con formato
        
        DBMS_OUTPUT.PUT_LINE('El producto es: ' || vv_producto); 
        DBMS_OUTPUT.PUT_LINE('El número de unidades recibidas es: ' || vn_unidades); 
        DBMS_OUTPUT.PUT_LINE('El precio unitario es: ' || vn_precio); 
        DBMS_OUTPUT.PUT_LINE('La fecha de entrega es: ' || TO_CHAR(vd_fecha_entrega, 'DD/MM/YYYY')); 
        DBMS_OUTPUT.PUT_LINE('La localidad es: ' || vv_localildad); 
        DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------------------');
        DBMS_OUTPUT.PUT_LINE(RPAD(vv_producto, 20, ' ') ||
                                LPAD(vn_unidades, 5, ' ') ||
                                LPAD(vn_precio, 6, ' ') ||
                                RPAD(TO_CHAR(vd_fecha_entrega, 'DD/MM/YYYY'), 12, ' ') ||
                                RPAD(vv_localildad, 25, ' ') 
                            );
        DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------------------');
        DBMS_OUTPUT.PUT_LINE('La longitud del producto es ' || LENGTH(vv_producto) || ' pero en la linea su longitud es ' || LENGTH(RPAD(vv_producto, 20, ' '))); 
        DBMS_OUTPUT.PUT_LINE('La longitud del número de unidades es ' || LENGTH(vn_unidades) || ' pero en la linea su longitud es ' || LENGTH(LPAD(vn_unidades, 5, ' '))); 
        DBMS_OUTPUT.PUT_LINE('La longitud del precio unitario es ' || LENGTH(vn_precio) || ' pero en la linea su longitud es ' || LENGTH(LPAD(vn_precio, 6, ' '))); 
        DBMS_OUTPUT.PUT_LINE('La longitud de la fecha de entrega es ' || LENGTH(TO_CHAR(vd_fecha_entrega, 'DD/MM/YYYY')) || ' pero en la linea su longitud es ' || LENGTH(RPAD(TO_CHAR(vd_fecha_entrega, 'DD/MM/YYYY'), 12, ' '))); 
        DBMS_OUTPUT.PUT_LINE('La longitud de la localidad es ' || LENGTH(vv_localildad) || ' pero en la linea su longitud es ' || LENGTH(RPAD(vv_localildad, 25, ' '))); 
    
    END;
    
END;

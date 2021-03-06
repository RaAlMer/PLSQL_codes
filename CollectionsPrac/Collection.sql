-- VARRAY
DECLARE
    -- Creamos el tipo
    TYPE ttab_ty_nombre IS VARRAY(5) OF VARCHAR2(20 CHAR);
    -- Declaramos e inicializamos una variable del tipo creado
    vttab_ty_nombre ttab_ty_nombre := ttab_ty_nombre();
    
BEGIN
    
    DBMS_OUTPUT.PUT_LINE('El número máximo de registros en el vector es: ' || vttab_ty_nombre.LIMIT);
    DBMS_OUTPUT.PUT_LINE('El número de registros en el vector es: ' || vttab_ty_nombre.COUNT);
    
    FOR i IN 1 .. vttab_ty_nombre.LIMIT LOOP
        vttab_ty_nombre.EXTEND;
        vttab_ty_nombre(i) := 'Valor' || TO_CHAR(i);
    END LOOP;
    
    IF vttab_ty_nombre.COUNT > 0 THEN
        FOR i IN vttab_ty_nombre.FIRST .. vttab_ty_nombre.LAST LOOP
            DBMS_OUTPUT.PUT_LINE('El ID del registro es: ' || vttab_ty_nombre(i));
        END LOOP;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('El número de registros en el vector es: ' || vttab_ty_nombre.COUNT);
    
END;

DECLARE
    -- Creamos el tipo
    TYPE ttab_ty_nombre IS VARRAY(5) OF VARCHAR2(20 CHAR);
    -- Declaramos e inicializamos una variable del tipo creado
    vttab_ty_nombre ttab_ty_nombre := ttab_ty_nombre(5, 2, 4, 6, 7);
    
BEGIN
    
    DBMS_OUTPUT.PUT_LINE('El número máximo de registros en el vector es: ' || vttab_ty_nombre.LIMIT);
    DBMS_OUTPUT.PUT_LINE('El número de registros en el vector es: ' || vttab_ty_nombre.COUNT);
    
    IF vttab_ty_nombre.COUNT > 0 THEN
        FOR i IN vttab_ty_nombre.FIRST .. vttab_ty_nombre.LAST LOOP
            DBMS_OUTPUT.PUT_LINE('El ID del registro es: ' || vttab_ty_nombre(i));
        END LOOP;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('El número de registros en el vector es: ' || vttab_ty_nombre.COUNT);
    
END;

-- BLOQUES ANIDADOS
DECLARE
    -- Creamos el tipo
    TYPE ttab_ty_nombre IS TABLE OF VARCHAR2(20 CHAR);
    -- Declaramos e inicializamos una variable del tipo creado
    vttab_ty_nombre ttab_ty_nombre := ttab_ty_nombre(NULL, NULL, NULL);
    
BEGIN
    
    DBMS_OUTPUT.PUT_LINE('El número de registros en el vector es: ' || vttab_ty_nombre.COUNT);
    
    FOR i IN vttab_ty_nombre.FIRST .. vttab_ty_nombre.LAST LOOP
        vttab_ty_nombre(i) := 'Prueba' || TO_CHAR(i);
    END LOOP;
    
    IF vttab_ty_nombre.COUNT > 0 THEN
        FOR i IN vttab_ty_nombre.FIRST .. vttab_ty_nombre.LAST LOOP
            DBMS_OUTPUT.PUT_LINE('El ID del registro es: ' || vttab_ty_nombre(i));
        END LOOP;
    END IF;
    
END;

-- BLOQUES ASOCIATIVOS
DECLARE
    -- Creamos el tipo
    TYPE ttab_ty_nombre IS TABLE OF VARCHAR2(20 CHAR) INDEX BY VARCHAR2(2);
    -- Declaramos una variable del tipo creado
    vttab_ty_nombre ttab_ty_nombre;
    
    v_indice VARCHAR2(2);
    
BEGIN
    
    DBMS_OUTPUT.PUT_LINE('El número de registros en el vector es: ' || vttab_ty_nombre.COUNT);
    
    vttab_ty_nombre('ES') := 'España';
    vttab_ty_nombre('AR') := 'Argentina';
    vttab_ty_nombre('ME') := 'Mexico';
    vttab_ty_nombre('CO') := 'Colombia';
    
    v_indice := vttab_ty_nombre.FIRST;
    DBMS_OUTPUT.PUT_LINE('El indice del registro es: ' || v_indice);
    
    WHILE v_indice IS NOT NULL LOOP
        DBMS_OUTPUT.PUT_LINE('El ID es ' || v_indice || ' y su valor es: ' || vttab_ty_nombre(v_indice));
        v_indice := vttab_ty_nombre.NEXT(v_indice);
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Acceso directo: El ID es ES y su valor es: ' || vttab_ty_nombre('ES'));
    
    DBMS_OUTPUT.PUT_LINE('El número de registros en el vector es: ' || vttab_ty_nombre.COUNT);
    
END;

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

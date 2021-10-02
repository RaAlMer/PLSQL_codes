-- Record to insert three types into a new type called t_registro
DECLARE
	TYPE t_registro IS RECORD(
		v_producto  VARCHAR2(20),
		n_unidades  NUMBER(3),
		d_fechaalta DATE);

	vtr_producto t_registro;

	vr_proveedores tbproveedores%ROWTYPE; -- Variable with three fields from the suppliers' table

BEGIN
	SELECT * -- Inserting the supplier with ID = 1 into the variable created before
	  INTO vr_proveedores
	  FROM tbproveedores
	 WHERE n_idproveedor = 1;

	DBMS_OUTPUT.PUT_LINE('El ID del proveedor es ' || vr_proveedores.n_idproveedor);
	DBMS_OUTPUT.PUT_LINE('El nombre del proveedor es ' || vr_proveedores.v_desproveedor);
	DBMS_OUTPUT.PUT_LINE('La fecha de alta es ' || TO_CHAR(vr_proveedores.d_fechaalta, 'DD/MM/YYYY'));	

	vtr_producto.v_producto  := 'Martillo';
	vtr_producto.n_unidades  := 10;
	vtr_producto.d_fechaalta := SYSDATE;

	DBMS_OUTPUT.PUT_LINE('El producto es ' || vtr_producto.v_producto);
	DBMS_OUTPUT.PUT_LINE('Unidades: ' || vtr_producto.n_unidades);
	DBMS_OUTPUT.PUT_LINE('La fecha de alta es ' || TO_CHAR(vtr_producto.d_fechaalta, 'DD/MM/YYYY'));

END;

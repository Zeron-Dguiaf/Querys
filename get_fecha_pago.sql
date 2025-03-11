CREATE OR REPLACE FUNCTION SLU.get_fecha_pago (
    p_aa_formulario IN slu.tformulario.aa_formulario%TYPE,
    p_t_formulario IN slu.tformulario.t_formulario%TYPE,
    p_o_formulario IN slu.tformulario.o_formulario%TYPE,
    p_tipo IN VARCHAR2 DEFAULT NULL  -- Nuevo parámetro opcional
)
    RETURN VARCHAR IS

l_return VARCHAR(30);

BEGIN
    --
   BEGIN

     SELECT DECODE(TO_CHAR(MAX(FH_pago),'dd/mm/yyyy HH24:MI:SS'), NULL, '',
                     TO_CHAR(MAX(FH_pago),'dd/mm/yyyy HH24:MI:SS')) F_pago
           INTO l_return
           FROM slu.tpago p
           WHERE p.aa_op = p_aa_formulario
           AND p.t_op = p_t_formulario
           AND p.o_op = p_o_formulario
           AND p.e_pago NOT IN ('X', 'I')
           -- Permitir filtrado opcional si se pasa p_tipo
           AND (p_tipo IS NULL OR p.t_pago = p_tipo);

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            l_return := '0';
    END;

    RETURN NVL(l_return, '0');
    --
END;

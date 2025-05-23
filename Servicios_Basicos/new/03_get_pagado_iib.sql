-- GET PAGADO IIBB
CREATE OR REPLACE FUNCTION SLU.get_pagado_iib (
--
p_aa_formulario IN slu.tformulario.aa_formulario%TYPE,
p_t_formulario IN slu.tformulario.t_formulario%TYPE,
p_o_formulario IN slu.tformulario.o_formulario%TYPE,
p_t_pago IN slu.tpago.t_pago%TYPE
--,p_c_retencion IN slu.tpago.c_retencion%TYPE
)
RETURN NUMBER IS
--
l_return number;
--
BEGIN
--
BEGIN
--
SELECT sum(ia_pago) i_pago
INTO l_return
FROM slu.tpago p
WHERE p.aa_op=p_aa_formulario
AND p.t_op=p_t_formulario
AND p.o_op=p_o_formulario
AND p.t_pago=p_t_pago
AND p.e_pago not in ('X','I')
AND p.c_retencion=7--p_c_retencion
;
--
EXCEPTION
WHEN NO_DATA_FOUND THEN
l_return := 0;
END;
--
RETURN NVL(l_return,0);
--
END;

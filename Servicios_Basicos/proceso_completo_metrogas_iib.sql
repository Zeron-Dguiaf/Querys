--GET FECGHA PAGO
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
-- GET PAGADO OP
CREATE OR REPLACE FUNCTION SLU.get_pagado_op(

p_aa_formulario IN slu.tformulario.aa_formulario%TYPE,
p_t_formulario IN slu.tformulario.t_formulario%TYPE,
p_o_formulario IN slu.tformulario.o_formulario%TYPE,
p_t_pago IN slu.tpago.t_pago%TYPE
)
    RETURN NUMBER IS

l_return number;

BEGIN
    --
   BEGIN

     SELECT sum(ia_pago) i_pago
           INTO l_return
           FROM slu.tpago p
           WHERE p.aa_op=p_aa_formulario
           AND p.t_op=p_t_formulario
           AND p.o_op=p_o_formulario
            AND p.t_pago=p_t_pago
           AND p.e_pago not in ('X','I')
           --AND p.c_retencion=7
           ;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        l_return := 0;
    END;

    RETURN NVL(l_return,0);
    --
END;
-- GET PAGADO IIBB
CREATE OR REPLACE FUNCTION SLU.get_pagado_iib (

p_aa_formulario IN slu.tformulario.aa_formulario%TYPE,
p_t_formulario IN slu.tformulario.t_formulario%TYPE,
p_o_formulario IN slu.tformulario.o_formulario%TYPE,
p_t_pago IN slu.tpago.t_pago%TYPE
--,p_c_retencion IN slu.tpago.c_retencion%TYPE
)
    RETURN NUMBER IS

l_return number;

BEGIN
    --
   BEGIN

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

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        l_return := 0;
    END;

    RETURN NVL(l_return,0);
    --
END;
-- SCRIPT METROGAS
SELECT DISTINCT
       fac.o_factura AS "Nro Slu",
       fac.aa_factura AS "Ejercicio",
       fac.t_fact_proveedor AS "Tipo",
       fac.n_suc_fact_proveedor AS "Sucursal",
       fac.n_fact_proveedor AS "Numero",
       fac.f_vencimiento AS "VTO. FACT.",
       fac.f_vencimiento_op AS "VTO. O.PAGO",
       fac.e_factura AS "Estado",
       det.i_unitario AS "Total",
       det.f_desde AS "Fecha Desde",
       det.f_hasta AS "Fecha Hasta",
       det.c_medidor AS "Medidor",
       dop.o_formulario AS "Nro. OP",
       dop.t_formulario AS "Tipo OP",
       dop.aa_formulario AS "Ejercicio OP",
       op.f_emision AS "Fecha Emision OP",
       (SELECT t.ia_devengado
          FROM slu.tformulario t
         WHERE     t.aa_formulario = dop.aa_formulario
               AND t.t_formulario = dop.t_formulario
               AND t.o_formulario = dop.o_formulario)
          AS total_op,
       get_pagado_op (dop.aa_formulario,
                      dop.t_formulario,
                      dop.o_formulario,
                      'B')
          AS "Total pagado",
       get_pagado_op (dop.aa_formulario,
                      dop.t_formulario,
                      dop.o_formulario,
                      'O')
          AS "Total retenido",
                 get_pagado_iib (dop.aa_formulario,
                      dop.t_formulario,
                      dop.o_formulario,
                      'O')
          AS "Total retenido IIBB",
       get_fecha_pago (dop.aa_formulario,
                       dop.t_formulario,
                       dop.o_formulario
                       ,'B'
                       )
          AS "Fecha de pago"
  FROM slu.tfactura_gs fac
       JOIN slu.dfacgs_item det
          ON     fac.aa_factura = det.aa_factura
             AND fac.o_factura = det.o_factura
       LEFT JOIN slu.dform_item dop
          ON     fac.aa_factura = dop.aa_cpte_generador
             AND fac.o_factura = dop.n_cpte_generador
             AND fac.t_factura = dop.t_cpte_generador
       LEFT JOIN slu.tformulario op
          ON     op.aa_formulario = dop.aa_formulario
             AND op.t_formulario = dop.t_formulario
             AND op.o_formulario = dop.o_formulario
 WHERE fac.c_servicio IN ('METROG', 'GCMETG')
     AND -- fac.t_factura = 'FSB'
        (op.aa_formulario, op.t_formulario, op.o_formulario) IN (  SELECT aa_op,
                                                                             t_op,
                                                                             o_op
                                                                        FROM slu.tpago tpag
                                                                       WHERE    tpag.aa_pago>=2025
                                                                       AND tpag.fh_pago>= to_date('22/04/2025','dd/mm/rrrr'))
                                                                    GROUP BY fac.o_factura,
                                                                             fac.aa_factura,
                                                                             fac.t_fact_proveedor,
                                                                             fac.n_suc_fact_proveedor,
                                                                             fac.n_fact_proveedor,
                                                                             det.i_unitario,
                                                                             fac.f_vencimiento,
                                                                             fac.f_vencimiento_op,
                                                                             fac.e_factura,
                                                                             det.f_desde,
                                                                             det.f_hasta,
                                                                             det.c_medidor,
                                                                             dop.o_formulario,
                                                                             dop.t_formulario,
                                                                             dop.aa_formulario,
                                                                             op.f_emision
                                                                    ORDER BY fac.aa_factura,
                                                                             dop.o_formulario,
                                                                             dop.t_formulario,
                                                                             dop.aa_formulario

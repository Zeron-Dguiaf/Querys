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
                                                                       AND tpag.fh_pago>= to_date('07/02/2025','dd/mm/rrrr'))
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

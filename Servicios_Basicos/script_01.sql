SELECT        DECODE(TO_CHAR(tfor.C_JURIS) , NULL, ';', TO_CHAR(tfor.C_JURIS))        C_JURIS_OP
          ,   DECODE(TO_CHAR(tfor.C_SJURIS) , NULL, ';', TO_CHAR(tfor.C_SJURIS))      C_SJURIS_OP          
          ,   DECODE(TO_CHAR(tfor.C_ENTIDAD) , NULL, ';', TO_CHAR(tfor.C_ENTIDAD))    C_ENTIDAD_OP
          ,   DECODE(TO_CHAR(dfor.o_formulario), NULL, ';', to_char(dfor.o_formulario))   OP_SIGAF
          ,   DECODE(to_char(dfor.aa_formulario), NULL, ';', to_char(dfor.aa_formulario)) ANO_OP
          ,   DECODE(dfor.t_formulario, NULL, ';', dfor.t_formulario)                     TIPO_OP
          ,   DECODE(tfac.e_factura, NULL, ';', tfac.e_factura)                           ESTADO_FAC
          ,   DECODE(TO_CHAR(tfor.f_vencimiento_factura,'dd/mm/yyyy'), NULL, ';', 
                     TO_CHAR(tfor.f_vencimiento_factura,'dd/mm/yyyy'))                    VENCIMIENTO_OP
          ,   DECODE(to_char(dpag.o_item), NULL, ';', to_char(dpag.o_item))               O_ITEM
          ,   DECODE(TO_CHAR(tfor.f_emision,'dd/mm/yyyy'), NULL, ';', 
                     TO_CHAR(tfor.f_emision,'dd/mm/yyyy'))                                F_EMISION_OP
          ,   DECODE(TO_CHAR(tpag.fh_pago,'dd/mm/yyyy'), NULL, ';', 
                     TO_CHAR(tpag.fh_pago,'dd/mm/yyyy'))                                  FECHA_PAGO         
          ,   DECODE(TO_CHAR(tfac.o_factura,'99999999990'), NULL, ';', 
                     TO_CHAR(tfac.o_factura,'99999999990'))                               FAC_SIGAF
          ,   tfac.t_fact_proveedor||'-'||TO_CHAR(tfac.n_suc_fact_proveedor)||'-'||  TO_CHAR(tfac.n_fact_proveedor)  FACTURA_PROVE
          ,   DECODE(TO_CHAR(tfac.f_vencimiento,'dd/mm/yyyy'), NULL, ';', 
                     TO_CHAR(tfac.f_vencimiento,'dd/mm/yyyy'))                            VENCIMIENTO_FAC
          ,   DECODE(tfac.c_servicio, NULL, ';',tfac.c_servicio)                          SERVICIO
          ,   DECODE(dfac.c_medidor, NULL, ';', dfac.c_medidor)                           MEDIDOR
          ,   DECODE(tmed.XL_DIRECCION_MEDIDOR,NULL,';',tmed.XL_DIRECCION_MEDIDOR)        DIRECCION  
          ,   DECODE(tmed.t_servicio,NULL,';',tmed.t_servicio)                            T_SERVICIO
          ,   DECODE(to_char(dpag.i_pago), NULL, ';', to_char(dpag.i_pago))           PAGADO_ITEM_OP
          ,   DECODE(tpag.e_pago, NULL, ';',tpag.e_pago)                              ESTADO_PAGO
      FROM gs_tfactura_gs        tfac
      left join gs_dfacgs_item     dfac on tfac.aa_factura      =   dfac.aa_factura    AND tfac.o_factura     =   dfac.o_factura
      left join gs_dfacgs_ffi      dffi  on   dfac.aa_factura    =   dffi.aa_factura  AND dfac.o_factura     =   dffi.o_factura        
      left join gs_dform_item      dfor on    tfac.aa_factura    =   dfor.aa_cpte_generador   AND tfac.t_factura     =   dfor.t_cpte_generador  AND tfac.o_factura   =   dfor.n_cpte_generador  
      left join gs_tformulario     tfor on    dfor.aa_formulario =   tfor.aa_formulario    AND dfor.t_formulario  =   tfor.t_formulario    AND dfor.o_formulario  =   tfor.o_formulario
      left join gs_tmedidor        tmed on    tfac.c_servicio    =   tmed.c_servicio    AND dfac.c_medidor     =   tmed.c_medidor
      left join (select * from slu.tpago where e_pago <> 'X')  tpag on    tfor.aa_formulario =   tpag.aa_op    AND tfor.t_formulario  =   tpag.t_op    AND tfor.o_formulario  =   tpag.o_op
      left join pg_dpago           dpag on    tpag.aa_pago       =   dpag.aa_pago    AND tpag.o_pago        =   dpag.o_pago    AND dpag.o_item        =   dfor.o_item
WHERE  tfac.c_servicio    in ('AYSA','AYALQ')  
    AND tfac.t_factura = 'FSB'
    AND tfac.aa_factura < 2014
--    AND tfac.o_factura = 1146227
GROUP BY                 DECODE(dfor.o_formulario, NULL, ';', dfor.o_formulario)
            ,   DECODE(dfor.aa_formulario, NULL, ';', dfor.aa_formulario)
            ,   DECODE(dfor.t_formulario, NULL, ';', dfor.t_formulario)  
, DECODE(TO_CHAR(tfor.C_JURIS) , NULL, ';', TO_CHAR(tfor.C_JURIS))        
          ,   DECODE(TO_CHAR(tfor.C_SJURIS) , NULL, ';', TO_CHAR(tfor.C_SJURIS))                
          ,   DECODE(TO_CHAR(tfor.C_ENTIDAD) , NULL, ';', TO_CHAR(tfor.C_ENTIDAD))    
          ,   DECODE(TO_CHAR(dfor.o_formulario), NULL, ';', to_char(dfor.o_formulario))   
          ,   DECODE(to_char(dfor.aa_formulario), NULL, ';', to_char(dfor.aa_formulario)) 
          ,   DECODE(dfor.t_formulario, NULL, ';', dfor.t_formulario)                     
          ,   DECODE(tfac.e_factura, NULL, ';', tfac.e_factura)                           
          ,   DECODE(TO_CHAR(tfor.f_vencimiento_factura,'dd/mm/yyyy'), NULL, ';', 
                     TO_CHAR(tfor.f_vencimiento_factura,'dd/mm/yyyy'))                    
          ,   DECODE(to_char(dpag.o_item), NULL, ';', to_char(dpag.o_item))               
          ,   DECODE(TO_CHAR(tfor.f_emision,'dd/mm/yyyy'), NULL, ';', 
                     TO_CHAR(tfor.f_emision,'dd/mm/yyyy'))                                
          ,   DECODE(TO_CHAR(tpag.fh_pago,'dd/mm/yyyy'), NULL, ';', 
                     TO_CHAR(tpag.fh_pago,'dd/mm/yyyy'))                                           
          ,   DECODE(TO_CHAR(tfac.o_factura,'99999999990'), NULL, ';', 
                     TO_CHAR(tfac.o_factura,'99999999990'))                               
          ,   tfac.t_fact_proveedor||'-'||TO_CHAR(tfac.n_suc_fact_proveedor)||'-'||  TO_CHAR(tfac.n_fact_proveedor)  
          ,   DECODE(TO_CHAR(tfac.f_vencimiento,'dd/mm/yyyy'), NULL, ';', 
                     TO_CHAR(tfac.f_vencimiento,'dd/mm/yyyy'))                            
          ,   DECODE(tfac.c_servicio, NULL, ';',tfac.c_servicio)                          
          ,   DECODE(dfac.c_medidor, NULL, ';', dfac.c_medidor)                           
          ,   DECODE(tmed.XL_DIRECCION_MEDIDOR,NULL,';',tmed.XL_DIRECCION_MEDIDOR)          
          ,   DECODE(tmed.t_servicio,NULL,';',tmed.t_servicio)                            
          ,   DECODE(to_char(dpag.i_pago), NULL, ';', to_char(dpag.i_pago))           
          ,   DECODE(tpag.e_pago, NULL, ';',tpag.e_pago)
          ORDER BY DECODE(TO_CHAR(tfac.o_factura,'99999999990'), NULL, ';', 
                       TO_CHAR(tfac.o_factura,'99999999990'))

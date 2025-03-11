select 
  tfac.o_factura, 
  tfac.aa_factura, 
  tfac.t_fact_proveedor, 
  TFAC.N_SUC_FACT_PROVEEDOR, 
  tfac.n_fact_proveedor,
  tfac.o_beneficiario, 
  tfac.f_vencimiento, 
  tfac.f_vencimiento_op,
  tfac.e_factura, 
  r.monto_factura, 
  r.f_desde, 
  r.f_hasta, 
  r.c_medidor, 
  o.aa_formulario, 
  o.t_formulario, 
  o.o_formulario, 
  o.op_dev,o.op_pag
from slu.tfactura_gs tfac
inner join (select aa_factura,o_factura,c_medidor, sum(k_facturada*i_unitario) as monto_factura, f_desde, f_hasta from slu.dfacgs_item group by aa_factura,o_factura,c_medidor, f_desde, f_hasta) R on tfac.aa_factura = r.aa_factura and tfac.o_factura = r.o_factura
left join (select aa_formulario, t_formulario, o_formulario, sum (i_devengado) as op_dev, sum(i_pagado)op_pag, aa_cpte_generador,t_cpte_generador,n_cpte_generador from slu.dform_item group by aa_cpte_generador,t_cpte_generador,n_cpte_generador,aa_formulario, t_formulario, o_formulario) o on tfac.aa_factura = o.aa_cpte_generador  AND   tfac.t_factura =  o.t_cpte_generador  AND   tfac.o_factura = o.n_cpte_generador
where tfac.c_servicio in ('AYSA', 'AGUAS','AYALQ')
order by 
  tfac.aa_factura, 
  tfac.o_factura

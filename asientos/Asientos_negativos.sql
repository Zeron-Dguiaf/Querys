SELECT
  DISTINCT
  aa_frm,
  t_frm,
  n_frm,
  c_serv,
  fecha_contable

FROM
(
       SELECT 
        a.aa_ejercicio aa_eje,
        a.o_asiento n_asiento,
        a.f_asiento fecha_de_carga,
        a.f_formulario fecha_contable,
        a.aa_ejercicio_frm aa_frm,
        a.c_formulario t_frm,
        a.n_formulario n_frm,
        a.xl_asiento,
        a.c_servicio_contable c_serv,
        decode(a.t_generacion,'A','ASIENTO','CONTRA ASIENTO') tipo,
        b.t_operacion t_ope,
        (
            SELECT d.c_clasificador
            FROM slu.brelcontab d
            WHERE  a.aa_ejercicio  =  d.aa_ejercicio
            AND    b.o_relacion    =  d.o_relacion  

        )clas,
        b.c_cuenta,
        c.xc_cuenta,
        (
            SELECT d.c_tabla
            FROM slu.brelcontab d
            WHERE  a.aa_ejercicio  =  d.aa_ejercicio
            AND    b.o_relacion    =  d.o_relacion  

        )matriz,
        (
            SELECT decode(b.c_cuenta,d.c_cuenta_debe,'D',decode(b.c_cuenta,d.c_cuenta_haber,'H','SIN RELACION'))
            FROM  slu.brelcontab d
            WHERE a.aa_ejercicio  =  d.aa_ejercicio
            AND   b.o_relacion    =  d.o_relacion 

        ) toma,
        (
            SELECT distinct sum(imp.i_imputado)
            FROM slu.dasieit imp
            WHERE  imp.aa_ejercicio          =  a.aa_ejercicio
            AND    imp.o_asiento             =  a.o_asiento
            AND    imp.c_servicio_contable   =  a.c_servicio_contable
            AND    imp.t_operacion           =  b.t_operacion
            AND    imp.c_cuenta              =  b.c_cuenta
            AND    imp.o_item                =  b.o_item
                            
        )importe

        FROM slu.tasiecab a, slu.dasieit b, slu.bcuenta_contable c, slu.rasiento ra

        WHERE a.aa_ejercicio         = b.aa_ejercicio
        AND   a.o_asiento            = b.o_asiento
        AND   a.c_servicio_contable  = b.c_servicio_contable
        AND   a.aa_ejercicio         = c.aa_ejercicio
        AND   b.c_cuenta             = c.c_cuenta
        AND   ra.aa_ejercicio        = a.aa_ejercicio
        AND   ra.o_asiento           = a.o_asiento
        AND   ra.c_servicio_contable = a.c_servicio_contable
        AND   ra.t_operacion         = b.t_operacion
        AND   ra.c_cuenta            = b.c_cuenta
        AND   ra.o_item              = b.o_item


        GROUP BY a.aa_ejercicio,a.o_asiento,a.f_asiento,a.f_formulario,a.o_asiento,a.aa_ejercicio_frm,a.c_formulario,a.n_formulario,a.xl_asiento,a.c_servicio_contable,b.t_operacion,a.t_generacion,b.c_cuenta,c.xc_cuenta,b.o_relacion,b.o_item/*,DECODE(b.c_cuenta,d.c_cuenta_debe,'D',DECODE(b.c_cuenta,d.c_cuenta_haber,'H','SIN RELACION'))*/
)
WHERE 1=1
    
and (aa_eje,n_asiento,c_serv) in
(
 SELECT
 aa_ejercicio, 
 o_asiento,
 c_servicio_contable
 
 FROM 
 (
    SELECT
    aa_ejercicio, 
    o_asiento,
    t_operacion,
    c_servicio_contable,
    c_cuenta,
     sum(i_imputado) importe 
    FROM slu.dasieit
    
    GROUP BY
      aa_ejercicio,
      o_asiento,
      t_operacion,
      C_SERVICIO_CONTABLE,
      c_cuenta
    having(sum(i_imputado)<0)
 ) 
      
)

ORDER BY

aa_frm,
t_frm,
n_frm,
fecha_contable,
c_serv


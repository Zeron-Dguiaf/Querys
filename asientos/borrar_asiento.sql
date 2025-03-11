-- BORRAR ASIENTO

DECLARE
CURSOR asiento_borrar_cur IS
         SELECT aa_ejercicio,o_asiento,c_servicio_contable,c_formulario,aa_ejercicio_frm,n_formulario
          FROM slu.tasiecab
        WHERE aa_ejercicio = 2024 --ejercicio contable
            and c_formulario = 'PAG' --Tipos de formulario
            --and n_formulario in (543,533) --Numeros de formulario
            AND o_asiento IN (1695041, 1695045)
            and aa_ejercicio_frm = 2024 --Año del formulario
       ORDER BY n_formulario, c_formulario, o_asiento;
BEGIN 
   FOR  asiento_borrar_rec IN  asiento_borrar_cur LOOP 
            DELETE cg_tasiehis
            WHERE AA_EJERCICIO =  asiento_borrar_rec.aa_ejercicio 
            AND o_asiento = asiento_borrar_rec.o_asiento
            AND c_servicio_contable = asiento_borrar_rec.c_servicio_contable;
    
            DELETE cg_rasiento
            WHERE AA_EJERCICIO =  asiento_borrar_rec.aa_ejercicio 
            AND o_asiento = asiento_borrar_rec.o_asiento
            AND c_servicio_contable = asiento_borrar_rec.c_servicio_contable;
            
            DELETE cg_DASIEIT
            WHERE AA_EJERCICIO =  asiento_borrar_rec.aa_ejercicio 
            AND o_asiento = asiento_borrar_rec.o_asiento
            AND c_servicio_contable = asiento_borrar_rec.c_servicio_contable;        
            
            
            DELETE cg_rdasieit
            WHERE AA_EJERCICIO =  asiento_borrar_rec.aa_ejercicio 
            AND o_asiento = asiento_borrar_rec.o_asiento
            AND c_servicio_contable = asiento_borrar_rec.c_servicio_contable;        
            
            DELETE CG_TASIECAB
            WHERE AA_EJERCICIO =  asiento_borrar_rec.aa_ejercicio 
            AND o_asiento = asiento_borrar_rec.o_asiento
            AND c_servicio_contable = asiento_borrar_rec.c_servicio_contable;
    
            DELETE CG_RASIENTO
            WHERE AA_EJERCICIO =  asiento_borrar_rec.aa_ejercicio 
            AND o_asiento = asiento_borrar_rec.o_asiento
            AND c_servicio_contable = asiento_borrar_rec.c_servicio_contable;   
      END LOOP ;     
END;

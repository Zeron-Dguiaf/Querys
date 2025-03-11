DECLARE 
CURSOR tformulario_cur IS 
    SELECT t.aa_c10 aa_formulario,'C10' t_formulario,t.o_c10 o_formulario, t.e_c10 e_formulario
    FROM tc10 t
    WHERE t.aa_c10 = 2013 --AÒo formulario
    and t.o_c10  in (520,547) --Num formulario

    AND (t.aa_c10,t.o_c10) NOT IN  (
    select ta.aa_ejercicio_frm,ta.n_formulario 
    from tasiecab ta
    WHERE ta.c_formulario = 'C10'); --Tipo formulario

    p_clave_form      GS_SPAE_FORMUL_GS.clave_form;
    l_atributos       GS_SPAE_FORMUL_GS.atributos_form;    
    l_saf_local            NUMBER;

BEGIN

    l_saf_local  := sys_context('VPDSLU','N_SAF');
    --
    FOR tformulario_rec IN tformulario_cur LOOP 
    BEGIN 
        p_clave_form.aa_formulario := tformulario_rec.aa_formulario;
        p_clave_form.o_formulario  := tformulario_rec.o_formulario;
        p_clave_form.t_formulario  := tformulario_rec.t_formulario;
            
        IF  cg_spa_asientos_contables.SFN_Generacion_Automatica (
                p_clave_form.aa_formulario
            ,   p_clave_form.t_formulario
            ,   p_clave_form.o_formulario
            ,   l_saf_local
            ,   tformulario_rec.e_formulario
            )   !=  'SI'
        THEN
           dbms_output.put_line(p_clave_form.aa_formulario||'-'||p_clave_form.t_formulario||'-'||p_clave_form.o_formulario);
        END IF; 
        EXCEPTION 
           WHEN OTHERS THEN 
               dbms_output.put_line(p_clave_form.aa_formulario||'-'||p_clave_form.t_formulario||'-'||p_clave_form.o_formulario);
        END ; 
                
   END LOOP;   
END;

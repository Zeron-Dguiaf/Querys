DECLARE 
    CURSOR tformulario_cur IS 
        SELECT t.aa_formulario, t.t_formulario, t.o_formulario, t.e_formulario
        FROM tformulario t
        WHERE t.t_formulario = 'C55' -- Tipo formulario
          AND t.aa_formulario = 2013 -- Año formulario
          AND t.o_formulario IN (520, 547) -- Números de formulario
          AND (t.aa_formulario, t.o_formulario) NOT IN (
              SELECT ta.aa_ejercicio_frm, ta.n_formulario 
              FROM tasiecab ta
              WHERE ta.c_formulario = 'C55' -- Tipo formulario
          );

    p_clave_form      GS_SPAE_FORMUL_GS.clave_form;
    l_atributos       GS_SPAE_FORMUL_GS.atributos_form;    
    l_saf_local       NUMBER;

BEGIN
    -- Obtener el valor de la variable de contexto
    l_saf_local := sys_context('VPDSLU', 'N_SAF');
    
    -- Iterar sobre el cursor
    FOR tformulario_rec IN tformulario_cur LOOP 
        BEGIN 
            -- Asignar valores a la variable p_clave_form
            p_clave_form.aa_formulario := tformulario_rec.aa_formulario;
            p_clave_form.o_formulario  := tformulario_rec.o_formulario;
            p_clave_form.t_formulario  := tformulario_rec.t_formulario;
            
            -- Llamar a la función SFN_Generacion_Automatica
            IF cg_spa_asientos_contables.SFN_Generacion_Automatica(
                   p_clave_form.aa_formulario,
                   p_clave_form.t_formulario,
                   p_clave_form.o_formulario,
                   l_saf_local,
                   tformulario_rec.e_formulario
               ) != 'SI'
            THEN
                -- Mostrar información en la consola
                dbms_output.put_line(
                    p_clave_form.aa_formulario || '-' ||
                    p_clave_form.t_formulario || '-' ||
                    p_clave_form.o_formulario
                );
            END IF; 
        EXCEPTION 
            WHEN OTHERS THEN 
                -- Manejo de excepciones: Mostrar mensaje en la consola
                dbms_output.put_line(
                    p_clave_form.aa_formulario || '-' ||
                    p_clave_form.t_formulario || '-' ||
                    p_clave_form.o_formulario
                );
        END; 
    END LOOP;   
END;
/

BEGIN

    FOR r_cur IN (SELECT * 
                    FROM slu.busuario 
                   WHERE (c_user = 'SIDIFLU')  --Usuario a blanquear
                  )
    LOOP
        men_spar_usuario.cambiar_password(r_cur.c_user, 'OBSBA2025', 'OBSBA2025'); -- Ingresar 2 veces la cotraseña que se le quiere poner al usuario

        UPDATE slu.busuario set fh_bloqueo = NULL,
                        m_bloqueo = NULL,
                        fh_baja = NULL
                 WHERE c_user = r_cur.c_user;
    END LOOP;

END;

WITH
rol_menu AS
(
    SELECT 
    ar.c_menuitem,
    ar.c_rol_usuario,
    bru.xc_rol_usuario
    FROM slu.amenuitem_rolusu ar 
    
    INNER JOIN slu.brol_usuario bru 
    ON  bru.c_rol_usuario=ar.c_rol_usuario
    AND bru.fh_baja IS NULL

)

SELECT
DISTINCT
a1.c_menu,
a1.c_menuitem,
a1.xl_menuitem,
rol1.c_rol_usuario,
rol1.xc_rol_usuario,
a1.c_accion nombre_from_pl,
a2.c_menu,
a2.c_menuitem,
a2.xl_menuitem,
rol2.c_rol_usuario,
rol2.xc_rol_usuario,
a2.c_accion nombre_from_pl,
a3.c_menu,
a3.c_menuitem,
a3.xl_menuitem,
rol3.c_rol_usuario,
rol3.xc_rol_usuario,
a3.c_accion nombre_from_pl,
a4.c_menu,
a4.c_menuitem,
a4.xl_menuitem,
rol4.c_rol_usuario,
rol4.xc_rol_usuario,
a4.c_accion nombre_from_pl,
a5.c_menu,
a5.c_menuitem,
a5.xl_menuitem,
rol5.c_rol_usuario,
rol5.xc_rol_usuario,
a5.c_accion nombre_from_pl,
a6.c_menu,
a6.c_menuitem,
a6.xl_menuitem,
rol6.c_rol_usuario,
rol6.xc_rol_usuario,
a6.c_accion nombre_from_pl,
a7.c_menu,
a7.c_menuitem,
a7.xl_menuitem,
rol7.c_rol_usuario,
rol7.xc_rol_usuario,
a7.c_accion nombre_from_pl,
a8.c_menu,
a8.c_menuitem,
a8.xl_menuitem,
rol8.c_rol_usuario,
rol8.xc_rol_usuario,
a8.c_accion nombre_from_pl,
a9.c_menu,
a9.c_menuitem,
a9.xl_menuitem,
rol9.c_rol_usuario,
rol9.xc_rol_usuario,
a9.c_accion nombre_from_pl,
a10.c_menu,
a10.c_menuitem,
a10.xl_menuitem,
rol10.c_rol_usuario,
rol10.xc_rol_usuario,
a10.c_accion nombre_from_pl
FROM slu.tmenuitem a1

LEFT JOIN rol_menu rol1 ON rol1.c_menuitem=a1.c_menuitem
LEFT JOIN slu.tmenuitem a2 ON  a1.c_menuitem=a2.c_menu
LEFT JOIN rol_menu rol2 ON rol2.c_menuitem=a2.c_menuitem
LEFT JOIN slu.tmenuitem a3 ON a2.c_menuitem=a3.c_menu
LEFT JOIN rol_menu rol3 ON rol3.c_menuitem=a3.c_menuitem
LEFT JOIN slu.tmenuitem a4 ON a3.c_menuitem=a4.c_menu
LEFT JOIN rol_menu rol4 ON rol4.c_menuitem=a4.c_menuitem
LEFT JOIN slu.tmenuitem a5 ON a4.c_menuitem=a5.c_menu
LEFT JOIN rol_menu rol5 ON rol5.c_menuitem=a5.c_menuitem
LEFT JOIN slu.tmenuitem a6 ON a5.c_menuitem=a6.c_menu
LEFT JOIN rol_menu rol6 ON rol6.c_menuitem=a6.c_menuitem
LEFT JOIN slu.tmenuitem a7 ON a6.c_menuitem=a7.c_menu
LEFT JOIN rol_menu rol7 ON rol7.c_menuitem=a7.c_menuitem
LEFT JOIN slu.tmenuitem a8 ON a7.c_menuitem=a8.c_menu
LEFT JOIN rol_menu rol8 ON rol8.c_menuitem=a8.c_menuitem
LEFT JOIN slu.tmenuitem a9 ON a8.c_menuitem=a9.c_menu
LEFT JOIN rol_menu rol9 ON rol9.c_menuitem=a9.c_menuitem
LEFT JOIN slu.tmenuitem a10 ON a9.c_menuitem=a10.c_menu
LEFT JOIN rol_menu rol10 ON rol10.c_menuitem=a10.c_menuitem
WHERE 1=1
AND a1.c_menu IN (1)
--AND upper(a1.xl_menuitem) LIKE '%CONSULTAS%'
--AND a3.c_menuitem IN (17007)
ORDER BY 
a1.c_menu,a1.c_menuitem,rol1.c_rol_usuario,
a2.c_menu,a2.c_menuitem,rol2.c_rol_usuario,
a3.c_menu,a3.c_menuitem,rol3.c_rol_usuario,
a4.c_menu,a4.c_menuitem,rol4.c_rol_usuario,
a5.c_menu,a5.c_menuitem,rol5.c_rol_usuario,
a6.c_menu,a6.c_menuitem,rol6.c_rol_usuario,
a7.c_menu,a7.c_menuitem,rol7.c_rol_usuario,
a8.c_menu,a8.c_menuitem,rol8.c_rol_usuario,
a9.c_menu,a9.c_menuitem,rol9.c_rol_usuario,
a10.c_menu,a10.c_menuitem,rol10.c_rol_usuario

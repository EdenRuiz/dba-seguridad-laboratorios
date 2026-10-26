-- LAB-04: Roles, privilegios y separación de cuentas (Actividades 8 y 9)

-- 1. Auditoría de roles actuales
SELECT 
    rolname AS "Rol", 
    rolsuper AS "Es_Superusuario", 
    rolcreaterole AS "Crea_Roles", 
    rolcreatedb AS "Crea_DB", 
    rolcanlogin AS "Puede_Login"
FROM pg_roles
ORDER BY rolname;

-- 2. Creación conceptual de cuentas segregadas
CREATE ROLE dba_admin WITH LOGIN SUPERUSER CREATEDB CREATEROLE PASSWORD 'Scram$Fuerte123';
CREATE ROLE app_user WITH LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE PASSWORD 'Scram$App456';
CREATE ROLE readonly_user WITH LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE PASSWORD 'Scram$Read789';
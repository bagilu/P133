-- P133 v3.4 health check: review results before declaring deployment compliant.
SELECT n.nspname AS schema_name, c.relname AS table_name, c.relrowsecurity AS rls_enabled
FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE n.nspname = 'p133_data' AND c.relkind = 'r' ORDER BY c.relname;

SELECT schemaname, tablename, policyname, roles, cmd
FROM pg_policies WHERE schemaname = 'p133_data' ORDER BY tablename, policyname;

SELECT routine_schema, routine_name, security_type
FROM information_schema.routines WHERE routine_schema = 'p133_api' ORDER BY routine_name;

SELECT table_schema, table_name, grantee, privilege_type
FROM information_schema.role_table_grants WHERE table_schema = 'p133_data' ORDER BY table_name, grantee, privilege_type;

SELECT routine_schema, routine_name, grantee, privilege_type
FROM information_schema.role_routine_grants WHERE routine_schema = 'p133_api' ORDER BY routine_name, grantee;

-- Manual required checks: only p133_api added to Data API Exposed Schemas; p133_data absent.
-- Test anon RPC calls are allowed for active records; direct p133_data REST access is unavailable.

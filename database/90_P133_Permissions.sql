-- P133-only permissions review. Do not add broad public-schema grants.
REVOKE ALL ON SCHEMA p133_data FROM PUBLIC;
REVOKE ALL ON TABLE p133_data."TblP133GeographicEntity", p133_data."TblP133EntityRelation" FROM PUBLIC;
GRANT USAGE ON SCHEMA p133_data TO anon, authenticated;
GRANT SELECT ON p133_data."TblP133GeographicEntity", p133_data."TblP133EntityRelation" TO anon, authenticated;
GRANT USAGE ON SCHEMA p133_api TO anon, authenticated;
REVOKE ALL ON FUNCTION p133_api."P133_ListGeographicEntities"() FROM PUBLIC;
REVOKE ALL ON FUNCTION p133_api."P133_GetEntityGeometry"(text) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION p133_api."P133_ListGeographicEntities"() TO anon, authenticated;
GRANT EXECUTE ON FUNCTION p133_api."P133_GetEntityGeometry"(text) TO anon, authenticated;

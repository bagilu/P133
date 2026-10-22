-- P133 GeoShift V0.001 / SBI-P-SDS v3.4
-- Run only after confirming p133_api is the sole additional Data API exposed schema.
CREATE SCHEMA IF NOT EXISTS p133_data;
CREATE SCHEMA IF NOT EXISTS p133_api;

CREATE TABLE IF NOT EXISTS p133_data."TblP133GeographicEntity" (
  "EntityID" text PRIMARY KEY,
  "NameZh" text NOT NULL,
  "NameEn" text NOT NULL,
  "EntityType" text NOT NULL CHECK ("EntityType" IN ('Country','Territory','Admin1','Admin2','Island','Region','CustomArea')),
  "ParentEntityID" text NULL REFERENCES p133_data."TblP133GeographicEntity"("EntityID"),
  "AreaKm2" numeric(16,3) NOT NULL CHECK ("AreaKm2" > 0),
  "AreaDefinition" text NOT NULL,
  "AreaSource" text NOT NULL,
  "AreaYear" smallint NULL,
  "Geometry" jsonb NOT NULL,
  "GeometrySource" text NOT NULL,
  "GeometryLicense" text NOT NULL,
  "GeometryVersion" text NOT NULL,
  "Status" text NOT NULL DEFAULT 'draft' CHECK ("Status" IN ('draft','active','deprecated')),
  "CreatedAt" timestamptz NOT NULL DEFAULT now(),
  "UpdatedAt" timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS p133_data."TblP133EntityRelation" (
  "RelationID" bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "ParentEntityID" text NOT NULL REFERENCES p133_data."TblP133GeographicEntity"("EntityID"),
  "ChildEntityID" text NOT NULL REFERENCES p133_data."TblP133GeographicEntity"("EntityID"),
  "RelationType" text NOT NULL CHECK ("RelationType" IN ('contains','composed_of','overlaps','comparison_variant')),
  "EffectiveFrom" date NULL,
  "EffectiveTo" date NULL,
  CONSTRAINT "P133_NoSelfRelation" CHECK ("ParentEntityID" <> "ChildEntityID")
);

ALTER TABLE p133_data."TblP133GeographicEntity" ENABLE ROW LEVEL SECURITY;
ALTER TABLE p133_data."TblP133EntityRelation" ENABLE ROW LEVEL SECURITY;

-- Public display RPC requires only active entities. The data schema itself must not be Data API exposed.
CREATE POLICY "P133 public reads active geographic entities"
  ON p133_data."TblP133GeographicEntity" FOR SELECT TO anon, authenticated
  USING ("Status" = 'active');
CREATE POLICY "P133 public reads active relations"
  ON p133_data."TblP133EntityRelation" FOR SELECT TO anon, authenticated
  USING (EXISTS (SELECT 1 FROM p133_data."TblP133GeographicEntity" e WHERE e."EntityID" = "ChildEntityID" AND e."Status" = 'active'));

REVOKE ALL ON SCHEMA p133_data FROM PUBLIC, anon, authenticated;
GRANT USAGE ON SCHEMA p133_data TO anon, authenticated;
REVOKE ALL ON TABLE p133_data."TblP133GeographicEntity", p133_data."TblP133EntityRelation" FROM PUBLIC;
GRANT SELECT ON p133_data."TblP133GeographicEntity", p133_data."TblP133EntityRelation" TO anon, authenticated;
-- No INSERT is granted in this public-read phase; therefore no sequence privilege is granted.

CREATE OR REPLACE FUNCTION p133_api."P133_ListGeographicEntities"()
RETURNS TABLE("EntityID" text, "NameZh" text, "NameEn" text, "EntityType" text, "AreaKm2" numeric, "AreaDefinition" text, "AreaYear" smallint)
LANGUAGE sql STABLE SECURITY INVOKER SET search_path = p133_api, p133_data, pg_temp
AS $$ SELECT "EntityID", "NameZh", "NameEn", "EntityType", "AreaKm2", "AreaDefinition", "AreaYear"
FROM p133_data."TblP133GeographicEntity" WHERE "Status" = 'active' ORDER BY "NameZh"; $$;

CREATE OR REPLACE FUNCTION p133_api."P133_GetEntityGeometry"(p_entity_id text)
RETURNS TABLE("EntityID" text, "NameZh" text, "NameEn" text, "Geometry" jsonb, "GeometryVersion" text)
LANGUAGE sql STABLE SECURITY INVOKER SET search_path = p133_api, p133_data, pg_temp
AS $$ SELECT "EntityID", "NameZh", "NameEn", "Geometry", "GeometryVersion"
FROM p133_data."TblP133GeographicEntity" WHERE "EntityID" = p_entity_id AND "Status" = 'active'; $$;

REVOKE ALL ON FUNCTION p133_api."P133_ListGeographicEntities"() FROM PUBLIC;
REVOKE ALL ON FUNCTION p133_api."P133_GetEntityGeometry"(text) FROM PUBLIC;
GRANT USAGE ON SCHEMA p133_api TO anon, authenticated;
GRANT EXECUTE ON FUNCTION p133_api."P133_ListGeographicEntities"() TO anon, authenticated;
GRANT EXECUTE ON FUNCTION p133_api."P133_GetEntityGeometry"(text) TO anon, authenticated;

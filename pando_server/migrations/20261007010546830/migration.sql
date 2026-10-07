BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "activity_session" (
    "id" bigserial PRIMARY KEY,
    "profileId" bigint NOT NULL,
    "clientSessionId" text NOT NULL,
    "startedAt" timestamp without time zone NOT NULL,
    "endedAt" timestamp without time zone NOT NULL,
    "steps" bigint NOT NULL,
    "strideM" double precision NOT NULL,
    "distanceM" double precision NOT NULL,
    "goalSteps" bigint NOT NULL,
    "goalM" double precision NOT NULL,
    "goalMet" boolean NOT NULL,
    "extraM" double precision NOT NULL,
    "feel" text,
    "stoppedEarly" boolean NOT NULL,
    "paceDropped" boolean NOT NULL,
    "startPathM" double precision NOT NULL,
    "endPathM" double precision NOT NULL,
    "reportMessage" text,
    "reportReadyAt" timestamp without time zone NOT NULL,
    "notificationSentAt" timestamp without time zone,
    "isSeeded" boolean NOT NULL DEFAULT false
);

-- Indexes
CREATE UNIQUE INDEX "activity_session_client_id_idx" ON "activity_session" USING btree ("clientSessionId");
CREATE INDEX "activity_session_profile_idx" ON "activity_session" USING btree ("profileId", "endedAt");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "activity_session"
    ADD CONSTRAINT "activity_session_fk_0"
    FOREIGN KEY("profileId")
    REFERENCES "user_profile"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR pando
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('pando', '20261007010546830', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261007010546830', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260924105404509', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105404509', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260924105232991', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105232991', "timestamp" = now();


COMMIT;

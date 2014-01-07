-- Structure of Sonar Database

-- Initially this file has been generated from existing H2 DB
-- Should be updated manually, during addition of new migrations

CREATE TABLE "GROUPS_USERS" (
  "USER_ID" INTEGER,
  "GROUP_ID" INTEGER
);

CREATE TABLE "DEPENDENCIES" (
  "ID" BIGINT NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "FROM_SNAPSHOT_ID" INTEGER,
  "FROM_RESOURCE_ID" INTEGER,
  "TO_SNAPSHOT_ID" INTEGER,
  "TO_RESOURCE_ID" INTEGER,
  "DEP_USAGE" VARCHAR(30),
  "DEP_WEIGHT" INTEGER,
  "PROJECT_SNAPSHOT_ID" INTEGER,
  "PARENT_DEPENDENCY_ID" BIGINT,
  "FROM_SCOPE" VARCHAR(3),
  "TO_SCOPE" VARCHAR(3)
);

CREATE TABLE "CHARACTERISTICS" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "KEE" VARCHAR(100),
  "NAME" VARCHAR(100),
  "PARENT_ID" INTEGER,
  "ROOT_ID" INTEGER,
  "RULE_ID" INTEGER,
  "FUNCTION_KEY" VARCHAR(100),
  "FACTOR_VALUE" DOUBLE,
  "FACTOR_UNIT" VARCHAR(100),
  "OFFSET_VALUE" DOUBLE,
  "OFFSET_UNIT" VARCHAR(100),
  "CHARACTERISTIC_ORDER" INTEGER,
  "ENABLED" BOOLEAN,
  "CREATED_AT" TIMESTAMP,
  "UPDATED_AT" TIMESTAMP
);

CREATE TABLE "RULES_PARAMETERS" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "RULE_ID" INTEGER NOT NULL,
  "NAME" VARCHAR(128) NOT NULL,
  "PARAM_TYPE" VARCHAR(512) NOT NULL,
  "DEFAULT_VALUE" VARCHAR(4000),
  "DESCRIPTION" VARCHAR(4000)
);

CREATE TABLE "RULES_PROFILES" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "NAME" VARCHAR(100) NOT NULL,
  "LANGUAGE" VARCHAR(20),
  "PARENT_NAME" VARCHAR(100),
  "VERSION" INTEGER DEFAULT 1,
  "USED_PROFILE" BOOLEAN DEFAULT FALSE
);

CREATE TABLE "WIDGETS" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "DASHBOARD_ID" INTEGER NOT NULL,
  "WIDGET_KEY" VARCHAR(256) NOT NULL,
  "NAME" VARCHAR(256),
  "DESCRIPTION" VARCHAR(1000),
  "COLUMN_INDEX" INTEGER,
  "ROW_INDEX" INTEGER,
  "CONFIGURED" BOOLEAN,
  "CREATED_AT" TIMESTAMP,
  "UPDATED_AT" TIMESTAMP,
  "RESOURCE_ID" INTEGER
);

CREATE TABLE "MEASURE_DATA" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "MEASURE_ID" BIGINT,
  "SNAPSHOT_ID" INTEGER,
  "DATA" BINARY(167772150)
);

CREATE TABLE "GROUPS" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "NAME" VARCHAR(255),
  "DESCRIPTION" VARCHAR(200),
  "CREATED_AT" TIMESTAMP,
  "UPDATED_AT" TIMESTAMP
);

CREATE TABLE "ACTIVE_RULE_PARAM_CHANGES" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "ACTIVE_RULE_CHANGE_ID" INTEGER NOT NULL,
  "RULES_PARAMETER_ID" INTEGER NOT NULL,
  "OLD_VALUE" VARCHAR(4000),
  "NEW_VALUE" VARCHAR(4000)
);

CREATE TABLE "SNAPSHOTS" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "CREATED_AT" TIMESTAMP,
  "BUILD_DATE" TIMESTAMP,
  "PROJECT_ID" INTEGER NOT NULL,
  "PARENT_SNAPSHOT_ID" INTEGER,
  "STATUS" VARCHAR(4) NOT NULL DEFAULT 'U',
  "PURGE_STATUS" INTEGER,
  "ISLAST" BOOLEAN NOT NULL DEFAULT FALSE,
  "SCOPE" VARCHAR(3),
  "QUALIFIER" VARCHAR(10),
  "ROOT_SNAPSHOT_ID" INTEGER,
  "VERSION" VARCHAR(500),
  "PATH" VARCHAR(500),
  "DEPTH" INTEGER,
  "ROOT_PROJECT_ID" INTEGER,
  "PERIOD1_MODE" VARCHAR(100),
  "PERIOD1_PARAM" VARCHAR(100),
  "PERIOD1_DATE" TIMESTAMP,
  "PERIOD2_MODE" VARCHAR(100),
  "PERIOD2_PARAM" VARCHAR(100),
  "PERIOD2_DATE" TIMESTAMP,
  "PERIOD3_MODE" VARCHAR(100),
  "PERIOD3_PARAM" VARCHAR(100),
  "PERIOD3_DATE" TIMESTAMP,
  "PERIOD4_MODE" VARCHAR(100),
  "PERIOD4_PARAM" VARCHAR(100),
  "PERIOD4_DATE" TIMESTAMP,
  "PERIOD5_MODE" VARCHAR(100),
  "PERIOD5_PARAM" VARCHAR(100),
  "PERIOD5_DATE" TIMESTAMP
);

CREATE TABLE "SCHEMA_MIGRATIONS" (
"VERSION" VARCHAR(256) NOT NULL
);

CREATE TABLE "GROUP_ROLES" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "GROUP_ID" INTEGER,
  "RESOURCE_ID" INTEGER,
  "ROLE" VARCHAR(64) NOT NULL
);

CREATE TABLE "RULES" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "PLUGIN_RULE_KEY" VARCHAR(200) NOT NULL,
  "PLUGIN_NAME" VARCHAR(255) NOT NULL,
  "DESCRIPTION" VARCHAR(16777215),
  "PRIORITY" INTEGER,
  "CARDINALITY" VARCHAR(10),
  "PARENT_ID" INTEGER,
  "PLUGIN_CONFIG_KEY" VARCHAR(500),
  "NAME" VARCHAR(200),
  "STATUS" VARCHAR(40),
  "LANGUAGE" VARCHAR(20),
  "CREATED_AT" TIMESTAMP,
  "UPDATED_AT" TIMESTAMP,
  "NOTE_CREATED_AT" TIMESTAMP,
  "NOTE_UPDATED_AT" TIMESTAMP,
  "NOTE_USER_LOGIN" VARCHAR(40),
  "NOTE_DATA" CLOB(2147483647)
);

CREATE TABLE "WIDGET_PROPERTIES" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "WIDGET_ID" INTEGER NOT NULL,
  "KEE" VARCHAR(100),
  "TEXT_VALUE" VARCHAR(4000)
);

CREATE TABLE "EVENTS" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "NAME" VARCHAR(400),
  "RESOURCE_ID" INTEGER,
  "SNAPSHOT_ID" INTEGER,
  "CATEGORY" VARCHAR(50),
  "EVENT_DATE" TIMESTAMP,
  "CREATED_AT" TIMESTAMP,
  "DESCRIPTION" VARCHAR(4000)
);

CREATE TABLE "ALERTS" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "PROFILE_ID" INTEGER,
  "METRIC_ID" INTEGER,
  "OPERATOR" VARCHAR(3),
  "VALUE_ERROR" VARCHAR(64),
  "VALUE_WARNING" VARCHAR(64),
  "PERIOD" INTEGER,
);

CREATE TABLE "PROPERTIES" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "PROP_KEY" VARCHAR(512),
  "RESOURCE_ID" INTEGER,
  "TEXT_VALUE" CLOB(2147483647),
  "USER_ID" INTEGER
);

CREATE TABLE "PROJECT_LINKS" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "PROJECT_ID" INTEGER NOT NULL,
  "LINK_TYPE" VARCHAR(20),
  "NAME" VARCHAR(128),
  "HREF" VARCHAR(2048) NOT NULL
);

CREATE TABLE "DUPLICATIONS_INDEX" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "PROJECT_SNAPSHOT_ID" INTEGER NOT NULL,
  "SNAPSHOT_ID" INTEGER NOT NULL,
  "HASH" VARCHAR(50) NOT NULL,
  "INDEX_IN_FILE" INTEGER NOT NULL,
  "START_LINE" INTEGER NOT NULL,
  "END_LINE" INTEGER NOT NULL
);

CREATE TABLE "ACTIVE_RULE_CHANGES" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "USERNAME" VARCHAR(200),
  "PROFILE_ID" INTEGER NOT NULL,
  "PROFILE_VERSION" INTEGER NOT NULL,
  "RULE_ID" INTEGER NOT NULL,
  "CHANGE_DATE" TIMESTAMP NOT NULL,
  "ENABLED" BOOLEAN,
  "OLD_SEVERITY" INTEGER,
  "NEW_SEVERITY" INTEGER
);

CREATE TABLE "PROJECT_MEASURES" (
  "ID" BIGINT NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "VALUE" DOUBLE,
  "METRIC_ID" INTEGER NOT NULL,
  "SNAPSHOT_ID" INTEGER,
  "RULE_ID" INTEGER,
  "RULES_CATEGORY_ID" INTEGER,
  "TEXT_VALUE" VARCHAR(96),
  "TENDENCY" INTEGER,
  "MEASURE_DATE" TIMESTAMP,
  "PROJECT_ID" INTEGER,
  "ALERT_STATUS" VARCHAR(5),
  "ALERT_TEXT" VARCHAR(4000),
  "URL" VARCHAR(2000),
  "DESCRIPTION" VARCHAR(4000),
  "RULE_PRIORITY" INTEGER,
  "CHARACTERISTIC_ID" INTEGER,
  "PERSON_ID" INTEGER,
  "VARIATION_VALUE_1" DOUBLE,
  "VARIATION_VALUE_2" DOUBLE,
  "VARIATION_VALUE_3" DOUBLE,
  "VARIATION_VALUE_4" DOUBLE,
  "VARIATION_VALUE_5" DOUBLE
);

CREATE TABLE "SNAPSHOT_SOURCES" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "SNAPSHOT_ID" INTEGER NOT NULL,
  "DATA" CLOB(2147483647)
);

CREATE TABLE "PROJECTS" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "NAME" VARCHAR(256),
  "DESCRIPTION" VARCHAR(2000),
  "ENABLED" BOOLEAN NOT NULL DEFAULT TRUE,
  "SCOPE" VARCHAR(3),
  "QUALIFIER" VARCHAR(10),
  "KEE" VARCHAR(400),
  "PATH" VARCHAR(2000),
  "ROOT_ID" INTEGER,
  "LANGUAGE" VARCHAR(20),
  "COPY_RESOURCE_ID" INTEGER,
  "LONG_NAME" VARCHAR(256),
  "PERSON_ID" INTEGER,
  "CREATED_AT" TIMESTAMP
);

CREATE TABLE "MANUAL_MEASURES" (
  "ID" BIGINT NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "METRIC_ID" INTEGER NOT NULL,
  "RESOURCE_ID" INTEGER,
  "VALUE" DOUBLE,
  "TEXT_VALUE" VARCHAR(4000),
  "USER_LOGIN" VARCHAR(40),
  "DESCRIPTION" VARCHAR(4000),
  "CREATED_AT" TIMESTAMP,
  "UPDATED_AT" TIMESTAMP
);

CREATE TABLE "ACTIVE_RULES" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "PROFILE_ID" INTEGER NOT NULL,
  "RULE_ID" INTEGER NOT NULL,
  "FAILURE_LEVEL" INTEGER NOT NULL,
  "INHERITANCE" VARCHAR(10),
  "NOTE_CREATED_AT" TIMESTAMP,
  "NOTE_UPDATED_AT" TIMESTAMP,
  "NOTE_USER_LOGIN" VARCHAR(40),
  "NOTE_DATA" CLOB(2147483647)
);

CREATE TABLE "NOTIFICATIONS" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "DATA" BINARY(167772150)
);

CREATE TABLE "USER_ROLES" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "USER_ID" INTEGER,
  "RESOURCE_ID" INTEGER,
  "ROLE" VARCHAR(64) NOT NULL
);

CREATE TABLE "ACTIVE_DASHBOARDS" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "DASHBOARD_ID" INTEGER NOT NULL,
  "USER_ID" INTEGER,
  "ORDER_INDEX" INTEGER
);

CREATE TABLE "ACTIVE_RULE_PARAMETERS" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "ACTIVE_RULE_ID" INTEGER NOT NULL,
  "RULES_PARAMETER_ID" INTEGER NOT NULL,
  "RULES_PARAMETER_KEY" VARCHAR(128),
  "VALUE" VARCHAR(4000)
);

CREATE TABLE "USERS" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "LOGIN" VARCHAR(40),
  "NAME" VARCHAR(200),
  "EMAIL" VARCHAR(100),
  "CRYPTED_PASSWORD" VARCHAR(40),
  "SALT" VARCHAR(40),
  "CREATED_AT" TIMESTAMP,
  "UPDATED_AT" TIMESTAMP,
  "REMEMBER_TOKEN" VARCHAR(500),
  "REMEMBER_TOKEN_EXPIRES_AT" TIMESTAMP,
  "ACTIVE" BOOLEAN DEFAULT TRUE
);

CREATE TABLE "DASHBOARDS" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "USER_ID" INTEGER,
  "NAME" VARCHAR(256),
  "DESCRIPTION" VARCHAR(1000),
  "COLUMN_LAYOUT" VARCHAR(20),
  "SHARED" BOOLEAN,
  "IS_GLOBAL" BOOLEAN,
  "CREATED_AT" TIMESTAMP,
  "UPDATED_AT" TIMESTAMP
);

CREATE TABLE "METRICS" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "NAME" VARCHAR(64) NOT NULL,
  "DESCRIPTION" VARCHAR(255),
  "DIRECTION" INTEGER NOT NULL DEFAULT 0,
  "DOMAIN" VARCHAR(64),
  "SHORT_NAME" VARCHAR(64),
  "QUALITATIVE" BOOLEAN NOT NULL DEFAULT FALSE,
  "VAL_TYPE" VARCHAR(8),
  "USER_MANAGED" BOOLEAN DEFAULT FALSE,
  "ENABLED" BOOLEAN DEFAULT TRUE,
  "ORIGIN" VARCHAR(3),
  "WORST_VALUE" DOUBLE,
  "BEST_VALUE" DOUBLE,
  "OPTIMIZED_BEST_VALUE" BOOLEAN,
  "HIDDEN" BOOLEAN,
  "DELETE_HISTORICAL_DATA" BOOLEAN
);

CREATE TABLE "LOADED_TEMPLATES" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "KEE" VARCHAR(200),
  "TEMPLATE_TYPE" VARCHAR(15)
);

CREATE TABLE "RESOURCE_INDEX" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "KEE" VARCHAR(400) NOT NULL,
  "POSITION" INTEGER NOT NULL,
  "NAME_SIZE" INTEGER NOT NULL,
  "RESOURCE_ID" INTEGER NOT NULL,
  "ROOT_PROJECT_ID" INTEGER NOT NULL,
  "QUALIFIER" VARCHAR(10) NOT NULL
);

CREATE TABLE "ACTION_PLANS" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "KEE" VARCHAR(100),
  "NAME" VARCHAR(200),
  "DESCRIPTION" VARCHAR(1000),
  "DEADLINE" TIMESTAMP,
  "USER_LOGIN" VARCHAR(40),
  "PROJECT_ID" INTEGER,
  "STATUS" VARCHAR(10),
  "CREATED_AT" TIMESTAMP,
  "UPDATED_AT" TIMESTAMP
);

CREATE TABLE "ACTIVE_RULE_NOTES" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "ACTIVE_RULE_ID" INTEGER,
  "USER_LOGIN" VARCHAR(40),
  "DATA" CLOB(2147483647),
  "CREATED_AT" TIMESTAMP,
  "UPDATED_AT" TIMESTAMP
);

CREATE TABLE "RULE_NOTES" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "RULE_ID" INTEGER,
  "USER_LOGIN" VARCHAR(40),
  "DATA" CLOB(2147483647),
  "CREATED_AT" TIMESTAMP,
  "UPDATED_AT" TIMESTAMP
);

CREATE TABLE "AUTHORS" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "PERSON_ID" INTEGER,
  "LOGIN" VARCHAR(100),
  "CREATED_AT" TIMESTAMP,
  "UPDATED_AT" TIMESTAMP
);

CREATE TABLE "SEMAPHORES" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "NAME" VARCHAR(4000),
  "CHECKSUM" VARCHAR(200),
  "CREATED_AT" TIMESTAMP,
  "UPDATED_AT" TIMESTAMP,
  "LOCKED_AT" TIMESTAMP
);

CREATE TABLE "MEASURE_FILTERS" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "NAME" VARCHAR(100) NOT NULL,
  "SHARED" BOOLEAN NOT NULL DEFAULT FALSE,
  "USER_ID" INTEGER,
  "DESCRIPTION" VARCHAR(4000),
  "DATA" CLOB(2147483647),
  "CREATED_AT" TIMESTAMP,
  "UPDATED_AT" TIMESTAMP
);

CREATE TABLE "MEASURE_FILTER_FAVOURITES" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "USER_ID" INTEGER NOT NULL,
  "MEASURE_FILTER_ID" INTEGER NOT NULL,
  "CREATED_AT" TIMESTAMP
);

CREATE TABLE "GRAPHS" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "RESOURCE_ID" INTEGER NOT NULL,
  "SNAPSHOT_ID" INTEGER NOT NULL,
  "FORMAT" VARCHAR(20),
  "PERSPECTIVE" VARCHAR(30),
  "VERSION" VARCHAR(20),
  "ROOT_VERTEX_ID" VARCHAR(30),
  "DATA" CLOB(2147483647),
  "CREATED_AT" TIMESTAMP,
  "UPDATED_AT" TIMESTAMP
);

CREATE TABLE "ISSUES" (
  "ID" BIGINT NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "KEE" VARCHAR(50) UNIQUE NOT NULL,
  "COMPONENT_ID" INTEGER NOT NULL,
  "ROOT_COMPONENT_ID" INTEGER,
  "RULE_ID" INTEGER,
  "SEVERITY" VARCHAR(10),
  "MANUAL_SEVERITY" BOOLEAN NOT NULL,
  "MESSAGE" VARCHAR(4000),
  "LINE" INTEGER,
  "EFFORT_TO_FIX" DOUBLE,
  "TECHNICAL_DEBT" INTEGER,
  "STATUS" VARCHAR(20),
  "RESOLUTION" VARCHAR(20),
  "CHECKSUM" VARCHAR(1000),
  "REPORTER" VARCHAR(40),
  "ASSIGNEE" VARCHAR(40),
  "AUTHOR_LOGIN" VARCHAR(100),
  "ACTION_PLAN_KEY" VARCHAR(50) NULL,
  "ISSUE_ATTRIBUTES" VARCHAR(4000),
  "ISSUE_CREATION_DATE" TIMESTAMP,
  "ISSUE_CLOSE_DATE" TIMESTAMP,
  "ISSUE_UPDATE_DATE" TIMESTAMP,
  "CREATED_AT" TIMESTAMP,
  "UPDATED_AT" TIMESTAMP
);

CREATE TABLE "ISSUE_CHANGES" (
  "ID" BIGINT NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "KEE" VARCHAR(50),
  "ISSUE_KEY" VARCHAR(50) NOT NULL,
  "USER_LOGIN" VARCHAR(40),
  "CHANGE_TYPE" VARCHAR(40),
  "CHANGE_DATA"  VARCHAR(16777215),
  "CREATED_AT" TIMESTAMP,
  "UPDATED_AT" TIMESTAMP,
);

CREATE TABLE "ISSUE_FILTERS" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "NAME" VARCHAR(100) NOT NULL,
  "SHARED" BOOLEAN NOT NULL DEFAULT FALSE,
  "USER_LOGIN" VARCHAR(40),
  "DESCRIPTION" VARCHAR(4000),
  "DATA" CLOB(2147483647),
  "CREATED_AT" TIMESTAMP,
  "UPDATED_AT" TIMESTAMP
);

CREATE TABLE "ISSUE_FILTER_FAVOURITES" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "USER_LOGIN" VARCHAR(40)  NOT NULL,
  "ISSUE_FILTER_ID" INTEGER NOT NULL,
  "CREATED_AT" TIMESTAMP
);

CREATE TABLE "SNAPSHOT_DATA" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "SNAPSHOT_ID" INTEGER,
  "RESOURCE_ID" INTEGER,
  "SNAPSHOT_DATA" VARCHAR(16777215),
  "DATA_TYPE" VARCHAR(50),
  "CREATED_AT" TIMESTAMP,
  "UPDATED_AT" TIMESTAMP,
);

CREATE TABLE "PERMISSION_TEMPLATES" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "NAME" VARCHAR(100) NOT NULL,
  "KEE" VARCHAR(100) NOT NULL,
  "DESCRIPTION" VARCHAR(4000),
  "KEY_PATTERN" VARCHAR(500),
  "CREATED_AT" TIMESTAMP,
  "UPDATED_AT" TIMESTAMP
);

CREATE TABLE "PERM_TEMPLATES_USERS" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "USER_ID" INTEGER NOT NULL,
  "TEMPLATE_ID" INTEGER NOT NULL,
  "PERMISSION_REFERENCE" VARCHAR(64) NOT NULL,
  "CREATED_AT" TIMESTAMP,
  "UPDATED_AT" TIMESTAMP
);

CREATE TABLE "PERM_TEMPLATES_GROUPS" (
  "ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1, INCREMENT BY 1),
  "GROUP_ID" INTEGER,
  "TEMPLATE_ID" INTEGER NOT NULL,
  "PERMISSION_REFERENCE" VARCHAR(64) NOT NULL,
  "CREATED_AT" TIMESTAMP,
  "UPDATED_AT" TIMESTAMP
);

-- ----------------------------------------------
-- DDL Statements for indexes
-- ----------------------------------------------

CREATE INDEX "GROUP_ROLES_RESOURCE" ON "GROUP_ROLES" ("RESOURCE_ID");

CREATE INDEX "GROUP_ROLES_GROUP" ON "GROUP_ROLES" ("GROUP_ID");

CREATE INDEX "USER_ROLES_RESOURCE" ON "USER_ROLES" ("RESOURCE_ID");

CREATE INDEX "USER_ROLES_USER" ON "USER_ROLES" ("USER_ID");

CREATE INDEX "DUPLICATIONS_INDEX_HASH" ON "DUPLICATIONS_INDEX" ("HASH");

CREATE INDEX "DUPLICATIONS_INDEX_SID" ON "DUPLICATIONS_INDEX" ("SNAPSHOT_ID");

CREATE INDEX "DUPLICATIONS_INDEX_PSID" ON "DUPLICATIONS_INDEX" ("PROJECT_SNAPSHOT_ID");

CREATE INDEX "SNAP_SOURCES_SNAPSHOT_ID" ON "SNAPSHOT_SOURCES" ("SNAPSHOT_ID");

CREATE INDEX "INDEX_GROUPS_USERS_ON_GROUP_ID" ON "GROUPS_USERS" ("GROUP_ID");

CREATE INDEX "INDEX_GROUPS_USERS_ON_USER_ID" ON "GROUPS_USERS" ("USER_ID");

CREATE UNIQUE INDEX "GROUPS_USERS_UNIQUE" ON "GROUPS_USERS" ("GROUP_ID", "USER_ID");

CREATE INDEX "DEPS_TO_SID" ON "DEPENDENCIES" ("TO_SNAPSHOT_ID");

CREATE INDEX "DEPS_FROM_SID" ON "DEPENDENCIES" ("FROM_SNAPSHOT_ID");

CREATE INDEX "DEPS_PRJ_SID" ON "DEPENDENCIES" ("PROJECT_SNAPSHOT_ID");

CREATE INDEX "MEASURES_SID_METRIC" ON "PROJECT_MEASURES" ("SNAPSHOT_ID", "METRIC_ID");

CREATE INDEX "ACTIVE_RULE_CHANGES_PID" ON "ACTIVE_RULE_CHANGES" ("PROFILE_ID");

CREATE UNIQUE INDEX "METRICS_UNIQUE_NAME" ON "METRICS" ("NAME");

CREATE INDEX "ACTIVE_RULE_PARAM_CHANGES_CID" ON "ACTIVE_RULE_PARAM_CHANGES" ("ACTIVE_RULE_CHANGE_ID");

CREATE INDEX "M_DATA_SID" ON "MEASURE_DATA" ("SNAPSHOT_ID");

CREATE INDEX "MEASURE_DATA_MEASURE_ID" ON "MEASURE_DATA" ("MEASURE_ID");

CREATE INDEX "EVENTS_SNAPSHOT_ID" ON "EVENTS" ("SNAPSHOT_ID");

CREATE INDEX "EVENTS_RESOURCE_ID" ON "EVENTS" ("RESOURCE_ID");

CREATE INDEX "WIDGETS_WIDGETKEY" ON "WIDGETS" ("WIDGET_KEY");

CREATE INDEX "WIDGETS_DASHBOARDS" ON "WIDGETS" ("DASHBOARD_ID");

CREATE INDEX "SNAPSHOTS_QUALIFIER" ON "SNAPSHOTS" ("QUALIFIER");

CREATE INDEX "SNAPSHOTS_ROOT" ON "SNAPSHOTS" ("ROOT_SNAPSHOT_ID");

CREATE INDEX "SNAPSHOTS_PARENT" ON "SNAPSHOTS" ("PARENT_SNAPSHOT_ID");

CREATE INDEX "SNAPSHOT_PROJECT_ID" ON "SNAPSHOTS" ("PROJECT_ID");

CREATE INDEX "RULES_PARAMETERS_RULE_ID" ON "RULES_PARAMETERS" ("RULE_ID");

CREATE INDEX "ACTIVE_DASHBOARDS_DASHBOARDID" ON "ACTIVE_DASHBOARDS" ("DASHBOARD_ID");

CREATE INDEX "ACTIVE_DASHBOARDS_USERID" ON "ACTIVE_DASHBOARDS" ("USER_ID");

CREATE INDEX "UNIQUE_SCHEMA_MIGRATIONS" ON "SCHEMA_MIGRATIONS" ("VERSION");

CREATE INDEX "WIDGET_PROPERTIES_WIDGETS" ON "WIDGET_PROPERTIES" ("WIDGET_ID");

CREATE INDEX "PROPERTIES_KEY" ON "PROPERTIES" ("PROP_KEY");

CREATE INDEX "MANUAL_MEASURES_RESOURCE_ID" ON "MANUAL_MEASURES" ("RESOURCE_ID");

CREATE INDEX "PROJECTS_KEE" ON "PROJECTS" ("KEE");

CREATE INDEX "PROJECTS_ROOT_ID" ON "PROJECTS" ("ROOT_ID");

CREATE INDEX "RESOURCE_INDEX_KEE" ON "RESOURCE_INDEX" ("KEE");

CREATE INDEX "RESOURCE_INDEX_RID" ON "RESOURCE_INDEX" ("RESOURCE_ID");

CREATE INDEX "INDEX_ACTION_PLANS_ON_PROJET_ID" ON "ACTION_PLANS" ("PROJECT_ID");

CREATE INDEX "INDEX_ACTIVE_RULE_NOTES_ON_ACTIVE_RULE_ID" ON "ACTIVE_RULE_NOTES" ("ACTIVE_RULE_ID");

CREATE INDEX "INDEX_RULE_NOTES_ON_ACTIVE_RULE_ID" ON "RULE_NOTES" ("RULE_ID");

CREATE UNIQUE INDEX "UNIQ_SEMAPHORE_CHECKSUMS" ON "SEMAPHORES" ("CHECKSUM");

CREATE INDEX "SEMAPHORE_NAMES" ON "SEMAPHORES" ("NAME");

CREATE UNIQUE INDEX "UNIQ_AUTHOR_LOGINS" ON "AUTHORS" ("LOGIN");

CREATE INDEX "MEASURE_FILTERS_NAME" ON "MEASURE_FILTERS" ("NAME");

CREATE INDEX "MEASURE_FILTER_FAVS_USERID" ON "MEASURE_FILTER_FAVOURITES" ("USER_ID");

CREATE UNIQUE INDEX "GRAPHS_PERSPECTIVES" ON "GRAPHS" ("SNAPSHOT_ID", "PERSPECTIVE");

CREATE UNIQUE INDEX "ISSUES_KEE" ON "ISSUES" ("KEE");

CREATE INDEX "ISSUES_COMPONENT_ID" ON "ISSUES" ("COMPONENT_ID");

CREATE INDEX "ISSUES_ROOT_COMPONENT_ID" ON "ISSUES" ("ROOT_COMPONENT_ID");

CREATE INDEX "ISSUES_RULE_ID" ON "ISSUES" ("RULE_ID");

CREATE INDEX "ISSUES_SEVERITY" ON "ISSUES" ("SEVERITY");

CREATE INDEX "ISSUES_STATUS" ON "ISSUES" ("STATUS");

CREATE INDEX "ISSUES_RESOLUTION" ON "ISSUES" ("RESOLUTION");

CREATE INDEX "ISSUES_ASSIGNEE" ON "ISSUES" ("ASSIGNEE");

CREATE INDEX "ISSUES_ACTION_PLAN_KEY" ON "ISSUES" ("ACTION_PLAN_KEY");

CREATE INDEX "ISSUES_CREATION_DATE" ON "ISSUES" ("ISSUE_CREATION_DATE");

CREATE INDEX "ISSUE_CHANGES_KEE" ON "ISSUE_CHANGES" ("KEE");

CREATE INDEX "ISSUE_CHANGES_ISSUE_KEY" ON "ISSUE_CHANGES" ("ISSUE_KEY");

CREATE INDEX "ISSUE_FILTERS_NAME" ON "ISSUE_FILTERS" ("NAME");

CREATE INDEX "ISSUE_FILTER_FAVS_USER" ON "ISSUE_FILTER_FAVOURITES" ("USER_LOGIN");

CREATE UNIQUE INDEX "USERS_LOGIN" ON "USERS" ("LOGIN");

CREATE INDEX "SNAPSHOTS_ROOT_PROJECT_ID" ON "SNAPSHOTS" ("ROOT_PROJECT_ID");

CREATE INDEX "GROUP_ROLES_ROLE" ON "GROUP_ROLES" ("ROLE");

CREATE UNIQUE INDEX "GROUP_ROLES_UNIQUE" ON "GROUP_ROLES" ("GROUP_ID", "RESOURCE_ID", "ROLE");

CREATE UNIQUE INDEX "RULES_PLUGIN_KEY_AND_NAME" ON "RULES" ("PLUGIN_RULE_KEY", "PLUGIN_NAME");

CREATE INDEX "CHARACTERISTICS_ENABLED" ON "CHARACTERISTICS" ("ENABLED");

/*
 * SonarQube, open source software quality management tool.
 * Copyright (C) 2008-2013 SonarSource
 * mailto:contact AT sonarsource DOT com
 *
 * SonarQube is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 3 of the License, or (at your option) any later version.
 *
 * SonarQube is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */
package org.sonar.batch.phases;

import com.google.common.collect.Lists;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sonar.api.BatchComponent;
import org.sonar.api.batch.Sensor;
import org.sonar.api.batch.SensorContext;
import org.sonar.api.batch.maven.DependsUponMavenPlugin;
import org.sonar.api.batch.maven.MavenPluginHandler;
import org.sonar.api.database.DatabaseSession;
import org.sonar.api.resources.Java;
import org.sonar.api.resources.JavaFile;
import org.sonar.api.resources.Languages;
import org.sonar.api.resources.ModuleLanguages;
import org.sonar.api.resources.Project;
import org.sonar.api.scan.filesystem.FileQuery;
import org.sonar.api.utils.TimeProfiler;
import org.sonar.batch.bootstrap.BatchExtensionDictionnary;
import org.sonar.batch.events.EventBus;
import org.sonar.batch.scan.filesystem.DefaultModuleFileSystem;
import org.sonar.batch.scan.maven.MavenPluginExecutor;

import java.io.File;
import java.util.Collection;

public class SensorsExecutor implements BatchComponent {
  private static final Logger LOG = LoggerFactory.getLogger(SensorsExecutor.class);

  private MavenPluginExecutor mavenExecutor;
  private EventBus eventBus;
  private Project module;
  private DefaultModuleFileSystem fs;
  private BatchExtensionDictionnary selector;
  private final DatabaseSession session;
  private final SensorMatcher sensorMatcher;

  private ModuleInitializer moduleInitializer;

  private ModuleLanguages moduleLanguages;

  private Languages languages;

  public SensorsExecutor(BatchExtensionDictionnary selector, Project module, DefaultModuleFileSystem fs, MavenPluginExecutor mavenExecutor, EventBus eventBus,
    DatabaseSession session, SensorMatcher sensorMatcher,
    ModuleInitializer moduleInitializer, ModuleLanguages moduleLanguages, Languages languages) {
    this.selector = selector;
    this.mavenExecutor = mavenExecutor;
    this.eventBus = eventBus;
    this.module = module;
    this.fs = fs;
    this.session = session;
    this.sensorMatcher = sensorMatcher;
    this.moduleInitializer = moduleInitializer;
    this.moduleLanguages = moduleLanguages;
    this.languages = languages;
  }

  public void execute(SensorContext context) {
    Collection<Sensor> sensors = selector.select(Sensor.class, true, sensorMatcher);
    eventBus.fireEvent(new SensorsPhaseEvent(Lists.newArrayList(sensors), true));

    for (String languageKey : moduleLanguages.getModuleLanguageKeys()) {
      for (File f : fs.files(FileQuery.onSource().onLanguage(languageKey))) {
        if (Java.KEY.equals(languageKey)) {
          JavaFile sonarFile = JavaFile.fromIOFile(f, module, false);
          context.index(sonarFile);
        } else {
          org.sonar.api.resources.File sonarFile = org.sonar.api.resources.File.fromIOFile(f, module);
          sonarFile.setLanguage(languages.get(languageKey));
          context.index(sonarFile);
        }
      }
      for (File f : fs.files(FileQuery.onTest().onLanguage(languageKey))) {
        if (Java.KEY.equals(languageKey)) {
          JavaFile sonarFile = JavaFile.fromIOFile(f, module, true);
          context.index(sonarFile);
        } else {
          org.sonar.api.resources.File sonarFile = org.sonar.api.resources.File.fromIOFile(f, module);
          sonarFile.setLanguage(languages.get(languageKey));
          context.index(sonarFile);
        }
      }
    }

    for (Sensor sensor : sensors) {

      for (String language : moduleLanguages.getModuleLanguageKeys()) {
        moduleInitializer.initLanguage(module, language);
        if (sensor.shouldExecuteOnProject(module)) {
          // SONAR-2965 In case the sensor takes too much time we close the session to not face a timeout
          session.commitAndClose();

          eventBus.fireEvent(new SensorExecutionEvent(sensor, true));
          executeMavenPlugin(sensor);
          sensor.analyse(module, context);
          eventBus.fireEvent(new SensorExecutionEvent(sensor, false));
          break;
        }
      }
    }

    eventBus.fireEvent(new SensorsPhaseEvent(Lists.newArrayList(sensors), false));
  }

  private void executeMavenPlugin(Sensor sensor) {
    if (sensor instanceof DependsUponMavenPlugin) {
      MavenPluginHandler handler = ((DependsUponMavenPlugin) sensor).getMavenPluginHandler(module);
      if (handler != null) {
        TimeProfiler profiler = new TimeProfiler(LOG).start("Execute maven plugin " + handler.getArtifactId());
        mavenExecutor.execute(module, fs, handler);
        profiler.stop();
      }
    }
  }
}

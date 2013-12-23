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
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sonar.api.batch.BatchExtensionDictionnary;
import org.sonar.api.batch.Initializer;
import org.sonar.api.batch.maven.DependsUponMavenPlugin;
import org.sonar.api.batch.maven.MavenPluginHandler;
import org.sonar.api.resources.ModuleLanguages;
import org.sonar.api.resources.Project;
import org.sonar.api.utils.TimeProfiler;
import org.sonar.batch.events.EventBus;
import org.sonar.batch.scan.filesystem.DefaultModuleFileSystem;
import org.sonar.batch.scan.maven.MavenPluginExecutor;

import java.util.Collection;

public class InitializersExecutor {

  private static final Logger LOG = LoggerFactory.getLogger(SensorsExecutor.class);

  private MavenPluginExecutor mavenExecutor;

  private DefaultModuleFileSystem fs;
  private Project module;
  private BatchExtensionDictionnary selector;
  private EventBus eventBus;

  private ModuleInitializer moduleInitializer;

  private ModuleLanguages languages;

  public InitializersExecutor(BatchExtensionDictionnary selector, Project module, DefaultModuleFileSystem fs, MavenPluginExecutor mavenExecutor, EventBus eventBus,
    ModuleInitializer moduleInitializer, ModuleLanguages languages) {
    this.selector = selector;
    this.mavenExecutor = mavenExecutor;
    this.module = module;
    this.fs = fs;
    this.eventBus = eventBus;
    this.moduleInitializer = moduleInitializer;
    this.languages = languages;
  }

  public void execute() {
    Collection<Initializer> initializers = selector.select(Initializer.class, module, true);
    eventBus.fireEvent(new InitializersPhaseEvent(Lists.newArrayList(initializers), true));
    if (LOG.isDebugEnabled()) {
      LOG.debug("Initializers : {}", StringUtils.join(initializers, " -> "));
    }

    for (Initializer initializer : initializers) {
      for (String language : languages.getModuleLanguageKeys()) {
        moduleInitializer.initLanguage(module, language);
        if (initializer.shouldExecuteOnProject(module)) {
          eventBus.fireEvent(new InitializerExecutionEvent(initializer, true));
          executeMavenPlugin(initializer);

          TimeProfiler profiler = new TimeProfiler(LOG).start("Initializer " + initializer);
          initializer.execute(module);
          profiler.stop();
          eventBus.fireEvent(new InitializerExecutionEvent(initializer, false));
          break;
        }
      }
    }

    if (!initializers.isEmpty()) {
      fs.index();
    }

    eventBus.fireEvent(new InitializersPhaseEvent(Lists.newArrayList(initializers), false));
  }

  private void executeMavenPlugin(Initializer sensor) {
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

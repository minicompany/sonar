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
package org.sonar.api.resources;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sonar.api.BatchExtension;
import org.sonar.api.CoreProperties;
import org.sonar.api.config.Settings;
import org.sonar.api.scan.filesystem.FileQuery;
import org.sonar.api.scan.filesystem.ModuleFileSystem;
import org.sonar.api.scan.filesystem.internal.InputFile;

import java.util.HashSet;
import java.util.Set;

/**
 *
 * @since 4.2
 *
 */
public class ModuleLanguages implements BatchExtension {

  private static final Logger LOG = LoggerFactory.getLogger(ModuleLanguages.class);

  private ModuleFileSystem fs;
  private Set<String> languages;
  private boolean multilanguage;
  private String originalLanguageKey;

  private Settings settings;

  public ModuleLanguages(ModuleFileSystem fs, Settings settings) {
    this.fs = fs;
    this.settings = settings;
  }

  public void start() {
    originalLanguageKey = settings.getString("sonar.language");
    languages = new HashSet<String>();
    if (CoreProperties.MULTI_LANGUAGE_KEY.equals(originalLanguageKey)) {
      LOG.info("Multi-language module");
      multilanguage = true;
      Iterable<InputFile> allFiles = fs.inputFiles(FileQuery.all());
      for (InputFile inputFile : allFiles) {
        languages.add(inputFile.attribute(InputFile.ATTRIBUTE_LANGUAGE));
      }
    } else {
      multilanguage = false;
      languages.add(originalLanguageKey);
    }
  }

  public Set<String> getModuleLanguageKeys() {
    return languages;
  }

  public boolean isMultilanguage() {
    return multilanguage;
  }

  public String getOriginalLanguageKey() {
    return originalLanguageKey;
  }

}

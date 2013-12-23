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

import org.sonar.api.BatchComponent;
import org.sonar.api.resources.Language;
import org.sonar.api.resources.Languages;
import org.sonar.api.resources.Project;
import org.sonar.api.utils.SonarException;
import org.sonar.core.resource.ResourceDao;
import org.sonar.core.resource.ResourceDto;

/**
 * Should be dropped when org.sonar.api.resources.Project is fully refactored.
 */
public class ModuleInitializer implements BatchComponent {

  private ResourceDao resourceDao;
  private Languages languages;

  public ModuleInitializer(ResourceDao resourceDao, Languages languages) {
    this.resourceDao = resourceDao;
    this.languages = languages;
  }

  public void saveLanguageInDB(Project project) {
    if (project.getId() != null) {
      ResourceDto dto = resourceDao.getResource(project.getId());
      dto.setLanguage(project.getLanguageKey());
      resourceDao.insertOrUpdate(dto);
    }
  }

  public void initLanguage(Project module, String languageKey) {
    module.getConfiguration().setProperty("sonar.language", languageKey);
    Language language = languages.get(languageKey);
    if (language == null) {
      throw new SonarException("Language with key '" + languageKey + "' not found");
    }
    module.setLanguage(language);
  }
}

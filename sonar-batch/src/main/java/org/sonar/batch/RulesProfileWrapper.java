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
package org.sonar.batch;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sonar.api.CoreProperties;
import org.sonar.api.profiles.Alert;
import org.sonar.api.profiles.RulesProfile;
import org.sonar.api.resources.Project;
import org.sonar.api.rules.ActiveRule;
import org.sonar.api.rules.Rule;
import org.sonar.api.utils.SonarException;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class RulesProfileWrapper extends RulesProfile {

  private static final Logger LOG = LoggerFactory.getLogger(RulesProfileWrapper.class);

  private final Project module;
  private final Map<String, RulesProfile> ruleProfilesPerLanguages;

  public RulesProfileWrapper(Project module, Map<String, RulesProfile> ruleProfilesPerLanguages) {
    this.module = module;
    this.ruleProfilesPerLanguages = ruleProfilesPerLanguages;
  }

  @Override
  public Integer getId() {
    logWarning();
    return getWrappedProfile().getId();
  }

  private RulesProfile getWrappedProfile() {
    RulesProfile profile = ruleProfilesPerLanguages.get(module.getLanguageKey());
    if (profile == null) {
      // This means that the current language is not supported by any installed plugin, otherwise at least a
      // "Default <Language Name>" profile would have been created by ActivateDefaultProfiles class.
      String msg = "You must install a plugin that supports the language key '" + module.getLanguageKey() + "'.";
      if (!LOG.isDebugEnabled()) {
        msg += " Run analysis in verbose mode to see list of available language keys.";
      } else {
        msg += " See analysis log for a list of available language keys.";
      }
      throw new SonarException(msg);
    }
    return profile;
  }

  private void logWarning() {
    // try {
    // throw new RuntimeException("RulesProfile should no more be injected as IoC dependency.");
    // } catch (Exception e) {
    // LOG.warn("RulesProfile should no more be injected as IoC dependency.", e);
    // }
  }

  @Override
  public String getName() {
    logWarning();
    return getWrappedProfile().getName();
  }

  @Override
  public String getLanguage() {
    logWarning();
    return getWrappedProfile().getLanguage();
  }

  @Override
  public List<Alert> getAlerts() {
    logWarning();
    return getWrappedProfile().getAlerts();
  }

  @Override
  public List<ActiveRule> getActiveRules() {
    logWarning();
    return getWrappedProfile().getActiveRules();
  }

  @Override
  public int getVersion() {
    logWarning();
    return getWrappedProfile().getVersion();
  }

  @Override
  public ActiveRule getActiveRule(String repositoryKey, String ruleKey) {
    logWarning();
    return getWrappedProfile().getActiveRule(repositoryKey, ruleKey);
  }

  @Override
  public List<ActiveRule> getActiveRulesByRepository(String repositoryKey) {
    logWarning();
    if (CoreProperties.MULTI_LANGUAGE_KEY.equals(module.getLanguageKey())) {
      List<ActiveRule> result = new ArrayList<ActiveRule>();
      for (Map.Entry<String, RulesProfile> entry : ruleProfilesPerLanguages.entrySet()) {
        result.addAll(entry.getValue().getActiveRulesByRepository(repositoryKey));
      }
      return result;
    }
    return getWrappedProfile().getActiveRulesByRepository(repositoryKey);
  }

  @Override
  public List<ActiveRule> getActiveRules(boolean acceptDisabledRules) {
    logWarning();
    if (CoreProperties.MULTI_LANGUAGE_KEY.equals(module.getLanguageKey())) {
      List<ActiveRule> result = new ArrayList<ActiveRule>();
      for (Map.Entry<String, RulesProfile> entry : ruleProfilesPerLanguages.entrySet()) {
        result.addAll(entry.getValue().getActiveRules(acceptDisabledRules));
      }
      return result;
    }
    return getWrappedProfile().getActiveRules(acceptDisabledRules);
  }

  @Override
  public ActiveRule getActiveRule(Rule rule) {
    logWarning();
    return getWrappedProfile().getActiveRule(rule);
  }

  @Override
  public Boolean getDefaultProfile() {
    logWarning();
    return getWrappedProfile().getDefaultProfile();
  }

}

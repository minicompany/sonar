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

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.builder.ToStringBuilder;

/**
 * A class that represents a Java package in Sonar
 *
 * @since 1.10
 * @deprecated in 4.2 use {@link Directory} even for Java files
 */
public class JavaPackage extends Resource {

  /**
   * Default package name for classes without package definition
   * @deprecated since 4.2 use {@link Directory#ROOT}
   */
  @Deprecated
  public static final String DEFAULT_PACKAGE_NAME = "[default]";

  /**
   * Default constructor
   */
  public JavaPackage() {
    this(null);
  }

  /**
   * Creates a JavaPackage from its key. Will use Directory.ROOT if key is null
   */
  public JavaPackage(String key) {
    if (DEFAULT_PACKAGE_NAME.equals(key)) {
      key = Directory.ROOT;
    }
    setKey(StringUtils.defaultIfEmpty(StringUtils.trim(key), Directory.ROOT));
  }

  /**
   * @return whether the JavaPackage key is the default key
   */
  public boolean isDefault() {
    return StringUtils.equals(getKey(), DEFAULT_PACKAGE_NAME) || StringUtils.equals(getKey(), Directory.ROOT);
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public boolean matchFilePattern(String antPattern) {
    return false;
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public String getDescription() {
    return null;
  }

  /**
   * @return SCOPE_SPACE
   */
  @Override
  public String getScope() {
    return Scopes.DIRECTORY;
  }

  /**
   * @return QUALIFIER_PACKAGE
   */
  @Override
  public String getQualifier() {
    return Qualifiers.DIRECTORY;
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public String getName() {
    return StringUtils.defaultIfBlank(getPath(), getKey());
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public Resource getParent() {
    return null;
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public String getLongName() {
    return null;
  }

  /**
   * @return null
   */
  @Override
  public Language getLanguage() {
    return null;
  }

  @Override
  public String toString() {
    return new ToStringBuilder(this)
      .append("id", getId())
      .append("key", getKey())
      .toString();
  }
}

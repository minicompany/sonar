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
package org.sonar.api.utils;

import java.io.File;
import java.io.IOException;

/**
 * @deprecated since 4.0 use {@link TempFolder}
 */
@Deprecated
public final class TempFileUtils {

  private TempFileUtils() {
    // only static methods
  }

  /**
   * Create a temporary directory. This directory is NOT deleted when the JVM stops, because using File#deleteOnExit()
   * is evil (google "deleteonExit evil"). Copied from http://stackoverflow.com/questions/617414/create-a-temporary-directory-in-java :
   * <ol>
   * <li>deleteOnExit() only deletes for normal JVM shutdowns, not crashes or killing the JVM process</li>
   * <li>deleteOnExit() only deletes on JVM shutdown - not good for long running server processes because 3 :</li>
   * <li>The most evil of all - deleteOnExit() consumes memory for each temp file entry. If your process is running for months,
   * or creates a lot of temp files in a short time, you consume memory and never release it until the JVM
   * shuts down.</li>
   * </ol>
   */
  public static File createTempDirectory() throws IOException {
    return createTempDirectory("temp");
  }

  public static File createTempDirectory(String prefix) throws IOException {
    final File temp = File.createTempFile(prefix, Long.toString(System.nanoTime()));
    if (!temp.delete()) {
      throw new IOException("Could not delete temp file: " + temp.getAbsolutePath());
    }

    if (!temp.mkdir()) {
      throw new IOException("Could not create temp directory: " + temp.getAbsolutePath());
    }
    return temp;
  }
}

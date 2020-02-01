package com.pgjdbc;

import javax.security.auth.login.AppConfigurationEntry;
import javax.security.auth.login.Configuration;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.LogManager;
import java.util.logging.Logger;

public class Main {
  private static final Logger LOGGER = Logger.getLogger(Main.class.getName());

  private static class PGJDBCConfiguration extends Configuration {
    private Configuration parent;
    Map<String, String> options = new HashMap<>();
    AppConfigurationEntry[] entry;

    public PGJDBCConfiguration(Configuration parent, String keytab, String principal) {
      this.parent = parent;

      options.put("useTicketCache", "false");
      options.put("useKeyTab", "true");
      options.put("keyTab", keytab);
      options.put("principal", principal);
      options.put("debug", "true");

      entry = new AppConfigurationEntry[] {
        new AppConfigurationEntry(
          getKrb5LoginModuleName(),
          AppConfigurationEntry.LoginModuleControlFlag.REQUIRED,
          options
        )
      };
    }

    public Configuration getParent() {
      return parent;
    }

    @Override
    public AppConfigurationEntry[] getAppConfigurationEntry(String name) {
      if (name.equals("pgjdbc")) {
        return entry;
      } else {
        return parent.getAppConfigurationEntry(name);
      }
    }
  }

  private static String getKrb5LoginModuleName() {
    if (System.getProperty("java.vendor").contains("IBM")) {
      return "com.ibm.security.auth.module.Krb5LoginModule";
    } else {
      return "com.sun.security.auth.module.Krb5LoginModule";
    }
  }

  private static String IBM_KRB_DEBUG_CONFIG = "com.ibm.security.krb5.Krb5Debug";
  private static String SUN_KRB_DEBUG_CONFIG = "sun.security.krb5.debug";
  private static void setupKrbDebug() {
    LOGGER.info("Setting up kerberos logging...");
    if (System.getProperty("java.vendor").contains("IBM")) {
      System.setProperty(IBM_KRB_DEBUG_CONFIG, "all");
    } else {
      System.setProperty(SUN_KRB_DEBUG_CONFIG, "true");
    }
    LOGGER.info("OK");
  }

  public static void main(String[] args) throws SQLException, IOException {
    final InputStream inputStream = Main.class.getResourceAsStream("/logging.properties");
    LogManager.getLogManager().readConfiguration(inputStream);
    LOGGER.info("pgjdbc-kerberos application started");

    if (args.length != 3) {
      System.out.println("Usage: pgjdbc-kerberos <keytab> <principal> <url>");
      System.out.println("Example: pgjdbc-kerberos share/postgres.keytab postgres/example.com@EXAMPLE.COM jdbc:postgresql://localhost:5432/postgres?user=postgres&gsslib=gssapi");
      System.exit(1);
    }

    setupKrbDebug();

    LOGGER.info("Overwriting JVM configuration...");
    PGJDBCConfiguration config = new PGJDBCConfiguration(Configuration.getConfiguration(), args[0], args[1]);
    Configuration.setConfiguration(config);
    LOGGER.info("OK");

    LOGGER.info("Connecting to JDBC...");
    Connection conn = DriverManager.getConnection(args[2]);
    conn.close();
    LOGGER.info("OK");

    LOGGER.info("Resetting JVM configuration...");
    Configuration.setConfiguration(config.getParent());
    LOGGER.info("OK");
  }
}

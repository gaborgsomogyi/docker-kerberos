package com.oracle;

import oracle.net.ano.AnoServices;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.security.SecurityUtil;
import org.apache.hadoop.security.UserGroupInformation;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.security.PrivilegedExceptionAction;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.logging.LogManager;
import java.util.logging.Logger;

import static org.apache.hadoop.security.UserGroupInformation.AuthenticationMethod.KERBEROS;

public class Main {
  private static final Logger LOGGER = Logger.getLogger(Main.class.getName());

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

  public static void main(String[] args) throws SQLException, IOException, InterruptedException {
    final InputStream inputStream = Main.class.getResourceAsStream("/logging.properties");
    LogManager.getLogManager().readConfiguration(inputStream);
    OutputStreamWriter osw = new OutputStreamWriter(System.out);
    PrintWriter pw = new PrintWriter(osw);
    DriverManager.setLogWriter(pw);
    LOGGER.info("oracle-kerberos application started");

    if (args.length != 3) {
      System.out.println("Usage: oracle-kerberos <keytab> <principal> <url>");
      System.out.println("Example: oracle-kerberos share/oracle.keytab oracle/example.com@EXAMPLE.COM \"jdbc:oracle:thin:@(DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=example.com)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=ORCLCDB.localdomain)))");
      System.exit(1);
    }

    setupKrbDebug();

    Configuration config = new Configuration();
    SecurityUtil.setAuthenticationMethod(KERBEROS, config);
    UserGroupInformation.setConfiguration(config);

    Connection conn = UserGroupInformation.loginUserFromKeytabAndReturnUGI(args[1], args[0]).doAs(
      (PrivilegedExceptionAction<Connection>) () -> {
        LOGGER.info("Connecting to JDBC...");
        Properties properties = new Properties();
        properties.put(AnoServices.AUTHENTICATION_PROPERTY_SERVICES, "(" + AnoServices.AUTHENTICATION_KERBEROS5 + ")");
        Connection connection = DriverManager.getConnection(args[2], properties);
        LOGGER.info("OK");
        return connection;
      }
    );
    conn.close();
  }
}

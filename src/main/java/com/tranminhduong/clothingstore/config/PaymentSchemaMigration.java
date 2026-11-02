package com.tranminhduong.clothingstore.config;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.sql.DataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.context.annotation.DependsOn;
import org.springframework.stereotype.Component;

@Component("paymentSchemaMigration")
@DependsOn("entityManagerFactory")
public class PaymentSchemaMigration implements InitializingBean {

    private static final Logger log = LoggerFactory.getLogger(PaymentSchemaMigration.class);
    private static final String TABLE_NAME = "payments";
    private static final String COLUMN_NAME = "gateway_transaction_no";

    private final DataSource dataSource;

    public PaymentSchemaMigration(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @Override
    public void afterPropertiesSet() throws SQLException {
        try (Connection connection = dataSource.getConnection()) {
            if (columnExists(connection)) {
                return;
            }

            try (Statement statement = connection.createStatement()) {
                statement.executeUpdate(
                        "ALTER TABLE payments ADD COLUMN gateway_transaction_no VARCHAR(100) NULL");
                log.info("Added missing payments.gateway_transaction_no column.");
            } catch (SQLException exception) {
                if (columnExists(connection)) {
                    log.info("payments.gateway_transaction_no was added by another application instance.");
                    return;
                }
                throw exception;
            }
        }
    }

    private boolean columnExists(Connection connection) throws SQLException {
        DatabaseMetaData metadata = connection.getMetaData();
        try (ResultSet tables = metadata.getTables(
                connection.getCatalog(), null, null, new String[] { "TABLE" })) {
            while (tables.next()) {
                if (!TABLE_NAME.equalsIgnoreCase(tables.getString("TABLE_NAME"))) {
                    continue;
                }

                try (ResultSet columns = metadata.getColumns(
                        connection.getCatalog(),
                        tables.getString("TABLE_SCHEM"),
                        tables.getString("TABLE_NAME"),
                        null)) {
                    while (columns.next()) {
                        if (COLUMN_NAME.equalsIgnoreCase(columns.getString("COLUMN_NAME"))) {
                            return true;
                        }
                    }
                }
            }
        }
        return false;
    }
}

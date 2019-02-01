import javafx.application.Application;
import javafx.application.Platform;
import javafx.geometry.Insets;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.layout.GridPane;
import javafx.stage.Stage;

import java.sql.*;
public class Main extends Application {
    protected static Stage mainWindow;
    protected static Connection conn;

    public static void main(String[] args) {
        connectToDatabase();
        launch(args);
    }
    static private void  connectToDatabase() {
        String url = "jdbc:sqlserver://DESKTOP-IPU4241\\SQLEXPRESS:61290;databaseName=Klub;integratedSecurity=true";
        try {
            conn = DriverManager.getConnection(url);
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    @Override
    public void start(Stage primaryStage) {
        mainWindow = primaryStage;

        mainWindow.setScene(LogIn.logInScene());



        mainWindow.setOnCloseRequest(e -> {
            e.consume();
            closeProgram();
        });
        mainWindow.show();


    }

    protected static void closeProgram(){
        boolean storeAnswer = YesOrNoWindow.close("Are you sure you want to close the Application?");
        if(storeAnswer)
            Platform.exit();
    }




}

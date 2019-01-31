import javafx.application.Application;
import javafx.application.Platform;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.StackPane;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;
import java.util.Stack;
import java.sql.*;
public class Main extends Application {
    protected static Stage mainWindow;
    protected static Scene loginScene;
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
        mainWindow.setTitle("Log In");

        GridPane grid = new GridPane();
        grid.setPadding(new Insets(10,10,10,10));
        grid.setVgap(8);
        grid.setHgap(10);

        //Name label:
        Label nameLabel = new Label("Username:");
        GridPane.setConstraints(nameLabel,0,0);

        //Name input
        TextField nameInput = new TextField();
        nameInput.setPromptText("type your email");
        GridPane.setConstraints(nameInput,1,0);

        //Password label:
        Label pswdLabel = new Label("Password:");
        GridPane.setConstraints(pswdLabel,0,1);

        //Password input:
        TextField pswdInput = new TextField("");
        pswdInput.setPromptText("type your personal ID");
        GridPane.setConstraints(pswdInput,1,1);


        Button logInButton = new Button("Sign In");
        GridPane.setConstraints(logInButton,1,2);
        logInButton.setOnAction(e -> checkLoginInput(nameInput.getText(),pswdInput.getText()));



        Button signUpButton = new Button("Sign Up");
        GridPane.setConstraints(signUpButton,1,3);
        signUpButton.setOnAction(s -> mainWindow.setScene(CreateNewAccountScene.changeToCreateAccountScene()));

        Button exitButton = new Button("Exit");
        GridPane.setConstraints(exitButton,1,4);
        exitButton.setOnAction(e -> closeProgram());
        grid.getChildren().addAll(nameLabel,nameInput,pswdLabel,pswdInput,logInButton,signUpButton,exitButton);



        loginScene = new Scene(grid,400,250 );
        mainWindow.setScene(loginScene);



        mainWindow.setOnCloseRequest(e -> {
            e.consume();
            closeProgram();
        });
        mainWindow.show();


    }
    private void checkLoginInput(String username, String password){
        try {
            PreparedStatement stmt = conn.prepareStatement("select SUM(*) from kibice where email = ? and pesel = ?");


            stmt.setString(1,username);
            stmt.setString(2,password);
            ResultSet rs = stmt.executeQuery();
            rs.next();
            int output = rs.getInt(1);
            if(output>0) {
                //TODO:GO TO LOGGED USER
            }else{
                WarningWindow.showErrorMessege("","Wrong username/password");
            }
        }catch(Exception e){
            WarningWindow.showErrorMessege("Error","Sorry. There is an error in database.");
        }


    }
    private void closeProgram(){
        boolean storeAnswer = YesOrNoBox.close("Are you sure you want to close the Application?");
        if(storeAnswer)
            Platform.exit();
    }




}

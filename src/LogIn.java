import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.HBox;

import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class LogIn extends Main {
    public static Scene logInScene(){
        Scene loginScene = setLogInScene();
        loginScene.getStylesheets().add("Style.css");
        return loginScene;
    }
    private static Scene setLogInScene(){
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
        logInButton.setOnAction(e -> checkLoginInput(nameInput.getText(),pswdInput.getText()));

        Button signUpButton = new Button("Sign Up");
        signUpButton.setOnAction(s -> mainWindow.setScene(CreateNewAccount.createNewAccountScene()));

        HBox signButtons = new HBox(10);
        signButtons.getChildren().addAll( logInButton,signUpButton);
        signButtons.setAlignment(Pos.BASELINE_LEFT);
        GridPane.setConstraints(signButtons,1,2);

        Button exitButton = new Button("Exit");
        exitButton.getStyleClass().add("button-red");
        GridPane.setConstraints(exitButton,1,3);
        exitButton.setOnAction(e -> closeProgram());
        grid.getChildren().addAll(nameLabel,nameInput,pswdLabel,pswdInput,signButtons,exitButton);

        return (new Scene(grid,400,260));
    }
    private static void checkLoginInput(String username, String password){
        try {
            PreparedStatement stmt = conn.prepareStatement("select COUNT(ALL) from kibice where email = ? and pesel = ?");


            stmt.setString(1,username);
            stmt.setString(2,password);
            ResultSet rs = stmt.executeQuery();
            rs.next();
            int output = rs.getInt(1);
            if(output>0) {
                mainWindow.setScene(LoggedUser.loggedUserScene(username,password));
            }else{
                ShowMessageWindow.showMessege("","Wrong username/password");
            }
        }catch(Exception e){
            ShowMessageWindow.showMessege("Error","Sorry. There is an error in database.");
        }


    }
}

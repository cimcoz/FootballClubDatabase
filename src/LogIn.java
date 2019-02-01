import javafx.geometry.Insets;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.layout.GridPane;

import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class LogIn extends Main {
    public static Scene logInScene(){
        Scene loginScene = setLogInScene();
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
        GridPane.setConstraints(logInButton,1,2);
        logInButton.setOnAction(e -> checkLoginInput(nameInput.getText(),pswdInput.getText()));



        Button signUpButton = new Button("Sign Up");
        GridPane.setConstraints(signUpButton,1,3);
        signUpButton.setOnAction(s -> mainWindow.setScene(CreateNewAccount.createNewAccountScene()));

        Button exitButton = new Button("Exit");
        GridPane.setConstraints(exitButton,1,4);
        exitButton.setOnAction(e -> closeProgram());
        grid.getChildren().addAll(nameLabel,nameInput,pswdLabel,pswdInput,logInButton,signUpButton,exitButton);

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

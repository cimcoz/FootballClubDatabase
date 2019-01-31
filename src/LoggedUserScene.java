import javafx.application.Application;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.HBox;
import javafx.scene.layout.StackPane;
import javafx.scene.layout.VBox;
import javafx.stage.Modality;
import javafx.stage.Stage;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Stack;
public class LoggedUserScene extends Main{
    Scene loggedUserScene;
    public Scene loggedScene(String username, String password){


        Scene loggedUserScene = setSceneToUserInfo(username,password);
        return loggedUserScene;
    }
    private Scene setSceneToUserInfo(String username, String password){
        GridPane grid = new GridPane();
        grid.setPadding(new Insets(10,10,10,10));
        grid.setVgap(8);
        grid.setHgap(10);

        //labes:
        Label lastNameLabel = new Label("Last name:");
        Label firstNameLabel = new Label("First name:");
        Label personalIdLabel = new Label("Personal ID:");
        Label cityLabel = new Label("City:");
        Label streetLabel = new Label("Street:");
        Label emailLabel = new Label("E-mail:");
        Label birthdayLabel = new Label("Birthday date:");
        //val labels
        Label lastNameVal = new Label();
        Label firstNameVal = new Label();
        Label personalVal = new Label();
        Label cityVal = new Label();
        Label streetVal = new Label();
        Label emailVal = new Label();
        Label birthdayVal = new Label();
        try {
            PreparedStatement stmt = conn.prepareStatement("select nazwisko, imie, pesel, miasto, ulica, email, data_urodzenia from kibice where email = ? and pesel = ? ");
            stmt.setString(1,username);
            stmt.setString(2,password);
            ResultSet rs = stmt.executeQuery();

            rs.next();
                lastNameVal.setText(rs.getString(1));
                firstNameVal.setText(rs.getString(2));
                personalVal.setText(rs.getString(3));
                cityVal.setText(rs.getString(4));
                streetVal.setText(rs.getString(5));
                emailVal.setText(rs.getString(6));
                emailVal.setText(rs.getString(7));
        }catch(Exception e){
            WarningWindow.showErrorMessege("Error","Sorry. There is an error in database.");
        }

        //putting on gridpane
        GridPane.setConstraints(lastNameLabel,0,0);
        GridPane.setConstraints(firstNameLabel,0,1);
        GridPane.setConstraints(personalIdLabel,0,2);
        GridPane.setConstraints(cityLabel,0,3);
        GridPane.setConstraints(streetLabel,0,4);
        GridPane.setConstraints(emailLabel,0,5);
        GridPane.setConstraints(birthdayLabel,0,6);
        GridPane.setConstraints(lastNameVal,1,0);
        GridPane.setConstraints(firstNameVal,1,1);
        GridPane.setConstraints(personalVal,1,2);
        GridPane.setConstraints(cityVal,1,3);
        GridPane.setConstraints(streetVal,1,4);
        GridPane.setConstraints(emailVal,1,5);
        GridPane.setConstraints(birthdayVal,1,6);

        grid.getChildren().addAll(lastNameLabel,firstNameLabel,personalIdLabel,cityLabel,streetLabel,emailLabel,birthdayLabel,lastNameVal,
                firstNameVal,personalVal,cityVal,streetVal,emailVal,birthdayVal);
        return (new Scene(grid,500,500));
    }
}

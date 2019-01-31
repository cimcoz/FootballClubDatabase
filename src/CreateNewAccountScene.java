import javafx.geometry.Insets;
import javafx.scene.control.Label;
import javafx.application.Application;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
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

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.util.Stack;
public class CreateNewAccountScene extends Main{
    public static  Scene changeToCreateAccountScene() {
        Label titleLabel = new Label("Create new account");

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



        //inputs
        TextField lastNameInput = new TextField();
        TextField firstNameInput = new TextField();
        TextField personalIDInput = new TextField();
        TextField cityInput = new TextField();
        TextField streetInput = new TextField();
        TextField emailInput = new TextField();
        TextField birthdayInput = new TextField();



        //putting on gridpane
        GridPane.setConstraints(lastNameLabel,0,0);
        GridPane.setConstraints(firstNameLabel,0,1);
        GridPane.setConstraints(personalIdLabel,0,2);
        GridPane.setConstraints(cityLabel,0,3);
        GridPane.setConstraints(streetLabel,0,4);
        GridPane.setConstraints(emailLabel,0,5);
        GridPane.setConstraints(birthdayLabel,0,6);
        GridPane.setConstraints(lastNameInput,1,0);
        GridPane.setConstraints(firstNameInput,1,1);
        GridPane.setConstraints(personalIDInput,1,2);
        GridPane.setConstraints(cityInput,1,3);
        GridPane.setConstraints(streetInput,1,4);
        GridPane.setConstraints(emailInput,1,5);
        GridPane.setConstraints(birthdayInput,1,6);
        birthdayInput.setPromptText("yyyy-mm-dd");

        grid.getChildren().addAll(lastNameLabel,firstNameLabel,personalIdLabel,cityLabel,streetLabel,emailLabel,birthdayLabel,lastNameInput,
                                    firstNameInput,personalIDInput,cityInput,streetInput,emailInput,birthdayInput);

        Button goBackButton = new Button("Back");
        goBackButton.setOnAction(e -> goBackToPreviousScene());

        Button createAccountButton = new Button("Create");
        createAccountButton.setOnAction(e -> createNewAccount(lastNameInput.getText(),firstNameInput.getText(), personalIDInput.getText() ,cityInput.getText(), streetInput.getText(),
                                                                emailInput.getText(),  birthdayInput.getText()));

        HBox layout = new HBox(10);
        layout.getChildren().addAll(createAccountButton,goBackButton);
        layout.setAlignment(Pos.CENTER);

        GridPane.setConstraints(layout,1,8);
        grid.getChildren().add(layout);


        return (new Scene(grid,500,500));
    }
    private static void goBackToPreviousScene(){
        mainWindow.setScene(loginScene);
    }
    private static void createNewAccount(String lastName, String firstName, String personalID , String city, String street, String mail, String bday){
        try {
            PreparedStatement st = conn.prepareStatement("EXEC zaloz_karte_kibica(?,?,?,?,?,?,?) ");
            st.setString(1, lastName);
            st.setString(2, firstName);
            st.setString(3, personalID);
            st.setString(4, city);
            st.setString(5, street);
            st.setString(6, mail);
            st.setString(7, bday);
            st.executeUpdate();
            WarningWindow.showErrorMessege("", "You created account successfully!");
        }catch(Exception e) {
            WarningWindow.showErrorMessege("Error","Sorry. There is an error in database");
            e.printStackTrace();
        }
    }


}